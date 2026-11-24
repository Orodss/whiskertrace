# WhiskerTrace — Design System

## Sumber dan arah visual

Dokumen ini mentranskripsikan `design system.png` menjadi panduan implementasi. Gambar asli tetap disimpan sebagai referensi. Bagian palet, tipografi sumber, dan komponen pixel berasal dari gambar; ukuran layar, perilaku tombol, aksesibilitas, dan aturan layout merupakan tambahan untuk game.

Nuansa: misteri yang hangat, tenang, dan ramah. Gunakan kertas krem, aksen warna lembut, sudut bersiku, serta ilustrasi detektif pixel art. Hindari efek neon, gradien, dan dekorasi yang bersaing dengan konten investigasi.

## Palet dari referensi

| Token | Nama | Hex | Peran |
|---|---|---|---|
| `background` | Krem | `#F8EBD9` | Latar utama dan kertas kasus |
| `accent` | Aprikot | `#DFA98F` | Tombol utama dan aksen kecil |
| `secondary` | Sage | `#B5B49B` | Bingkai sudut dan hover |
| `decorative` | Taupe | `#9B7A67` | Ilustrasi dan dekorasi pendukung |
| `ink` | Cokelat | `#624A3D` | Teks, garis tegas, dan fokus keyboard |

Gunakan cokelat untuk teks di atas krem, aprikot, dan sage. Taupe tidak digunakan untuk teks kecil karena kontrasnya lebih rendah. Teks tombol pressed menggunakan krem di atas cokelat. Status harus disertai kata atau ikon, bukan warna saja.

## Tipografi

### Spesifikasi asli guidebook

| Peran | Font | Ukuran sumber |
|---|---|---|
| Judul | Pixelion | 32–42 pt |
| Subjudul dan label | Roboto Mono | 14–18 pt |
| Isi | DM Sans | 10–12 pt |

Nama font ditranskripsikan dari gambar; file font dan lisensinya belum tersedia di `assets/`. Judul menu dan tombol Start menggunakan Pixelify Sans weight 600 dari Google Fonts, dibundel lokal di `assets/fonts/PixelifySans.ttf` bersama lisensi SIL OFL 1.1. Font pixel ini dipilih sebagai adaptasi tema; teks panjang tetap memakai font bawaan Godot agar mudah dibaca.

### Adaptasi ke layar game

- Judul halaman awal: 52 px pada kanvas 1280 × 800.
- Tombol Start: Pixelify Sans 28 px; tombol lain: 22 px.
- Teks umum: 18 px; judul briefing: 32 px.
- Label metadata/petunjuk keyboard: 14–16 px.
- Ukuran pt pada guidebook tidak disalin langsung sebagai ukuran UI. Utamakan keterbacaan pada ukuran jendela yang digunakan.

## Aset dan bahasa bentuk

- Logo: `assets/logo/WHISKERTRACE.png`, ilustrasi kepala kucing detektif dengan kaca pembesar. Gunakan aset asli tanpa distorsi atau pemotongan; pertahankan rasio dengan `TextureRect`.
- Logo tampil 200 × 200 px dengan filter nearest. Versi terbaru logo memiliki latar transparan; pertahankan alpha saat impor.
- Referensi juga memuat ikon folder, jejak kaki, dan bingkai sudut. Ikon folder/jejak kaki belum tersedia sebagai aset terpisah; tidak diperlukan untuk halaman pertama.
- Bingkai sudut direalisasikan sebagai garis sage bersiku dan kotak aprikot kecil, memakai gambar vektor bawaan Godot.
- Komponen investigasi memakai sudut persegi; tombol Start merupakan pengecualian dengan radius 20 px tanpa garis border.
- Sumber serta lisensi logo belum tercantum di repo; lengkapi sebelum distribusi publik.

## Halaman pertama: Main Menu

