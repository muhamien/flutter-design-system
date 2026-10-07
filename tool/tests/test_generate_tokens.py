import copy
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
SKILL = ROOT / '.agents/skills/flutter-design-tokens'
SCRIPT = SKILL / 'scripts/generate_tokens.py'
spec = importlib.util.spec_from_file_location('generate_tokens', SCRIPT)
generator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generator)


class TokenGeneratorTest(unittest.TestCase):
    def setUp(self):
        self.data = json.loads((SKILL / 'references/example.tokens.json').read_text())

    def test_generates_all_public_groups(self):
        result = generator.render(self.data)
        for name in ['DsSpace', 'DsRadius', 'DsLayout', 'DsMotion', 'DsBrand']:
            self.assertIn(name, result)
        self.assertIn('ocean(Color(0xFF006A6A))', result)
        self.assertIn('Duration(milliseconds: 200)', result)

    def test_rejects_invalid_values_and_dart_injection(self):
        cases = [('space', 'md', True), ('radius', 'card', -1),
                 ('layout', 'minTouchTarget', 0), ('motion', 'feedback', 1.5),
                 ('motion', 'feedback', 2**63),
                 ('brand', 'ocean', '#ZZZZZZ'), ('space', 'md', float('nan')),
                 ('space', 'md', float('inf'))]
        for group, name, value in cases:
            with self.subTest(group=group, value=value):
                data = copy.deepcopy(self.data)
                data[group][name] = value
                with self.assertRaises(ValueError):
                    generator.render(data)
        for name in ['class', 'values', 'seed', 'bad-name', 'x; import']:
            data = copy.deepcopy(self.data)
            data['brand'][name] = '#000000'
            with self.assertRaises(ValueError):
                generator.render(data)

    def test_rejects_missing_unknown_and_duplicate_groups(self):
        data = copy.deepcopy(self.data)
        del data['brand']
        with self.assertRaises(ValueError):
            generator.render(data)
        data = copy.deepcopy(self.data)
        data['typography'] = {}
        with self.assertRaises(ValueError):
            generator.render(data)
        with self.assertRaises(ValueError):
            json.loads('{"space": {}, "space": {}}', object_pairs_hook=generator.unique_object)

    def test_existing_output_is_preserved_without_force(self):
        with tempfile.TemporaryDirectory() as folder:
            output = Path(folder) / 'tokens.dart'
            output.write_text('hand maintained')
            with self.assertRaises(ValueError):
                generator.write_output(output, generator.render(self.data))
            self.assertEqual(output.read_text(), 'hand maintained')
            generator.write_output(output, generator.render(self.data), force=True)
            self.assertIn('DsSpace', output.read_text())

    def test_invalid_input_never_replaces_output_even_with_force(self):
        with tempfile.TemporaryDirectory() as folder:
            source, output = Path(folder) / 'input.json', Path(folder) / 'tokens.dart'
            source.write_text('{"space": {}}')
            output.write_text('original')
            result = subprocess.run([sys.executable, str(SCRIPT), '--input', str(source),
                                     '--output', str(output), '--force'], capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(output.read_text(), 'original')

    def test_cli_output_and_same_input_protection(self):
        with tempfile.TemporaryDirectory() as folder:
            source = Path(folder) / 'input.json'
            source.write_text(json.dumps(self.data))
            stdout = subprocess.run([sys.executable, str(SCRIPT), '--input', str(source)],
                                    capture_output=True, text=True, check=True)
            self.assertIn('enum DsBrand', stdout.stdout)
            original = source.read_text()
            failure = subprocess.run([sys.executable, str(SCRIPT), '--input', str(source),
                                      '--output', str(source), '--force'], capture_output=True)
            self.assertNotEqual(failure.returncode, 0)
            self.assertEqual(source.read_text(), original)


if __name__ == '__main__':
    unittest.main()
