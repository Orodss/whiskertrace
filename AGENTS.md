# Panduan Stack dan Dependensi WhiskerTrace

## Acuan dan cakupan

- Gunakan `README.md` sebagai sumber kebutuhan gameplay, cerita, karakter, dan bukti.
- Target: game investigasi 2D untuk PC, single-player, berjalan offline.
- Proyek diinisialisasi dengan Godot Standard 4.5.1 stable; halaman awal berada di `scenes/main_menu.tscn`. Gunakan versi editor dan export templates yang sama.
- Gunakan `design.md` sebagai panduan visual, dengan `design system.png` sebagai referensi asli.
- Start membuka halaman Pawcity dengan tiga area misi noninteraktif. Mission 2 dan 3 ditandai ikon gembok tanpa tulisan status. Mission 3 hanya placeholder visual sesuai permintaan pengguna, bukan tambahan kasus yang sudah memiliki spesifikasi. Background taman dan empat pemeran bergerak berada di belakang UI, dengan input dekorasi diabaikan.
- README bagian 15 menyebut versi awal satu kasus, sedangkan bagian 3, 13, dan 16 mencakup dua kasus. Implementasikan Case #001 sebagai tahap awal yang dapat dimainkan sampai selesai, lalu Case #002 memakai sistem yang sama. Target lengkap tetap dua kasus.

## Stack utama

| Bagian | Pilihan | Alasan dan penggunaan |
|---|---|---|
| Engine | Godot 4.x stable, edisi Standard | Menyediakan UI, grafis 2D, input, audio, dan ekspor desktop dalam satu alat. |
| Bahasa | GDScript dengan type hints | Terintegrasi dengan engine; tidak membutuhkan SDK .NET atau toolchain C++. |
| Renderer | Compatibility | Sesuai untuk game 2D sederhana dan jangkauan perangkat yang lebih luas. |
| Antarmuka | Node `Control` dan `Container`, `Theme` bersama | Menangani desktop PawOS, panel aplikasi, daftar dokumen, dialog, dan tombol. |
| Data kasus | Custom `Resource` disimpan sebagai `.tres` | Memisahkan isi kasus dari logika; data bertipe dan dapat diedit melalui Inspector. |
| State permainan | Satu Autoload `GameState` dan signal bawaan | Menyimpan kasus aktif, bukti terkumpul, pilihan tersangka, dan status penyelesaian. |
| Animasi | `Tween` dan `AnimationPlayer` | Cukup untuk transisi panel, hover, dan ekspresi detektif. |
| Audio | `AudioStreamPlayer` | Memutar musik dan efek suara lokal. |
| Distribusi | Ekspor desktop Godot; Windows x86_64 sebagai target awal | Menghasilkan game yang dapat dimainkan tanpa memasang editor Godot. Target PC lain dapat ditambahkan bila diperlukan. |

Godot dipilih karena kebutuhan utama adalah antarmuka desktop interaktif dan grafis 2D, dengan sedikit logika permainan. Utamakan fitur bawaan agar jumlah dependensi dan pekerjaan integrasi tetap kecil. Ukuran unduhan, penggunaan RAM, dan performa tetap perlu diukur pada build nyata; pilihan ini bukan klaim bahwa Godot adalah engine paling kecil.

## Dependensi

### Wajib saat pengembangan

1. **Godot Editor Standard 4.x stable**: untuk membuat scene, menulis GDScript, mengimpor aset, dan menjalankan game. Pilih satu versi stable spesifik saat inisialisasi, catat versi lengkapnya di dokumentasi pengembangan, dan gunakan versi yang sama dalam tim.
2. **Godot Export Templates dengan versi persis sama dengan editor**: diperlukan saat mengekspor build desktop. Unduh sekali pada tahap persiapan.
3. **Git**: untuk versi kode, scene, resource, dan aset sumber.

### Dependensi runtime

- Runtime Godot disertakan dalam hasil ekspor.
- **Tidak ada paket atau plugin pihak ketiga yang diwajibkan untuk versi awal.**
- Seluruh gambar, font, audio, dan data kasus harus dibundel secara lokal; catat sumber serta lisensi aset.
- Pemain tidak membutuhkan Node.js, Python, .NET SDK, database, akun, atau koneksi internet. Persiapan editor/templates dapat membutuhkan internet, tetapi gameplay tidak.

### Opsional jika fiturnya dikerjakan

| Kebutuhan | Pilihan bawaan | Ketentuan |
|---|---|---|
| Simpan progres | `FileAccess` + `JSON`, lokasi `user://` | Simpan ID kasus/bukti dan status, sertakan versi format; tangani file hilang atau rusak. |
| Pengaturan suara/tampilan | `ConfigFile`, lokasi `user://` | Tambahkan ketika menu pengaturan dibutuhkan. |
| Timer atau jeda hint | Node `Timer` | Fitur tambahan sesuai README, setelah alur utama selesai. |
| Pengujian logika | GDScript `assert` melalui skrip headless | Memeriksa aturan tuduhan dan isolasi data antar kasus tanpa framework tambahan. |

