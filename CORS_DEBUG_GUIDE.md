# 🔧 CORS Debugging - Step by Step Guide

## Error yang Masih Muncul?

Silakan ikuti langkah-langkah debugging ini:

---

## STEP 1: Verifikasi Backend File Structure

Pastikan file-file ini ada dan berada di lokasi yang benar:

```
app/
├── Config/
│   └── Filters.php          ← Updated?
└── Filters/
    └── Cors.php             ← Created?
```

### Cek: Apakah folder `app/Filters/` sudah ada?
- Jika BELUM ada → Buat folder `Filters` di dalam folder `app`
- Jika SUDAH ada → Lanjut ke STEP 2

---

## STEP 2: Verifikasi Syntax PHP

Buka terminal di folder backend dan run:

```powershell
# Cek syntax Filters.php
php -l app/Config/Filters.php

# Cek syntax Cors.php
php -l app/Filters/Cors.php
```

**Expected output:**
```
No syntax errors detected in file
```

Jika ada error → Tolong share error message-nya

---

## STEP 3: Test dengan Postman atau Insomnia

1. Download **Postman** atau **Insomnia** (tool HTTP client)
2. Buat request baru:
   - Method: `OPTIONS`
   - URL: `http://192.168.100.22:8080/buku/1`
   - Headers:
     ```
     Origin: http://localhost:64625
     Access-Control-Request-Method: DELETE
     ```
3. Send request
4. Check **Response Headers** tab - ada `Access-Control-Allow-Origin` tidak?

---

## STEP 4: Browser DevTools Deep Dive

1. Buka Flutter Web app
2. Press `F12` → DevTools
3. Tab **Network**
4. Coba DELETE data
5. Lihat semua request yang muncul:
   - Cari request bertipe `xhr` (XmlHttpRequest)
   - Klik pada **OPTIONS request** (kalau ada)
   - Tab **Headers** → Scroll ke **Response Headers**
   - Cek apakah `Access-Control-Allow-Origin` ada

**Screenshot atau copy-paste dari Response Headers:**
```
[PASTE HEADERS HERE]
```

---

## STEP 5: Check Backend Log

Cek file log backend:

```powershell
# Pergi ke folder backend CI4
# Cari file log terbaru di folder writable/logs/
# Contoh path: C:\path\to\backend\writable\logs\log-2025-12-06.log

# Buka file dan cari error messages
```

Share isi log file jika ada error.

---

## STEP 6: Simplest Version - Test Dengan curl

Buka PowerShell dan jalankan:

```powershell
# Test OPTIONS request (preflight)
$headers = @{
    "Origin" = "http://localhost:64625"
    "Access-Control-Request-Method" = "DELETE"
}

$response = Invoke-WebRequest -Uri "http://192.168.100.22:8080/buku/1" `
    -Method OPTIONS `
    -Headers $headers -Verbose

# Lihat response headers
$response.Headers
```

Copy-paste output lengkapnya.

---

## Checklist Informasi yang Dibutuhkan

Sebelum saya bisa help lebih lanjut, butuh info ini:

- [ ] Sudah run `php -l` untuk cek syntax? Hasilnya apa?
- [ ] Sudah test dengan Postman/Insomnia? Response apa?
- [ ] Sudah cek DevTools Network tab? Apa yang terlihat?
- [ ] Error message lengkap dari browser console?
- [ ] Backend log ada error tidak?
- [ ] Backend sudah di-restart setelah update Cors.php?

---

## Kemungkinan Masalah (berdasarkan common issues)

| Masalah | Solusi |
|---------|--------|
| File `Cors.php` tidak ada | Pastikan file dibuat di `app/Filters/Cors.php` |
| Folder `Filters` tidak ada | Buat folder `Filters` di dalam `app/` |
| Syntax error di PHP | Cek dengan `php -l` command |
| Backend tidak di-restart | Restart server setelah update file |
| Import error di Filters.php | Pastikan semua import statements benar |
| `die()` masih digunakan | Ganti dengan `return response()->setStatusCode(200);` |
| Return null missing | Tambahkan `return null;` di akhir method `before()` |

---

## Quick Fix Attempt

Jika belum tahu masalahnya, coba ganti `Cors.php` dengan versi simplest ini:

```php
<?php
namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

class Cors implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization');
        
        if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
            http_response_code(200);
            exit(0);
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }
}
```

Setelah itu restart backend dan test lagi.

---

**NEXT STEPS:**
1. Jalankan salah satu dari STEP 1-6 di atas
2. Share hasilnya
3. Saya akan bantu identify masalahnya dengan lebih akurat

Tunggu info dari Anda! 👍
