# AI skills untuk Flutter design system

Lima skill berada di `.agents/skills`, sehingga instruksinya ikut version control dan dapat digunakan kontributor yang bekerja dengan agen AI. Setiap folder berisi `SKILL.md` dan metadata Codex `agents/openai.yaml`.

| Skill | Kapan digunakan | Hasil yang diharapkan |
|---|---|---|
| `$flutter-design-system` | Permintaan melintasi beberapa lapisan | Implementasi token/theme/component/pattern yang diperlukan, beserta integrasi katalog |
| `$flutter-design-tokens` | Membuat atau mengubah fondasi desain | Primitive Dart, mapping semantik yang diperlukan, dan analisis consumer |
| `$flutter-theme` | Mengubah identitas aplikasi secara global | ColorScheme, TextTheme, component themes, atau ThemeExtension |
| `$flutter-component` | Membuat kontrol reusable | Komponen dengan API, state, export, katalog, dan test yang relevan |
| `$flutter-pattern` | Membuat komposisi/layout generik | Pattern responsif dengan slot API dan batas tanggung jawab jelas |

## Menggunakan dalam Codex

Buka clone repositori ini sebagai workspace proyek, lalu pilih skill dari UI atau sebutkan namanya pada prompt. Skill baru mungkin perlu ditemukan ulang dengan membuka chat/sesi proyek baru bila belum muncul pada sesi yang sedang berjalan. Skill tersedia sebagai file di repositori; perubahan ini tidak memasang skill global pada komputer.

Instruksi umum ditempatkan di `AGENTS.md`, sedangkan workflow khusus berada di skill. Pendekatan repository-local ini mengikuti [contoh resmi OpenAI](https://developers.openai.com/blog/skills-agents-sdk).

Contoh prompt:

```text
$flutter-design-tokens
Tambahkan brand amber dengan seed #B45309. Pertahankan spacing dan public API
lainnya. Integrasikan pilihan brand ke katalog dan verifikasi light/dark mode.
```

```text
$flutter-theme
Tambahkan semantic warning melalui ThemeExtension. Tentukan pasangan warna
light/dark, implementasikan copyWith/lerp, dan tampilkan contoh di katalog.
```

```text
$flutter-component
Buat DsPasswordField dengan toggle visibility, label, validator, controller,
dan autofill. Gunakan tema input yang sudah ada dan uji interaksinya.
```

```text
$flutter-pattern
Buat DsEmptyState dengan slot ikon, judul, deskripsi, dan aksi opsional.
Dukung lebar 320 serta text scale 200%, tanpa logika bisnis atau routing.
```

```text
$flutter-design-system
Buat fondasi UI onboarding: tema brand yang tersedia, DsStepIndicator,
dan pattern layout langkah. Integrasikan state yang relevan ke katalog.
```

Permintaan singkat dibantu dengan asumsi yang mengikuti proyek. Sertakan desain atau spesifikasi jika warna persis, font, variant, atau perilaku harus mengikuti kontrak tertentu.

## Apa yang dilakukan skill

Agen membaca arsitektur dan implementasi aktual, memilih lapisan yang tepat, menghasilkan perubahan kode, memperbarui public export/katalog bila diperlukan, lalu menjalankan pemeriksaan yang relevan. Skill bukan model terpisah dan bukan engine yang otomatis mengeksekusi prompt tanpa agen.

Skill tidak membuat HTTP client, repository domain, router, atau state management di package UI. Skill juga tidak memberikan izin untuk commit, push, publish, atau release. Workflow repo mensyaratkan working branch dan pull request; `main` tidak di-push langsung.

`SKILL.md` dapat dibaca agen lain yang mendukung instruksi berbasis file. Discovery otomatis dan sintaks pemanggilan mengikuti produk yang digunakan; metadata `agents/openai.yaml` khusus Codex. Bila mengadaptasi bundle, pertahankan kelima folder sebagai saudara agar referensi router tetap tersedia. Jika dipakai pada repo lain, sesuaikan pemetaan path dan konvensi API setelah inspeksi proyek.

## Helper JSON → Dart

Skill token menyertakan helper tanpa dependency eksternal. Format input adalah JSON sederhana yang khusus untuk proyek ini, bukan schema DTCG atau export Figma langsung.

Dari root repo:

```sh
python3 .agents/skills/flutter-design-tokens/scripts/generate_tokens.py \
  --input .agents/skills/flutter-design-tokens/references/example.tokens.json \
  --output /tmp/nusantara-generated-tokens.dart
```

Helper menghasilkan `DsSpace`, `DsRadius`, `DsLayout`, `DsMotion`, dan `DsBrand`. Input invalid ditolak sebelum penulisan; output yang sudah ada ditolak kecuali `--force` diberikan. Generator tidak merge otomatis. Untuk perubahan parsial, generate file sementara lalu bandingkan dan merge perubahan yang diminta.

Lihat [kontrak token](../.agents/skills/flutter-design-tokens/references/token-input.md) untuk aturan nama, tipe, dan satuan. Typography, semantic colors, dan ThemeExtension dikerjakan oleh agen melalui skill theme.

## Validasi bundle

```sh
python3 -m pip install -r tool/requirements-skills.txt
python3 tool/validate_skills.py
python3 -m unittest discover -s tool/tests -v
```

Validator memeriksa discovery metadata, nama, prompt UI, scaffold, dan referensi lokal. Test helper memeriksa input invalid, proteksi file, serta output CLI. CI menjalankan keduanya sebagai job tersendiri. Job Flutter juga menghasilkan sample primitive Dart sementara untuk pemeriksaan format/analyzer, kemudian menghapusnya setelah pemeriksaan. Pemeriksaan aplikasi dan build web yang sudah ada tetap berjalan.

Validasi struktur tidak membuktikan semua prompt menghasilkan desain yang tepat. Setiap implementasi hasil skill tetap perlu diperiksa dengan analyze/test dan review visual sesuai perubahan. Belum ada evaluasi perilaku agen secara otomatis atau test golden untuk output AI.
