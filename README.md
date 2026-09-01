# Cloud Infrastructure & Application Deployment (SIRCLO Practical Test)

Repositori ini berisi konfigurasi Terraform dan Docker Compose untuk otomatisasi pembuatan infrastruktur cloud di AWS serta mendistribusikan aplikasi WordPress berbasis Docker.

## Prasyarat System

Sebelum melakukan deployment, pastikan beberapa perkakas berikut sudah terinstal di perangkat lokal kamu:
- Terraform (versi >= 1.0.0)
- AWS CLI (terkonfigurasi dengan access key yang valid)
- Klien OpenSSH (atau PowerShell untuk pengguna Windows)

---

## Konfigurasi

1. Pengaturan Kredensial AWS  
   Konfigurasikan profil AWS kamu di terminal lokal:
   aws configure

2. Pembuatan SSH Key Pair  
   Buat SSH key pair untuk akses masuk ke instance EC2:
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

3. Pengaturan Variabel Lingkungan Aplikasi  
   Salin berkas templat lingkungan di dalam direktori app/:
   cp app/.env.example app/.env
   (Catatan: Isilah app/.env dengan kata sandi yang aman sebelum aplikasi dijalankan).

---

## Langkah Deployment

1. Masuk ke direktori kerja Terraform:
   cd terraform

2. Inisialisasi ruang kerja Terraform:
   terraform init

3. Tinjau rencana eksekusi infrastruktur:
   terraform plan

4. Terapkan konfigurasi infrastruktur ke cloud:
   terraform apply -auto-approve

5. Setelah proses selesai, Terraform akan menampilkan IP publik dari server:
   Outputs:
   public_ip = "x.x.x.x"

---

## Verifikasi Aplikasi

1. Akses Aplikasi WordPress  
   Tunggu 2 hingga 3 menit setelah pemrosesan selesai agar skrip inisialisasi awal server tuntas. Kemudian buka peramban (browser) dan akses:
   http://<PUBLIC_IP_ADDRESS>:8080
   Halaman konfigurasi awal WordPress akan tampil di layar.

2. Akses Server via SSH  
   Untuk masuk ke dalam server VM:
   ssh -i ~/.ssh/id_rsa ubuntu@<PUBLIC_IP_ADDRESS>

3. Memeriksa Status Kontainer  
   Di dalam VM, pastikan kedua layanan (wordpress dan db) berjalan dengan lancar:
   sudo docker compose -f /home/ubuntu/app/app/docker-compose.yml ps

---

## Pembersihan Resource (Cleanup)

Untuk menghapus seluruh infrastruktur yang telah dibuat di AWS agar tidak menimbulkan biaya tambahan:

cd terraform
terraform destroy -auto-approve
