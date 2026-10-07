#!/usr/bin/env python3
"""Validate repository skill discovery, metadata, and local reference links."""
from pathlib import Path
import re
import sys

import yaml

ROOT = Path(__file__).resolve().parents[1]


def validate(folder):
    text = (folder / 'SKILL.md').read_text(encoding='utf-8')
    match = re.match(r'^---\n(.*?)\n---\n', text, re.S)
    if not match:
        raise ValueError('Missing YAML frontmatter')
    data = yaml.safe_load(match.group(1))
    if not isinstance(data, dict):
        raise ValueError('Frontmatter must be a mapping')
    if data.get('name') != folder.name or not re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', folder.name):
        raise ValueError('Name must match the skill directory and use kebab-case')
    if len(folder.name) > 64:
        raise ValueError('Name exceeds 64 characters')
    description = data.get('description')
    if not isinstance(description, str) or not description.strip() or len(description) > 1024:
        raise ValueError('Description must be a non-empty string under 1025 characters')
    if '[TODO:' in text:
        raise ValueError('Unfinished scaffold')
    ui = yaml.safe_load((folder / 'agents/openai.yaml').read_text())
    interface = ui.get('interface', {})
    if not interface.get('display_name'):
        raise ValueError('Missing display name')
    short = interface.get('short_description', '')
    if not 25 <= len(short) <= 64:
        raise ValueError('UI short description must contain 25–64 characters')
    if f'${folder.name}' not in interface.get('default_prompt', ''):
        raise ValueError('Default prompt must invoke its own skill name')
    for document in [folder / 'SKILL.md', *folder.glob('references/*.md')]:
        for link in re.findall(r'\[[^\]]+\]\(([^)]+)\)', document.read_text()):
            if re.match(r'^[a-z]+://', link) or link.startswith('#'):
                continue
            target = (document.parent / link.split('#')[0]).resolve()
            if not target.is_file():
                raise ValueError(f'Broken reference in {document.name}: {link}')


def main():
    folders = sorted((ROOT / '.agents/skills').glob('*/SKILL.md'))
    if not folders:
        print('No repository skills found', file=sys.stderr)
        return 1
    errors = []
    for source in folders:
        try:
            validate(source.parent)
            print(f'OK {source.parent.name}')
        except (OSError, ValueError, yaml.YAMLError, AttributeError, TypeError) as error:
            errors.append(f'{source.parent.name}: {error}')
    for error in errors:
        print(error, file=sys.stderr)
    return bool(errors)


if __name__ == '__main__':
    sys.exit(main())