Jangan menambahkan backend, database server, layanan cloud, framework web, engine fisika tambahan, sistem dialog eksternal, atau plugin UI untuk kebutuhan yang sudah dapat ditangani stack ini. Setiap dependensi baru harus memiliki kebutuhan konkret yang tidak praktis dipenuhi fitur bawaan.

## Pemetaan fitur README

| Fitur | Implementasi yang disarankan |
|---|---|
| Menu, pemilihan kasus, briefing, hasil, credits | Scene UI dengan `Control`, `Label`, `Button`, dan `TextureRect`. |
| Desktop PawOS | Scene utama berisi panel aplikasi; panel berada di dalam jendela game. |
| Jendela dapat dipindahkan | `PanelContainer` dengan bilah judul; tangani input mouse untuk drag dan batasi posisi agar tetap dapat dijangkau. |
| PawFiles | `Tree` untuk folder/file dan `RichTextLabel` di dalam `ScrollContainer` untuk isi dokumen. |
| MeowMail dan PawLogs | Daftar item, panel detail, serta teks yang dapat di-scroll. |
| Cat Profiles | Kartu profil dengan gambar lokal dan deskripsi sesuai kasus aktif. |
| Evidence Board | Kartu bukti dalam `GridContainer`; dukung tambah, buka, hapus, dan pilih bukti pendukung. |
| Final Accusation | Fungsi validasi GDScript berdasarkan ID tersangka dan himpunan ID bukti wajib dari data kasus. |
| Respons Detective Whiskers | Gambar ekspresi dan dialog; animasi sederhana bila diperlukan. |

## Aturan implementasi

- Pisahkan scene UI, logika investigasi, dan konten kasus. Gunakan struktur sederhana seperti `scenes/`, `scripts/`, `data/cases/`, dan `assets/`; manfaatkan aset yang sudah tersedia.
- Gunakan ID stabil dan unik dalam lingkup kasus untuk tersangka dan bukti. Jangan memakai teks tampilan sebagai identitas data.
- Setiap kasus memuat briefing, dokumen, email, log, profil tersangka, bukti, ID pelaku, dan ID bukti wajib. Jangan menaruh jawaban kasus langsung di skrip UI.
- Tuduhan benar memerlukan tersangka yang benar dan seluruh bukti wajib sesuai README. Bukti tambahan tidak menggantikan bukti wajib. Tuduhan salah harus memungkinkan pemain melanjutkan investigasi.
- Reset state investigasi ketika memulai kasus baru. Bukti Case #001 tidak boleh ikut terbawa ke Case #002.
- Semua dokumen, email, aktivitas USB, dan tautan merupakan simulasi lokal. PawFiles tidak membaca dokumen pribadi pemain; MeowMail tidak mengakses email nyata.
- Gunakan event/signal untuk perubahan UI. Hindari polling setiap frame untuk teks, daftar bukti, atau state yang hanya berubah saat input.
- Gunakan font lokal yang mudah dibaca, kontras yang cukup, fokus keyboard yang terlihat, dan panel teks yang dapat di-scroll. Hindari mengandalkan warna saja untuk menandai bukti.
- Gunakan aset 2D sesuai ukuran tampilannya; hindari tekstur besar, efek 3D, dan shader kompleks yang tidak dibutuhkan.
- Pertahankan `.godot/` dan hasil build di luar version control. Simpan metadata `.uid` yang dihasilkan Godot bersama sumber terkait.

## Verifikasi saat implementasi tersedia

- Uji alur lengkap: menu → pilih kasus → briefing → kelima aplikasi → kumpulkan bukti → tuduhan → hasil → menu.
- Uji tersangka benar dengan bukti lengkap, bukti kurang, tersangka salah, percobaan ulang, dan perpindahan kasus.
- Uji klik ganda file, drag jendela, scroll dokumen, serta penambahan/penghapusan bukti.
- Jalankan build hasil ekspor tanpa jaringan; pastikan semua aset dan data kasus tersedia.
- Ukur waktu startup, RAM, dan kelancaran UI pada PC target sebelum menetapkan klaim performa atau spesifikasi minimum.

## Referensi teknis resmi

- [Renderer Godot](https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html)
- [Fitur bawaan Godot](https://docs.godotengine.org/en/stable/about/list_of_features.html)
- [Lokasi data res:// dan user://](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html)
- [Command line dan eksekusi headless](https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html)