Urutan konten terpusat: logo transparan terbaru, judul **WHISKERTRACE**, kucing pixel mengintip di belakang tombol **START**, dan petunjuk keyboard. Panel krem besar, header Meowtopia, subjudul, tagline, serta kontrol animasi dihapus sesuai revisi pengguna. Background kota terlihat penuh. Kucing dekoratif mengabaikan input mouse agar tombol tetap dapat diklik.

### Layout dan skala

- Kanvas dasar: 1280 × 800; ukuran jendela awal: 1152 × 720.
- Minimum jendela: 800 × 600. Gunakan stretch `canvas_items` dan container terpusat untuk penyesuaian rasio layar.
- Margin bingkai: 32 px; metadata: 72 px dari kiri. Skala jarak: 8, 12, 16, 24, 32, 40, 64 px.
- Kolom utama memakai jarak 16 px, dengan tambahan ruang sebelum tombol.
- Tombol Start: minimal 272 × 64 px pada kanvas dasar.
- Tidak perlu scroll pada halaman awal di ukuran desktop yang didukung. Uji 800 × 600, 1280 × 800, dan 1920 × 1080 untuk memastikan judul, footer, dan tombol tidak bertabrakan.

### State dan interaksi

| State | Tampilan/perilaku |
|---|---|
| Normal | Aprikot, teks cokelat, radius 20 px, tanpa border |
| Hover | Sage, kursor pointer |
| Focus | Tint cokelat transparan pada permukaan tombol, tanpa garis border |
| Pressed | Latar cokelat, teks krem |
| Aktivasi | Klik, Enter, atau Space melalui tombol native Godot |

Start mendapat fokus ketika menu muncul. Start membuka halaman penuh **Pawcity** dengan tiga area misi berjajar mengikuti sketsa pengguna. Mission 1 tampil tanpa gembok; Mission 2 dan Mission 3 ditandai ikon gembok tanpa tulisan status. Ketiganya bersifat display-only dan belum dapat ditekan. Kembali atau Escape membuka menu dan mengembalikan fokus ke Start.

Empat kucing pixel berjalan otomatis dari kiri ke kanan dengan langkah kaki, gerak ekor, dan sedikit gerak badan. Tidak ada kontrol animasi pada menu. Animasi berhenti selama halaman misi terbuka dan dilanjutkan saat panel ditutup. Tidak ada kedipan, audio autoplay, atau koneksi jaringan.

## Dunia pixel pada halaman Start

- Background lokal: `assets/backgrounds/meowtopia.png`, dibuat dengan tool Imagegen bawaan. Rumah/toko, pohon sage, langit krem, dan jalan batu memakai palet tema serta variasi shade dekatnya.
- Komposisi: bangunan di sisi kiri/kanan, area tengah tenang untuk menu, jalur horizontal di bawah untuk kucing. `TextureRect` menggunakan keep-aspect-covered dan filter nearest.
- Kucing: empat karakter pixel sederhana digambar langsung oleh `scripts/pixel_cats.gd`, dengan warna aprikot, sage, taupe, dan krem. Tidak membutuhkan sprite library, fisika, atau plugin.
- Grid karakter 4 px; gambar ulang dibatasi sekitar 10 kali/detik. Kecepatan masing-masing 72, 52, 84, dan 64 piksel kanvas/detik. Posisi membungkus setelah karakter sepenuhnya keluar layar.
- Background dan karakter mengabaikan input mouse agar tombol menu tetap dapat diklik.
- Tes mencakup arah gerakan, wrapping setelah sesi panjang, jeda, serta pemulihan gerakan setelah halaman misi ditutup.

### Prompt aset background (Imagegen bawaan)

