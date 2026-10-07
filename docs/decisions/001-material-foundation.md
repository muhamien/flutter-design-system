# ADR-001: Kustomisasi Material 3 sebagai fondasi design system

Status: Proposed
Tanggal: 7 Oktober 2026
Deciders: Tim aplikasi dan design system

## Konteks

Aplikasi Flutter membutuhkan identitas visual yang konsisten, dukungan tema terang/gelap, komponen reusable, serta jalur pertumbuhan lintas fitur dan aplikasi. Belum ada identitas brand atau kebutuhan domain spesifik yang diberikan. Contoh memakai dua brand ilustratif dan tidak menetapkan state management aplikasi.

## Keputusan

Gunakan package UI terpisah yang memetakan token ke ColorScheme, TextTheme, ThemeExtension, dan component themes Material 3. Bungkus widget Material hanya untuk kontrak perilaku yang berulang. Logika bisnis berada di fitur.

## Opsi yang dipertimbangkan

| Opsi | Kompleksitas | Konsistensi | Biaya pemeliharaan |
|---|---|---|---|
| Styling lokal pada setiap halaman | Rendah saat mulai | Sulit dijaga lintas fitur | Naik seiring duplikasi |
| Material themes + wrapper terpilih | Sedang | Terpusat, identitas brand dapat dikonfigurasi | Sedang; perlu mengikuti perubahan SDK |
| Semua widget digambar sendiri | Tinggi | Kontrol penuh | Tinggi untuk state, semantics, keyboard, dan platform |

Opsi kedua dipilih karena menggunakan perilaku Material yang sudah tersedia dan memberi satu tempat untuk konfigurasi visual. Pembungkus penuh setiap widget akan menambah API yang perlu dipelihara tanpa manfaat yang selalu sepadan.

## Konsekuensi

- Perubahan token/tema berdampak luas sehingga membutuhkan review visual.
- Wrapper tidak mengekspos semua properti Material; API baru ditambahkan berdasarkan kebutuhan nyata.
- Upgrade Flutter dapat mengubah default visual dan tipe component theme; pin SDK dan review screenshot saat upgrade.
- Multi-brand lebih mudah untuk warna, tetapi font/shape per brand membutuhkan pengembangan konfigurasi.
- Package tidak bergantung pada domain aplikasi, sehingga dapat dipakai lintas proyek.

## Action items

- [x] Sediakan tokens, themes, komponen, pattern layout, dan demo.
- [x] Tulis test kontrak loading, form, dan tema.
- [ ] Jalankan analyze/test dengan SDK tim.
- [ ] Validasi visual, aksesibilitas, dan token brand sebenarnya.
- [ ] Tetapkan ownership, versioning, dan pipeline CI sebelum distribusi produksi.
