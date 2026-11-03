# Buku Kas Pribadi

Aplikasi pencatatan keuangan pribadi satu berkas (`index.html`), tanpa server.
Data tersimpan di perangkat (localStorage) dan bisa disinkronkan antar perangkat
lewat Supabase.

**Situs:** https://satoshimorino3-cyber.github.io/buku-kas-pribadi/

## Fitur

- Catat pemasukan, pengeluaran, dan transfer antar dompet
- Anggaran per kategori dan periode
- Utang/piutang dan aset
- Laporan, grafik, serta ekspor CSV
- Cadangan/restore berkas JSON
- Sinkronisasi cloud opsional (Supabase) + realtime

## Menyiapkan sinkronisasi Supabase

1. Buat akun di [supabase.com](https://supabase.com) lalu **New project** (paket gratis).
2. Buka **SQL Editor → New query**, tempel isi [`supabase/schema.sql`](supabase/schema.sql), klik **Run**.
3. Buka **Project Settings → API**, salin:
   - **Project URL** (contoh `https://abcd1234.supabase.co`)
   - **anon public** key
4. Buka aplikasi → **Pengaturan → Sinkronisasi cloud (Supabase)**.
5. Tempel URL dan anon key, klik **Simpan konfigurasi**.
6. Klik **Daftar** dengan email + kata sandi (minimal 6 karakter).
   - Jika diminta konfirmasi email, cek kotak masuk lalu klik tautannya.
   - Ingin langsung masuk tanpa konfirmasi? Matikan **Confirm email** di
     **Authentication → Providers → Email**.
7. Ulangi langkah 4–6 di perangkat lain dengan email yang sama. Data akan
   otomatis tersinkron (last-write-wins berdasarkan `updatedAt`).

> Anon key aman dipakai di browser selama RLS aktif seperti pada skema di atas.
> Jangan pernah memakai **service_role** key di aplikasi.

## Catatan

- Tanpa Supabase, data hanya tersimpan di browser masing-masing. Gunakan
  **Pengaturan → Cadangan & pemulihan → Unduh cadangan (JSON)** untuk pindah perangkat.
- Project Supabase gratis akan di-pause setelah lama tidak dipakai; buka dashboard
  untuk mengaktifkan kembali.