“Create a production game background image, wide landscape 16:10, for a cozy cat detective game called WhiskerTrace. Pixel art world, authentic crisp large square pixels, limited muted palette strictly cream #F8EBD9, apricot #DFA98F, sage #B5B49B, taupe #9B7A67, brown #624A3D and close lighter shades. A charming small town Meowtopia at warm afternoon: quaint shopfronts and detective office along left and right edges, sage trees, little square shrubs, rooftop chimneys, distant low rooftops, cream sky and blocky clouds. Broad horizontal cobbled walking path across bottom 18% of image, level side-scrolling view for animated cats added later. Center 45% of composition should be quiet pale cream sky/open plaza with very low detail and contrast, leaving ample space for a centered game logo/title/button UI overlaid in code. Detailed charming environmental storytelling near edges, no text, no letters, no signs with text, no UI, no logos, no characters or cats baked in. No gradients, no blur, no photorealism, no smooth vector curves, no perspective road vanishing into center. Crisp stepped silhouettes and restrained retro pixel dithering. Scene should fill image edge to edge.”

## Implementasi dan menjalankan

- Engine yang digunakan: **Godot Standard 4.5.1 stable**, renderer Compatibility. Ini versi yang dipilih untuk implementasi, bukan klaim versi terbaru.
- Impor `project.godot` dengan editor lalu tekan **F6** untuk scene aktif atau **F5** untuk proyek.
- Scene: `scenes/main_menu.tscn`; interaksi: `scripts/main_menu.gd`; kucing pengintip: `scripts/peeking_cat.gd`; gaya bersama: `themes/paw_theme.tres`.
- Tidak ada plugin atau dependensi runtime tambahan.
- Jalankan pemeriksaan interaksi dengan `godot --headless --path . --script tests/main_menu_test.gd` (sesuaikan nama executable lokal).
- Jalankan skrip uji tanpa `--headless` untuk menghasilkan screenshot `build/main-menu.png` dari renderer Godot.

## Pemeriksaan sebelum melanjutkan

- Logo tidak terdistorsi; semua teks terbaca dan tidak terpotong.
- Klik dan keyboard membuka halaman misi; Back dan Escape menutupnya.
- Fokus terlihat dan tetap pada tombol Kembali saat halaman misi terbuka.
- Tampilan diperiksa pada ukuran minimum, dasar, dan widescreen.
- Gambar, teks, dan tema termuat tanpa jaringan.

Referensi implementasi: [TextureRect](https://docs.godotengine.org/en/stable/classes/class_texturerect.html), [Button](https://docs.godotengine.org/en/stable/classes/class_button.html).

### Bayangan tombol Start

Bayangan cokelat #624A3D: normal opacity 32%, size 5 px, offset (0, 6); hover opacity 36%, size 6 px, offset (0, 8); pressed opacity 24%, size 2 px, offset (0, 2). Radius tetap 20 px tanpa garis border. Bayangan fokus tidak ditumpuk lagi.

## Pawcity — pilihan misi

Scene: `scenes/mission_select.tscn`; ilustrasi pixel native dan label: `scripts/mission_select.gd`. Area pertama memiliki bendera aprikot; area terkunci memakai warna lebih redup, dan ikon gembok. Mission 3 adalah placeholder visual sesuai permintaan pengguna, belum memiliki cerita atau aturan permainan. Pawcity adalah judul layar pilihan misi; latar cerita Meowtopia pada README tidak diubah. Tidak ada dependensi baru.

## Revisi visual Pawcity

Tulisan LOCKED, MISI PERTAMA, dan Peta misi dihapus. Semua misi tetap noninteraktif. Background taman kota lokal: `assets/backgrounds/pawcity.png`, dibuat dengan Imagegen bawaan.

Pemeran dianimasikan oleh `scripts/pawcity_cast.gd`: Whiskers oranye bertopi dan jas, Purrcival putih berdasi biru lembut, Clawford gelap berhoodie dan kacamata, Mochi abu-abu berpita merah muda. Wajah dibuat lebih besar dengan kedua mata, highlight, hidung, mulut, telinga dalam, dan kumis. Kaki, ekor, serta badan bergerak saat berjalan kiri ke kanan di jalur bawah, tanpa menutupi label misi. Animasi hanya diperbarui saat halaman terlihat; kembali ke menu menghentikan pembaruan pemeran Pawcity. Tidak ada plugin tambahan.
