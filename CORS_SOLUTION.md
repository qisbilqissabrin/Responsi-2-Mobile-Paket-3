# Solusi CORS Error - Dokumentasi Lengkap

## 📋 Ringkasan Masalah

Aplikasi Flutter Web mengalami CORS (Cross-Origin Resource Sharing) error ketika mencoba melakukan DELETE dan PUT request ke backend server di `http://192.168.100.22:8080`.

### Error yang Muncul:
```
Access to fetch at 'http://192.168.100.22:8080/buku/1' from origin 'http://localhost:64625' 
has been blocked by CORS policy: Response to preflight request doesn't pass access control check: 
No 'Access-Control-Allow-Origin' header is present on the requested resource.
```

## 🔍 Root Cause Analysis

### Mengapa Error Terjadi?

1. **Browser Security Policy**: Browser memiliki Same-Origin Policy yang mencegah JavaScript membuat request ke domain/IP yang berbeda
2. **Preflight Request**: Untuk request DELETE dan PUT, browser mengirim `OPTIONS` request terlebih dahulu
3. **CORS Headers Missing**: Server backend tidak merespons dengan header `Access-Control-Allow-Origin`
4. **GET vs DELETE/PUT**: GET requests tidak memerlukan preflight, jadi tidak error

### Mengapa Hanya DELETE dan PUT yang Error?

- **GET** = Simple request (tidak perlu preflight)
- **POST/PUT/DELETE** = Complex request (memerlukan preflight)

## ✅ Solusi yang Sudah Diterapkan

### 1. Error Handling di Frontend

File yang sudah diupdate:
- `lib/ui/buku_detail.dart` - Improved DELETE handling
- `lib/ui/buku_form.dart` - Improved PUT/POST handling

Improvements:
- ✓ Menambahkan headers CORS-friendly
- ✓ Request timeout handling (10 detik)
- ✓ Error message yang lebih informatif
- ✓ Dialog untuk menampilkan error detail
- ✓ Loading indicator saat menghapus/update

### 2. HTTP Client Helper

File baru: `lib/helper/http_client.dart`

Fungsi:
- Centralized HTTP requests handling
- Automatic header configuration
- Timeout handling
- Response error handling
- Consistent error messages

## 🔧 Solusi Backend (WAJIB DILAKUKAN)

### LANGKAH 1: Enable CORS di CodeIgniter 4

**Option A: Menggunakan CORS Middleware (Recommended)**

1. Buka `app/Config/Cors.php` (jika file tidak ada, buat baru)
2. Tambahkan konfigurasi:

```php
<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

class Cors extends BaseConfig
{
    /**
     * List of allowed origins
     */
    public $allowedOrigins = [
        'http://localhost',
        'http://localhost:64625',
        'http://localhost:*',
        'http://192.168.100.22:*',
        // Untuk production, sesuaikan dengan domain Anda
    ];

    /**
     * List of allowed HTTP methods
     */
    public $allowedMethods = [
        'GET',
        'POST',
        'PUT',
        'DELETE',
        'PATCH',
        'OPTIONS'
    ];

    /**
     * List of allowed headers
     */
    public $allowedHeaders = [
        'Content-Type',
        'Accept',
        'Authorization',
        'X-Requested-With'
    ];

    /**
     * List of headers to expose
     */
    public $exposedHeaders = ['X-Total-Count'];

    /**
     * Max age of preflight request cache
     */
    public $maxAge = 7200;

    /**
     * Allow credentials
     */
    public $allowCredentials = false;
}
```

3. Daftarkan middleware di `app/Config/Filters.php`:

```php
public $filters = [
    'cors' => ['before' => ['api/*']],
];

public $aliases = [
    'cors' => \App\Filters\CorsFilter::class,
];
```

4. Buat filter di `app/Filters/CorsFilter.php`:

```php
<?php

namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Config\Cors;

class CorsFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $cors = new Cors();
        $origin = $request->getServer('HTTP_ORIGIN') ?? '';

        if ($this->isOriginAllowed($origin, $cors->allowedOrigins)) {
            header('Access-Control-Allow-Origin: ' . $origin);
            header('Access-Control-Allow-Methods: ' . implode(', ', $cors->allowedMethods));
            header('Access-Control-Allow-Headers: ' . implode(', ', $cors->allowedHeaders));
            header('Access-Control-Max-Age: ' . $cors->maxAge);
            
            if (!empty($cors->exposedHeaders)) {
                header('Access-Control-Expose-Headers: ' . implode(', ', $cors->exposedHeaders));
            }
        }

        // Handle preflight requests
        if ($request->getMethod() === 'options') {
            return response()->setStatusCode(200);
        }

        return null;
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        return $response;
    }

    private function isOriginAllowed($origin, $allowedOrigins)
    {
        foreach ($allowedOrigins as $allowed) {
            if ($allowed === '*') {
                return true;
            }
            if ($allowed === $origin) {
                return true;
            }
            // Support wildcard like http://localhost:*
            if (strpos($allowed, '*') !== false) {
                $pattern = str_replace('*', '.*', preg_quote($allowed, '/'));
                if (preg_match('/^' . $pattern . '$/', $origin)) {
                    return true;
                }
            }
        }
        return false;
    }
}
```

**Option B: Menggunakan Apache/Nginx Config**

Jika menggunakan Apache (`.htaccess`):
```apache
<IfModule mod_headers.c>
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS, PATCH"
    Header set Access-Control-Allow-Headers "Content-Type, Accept, Authorization, X-Requested-With"
    Header set Access-Control-Max-Age "7200"
</IfModule>
```

Jika menggunakan Nginx (di server block):
```nginx
add_header Access-Control-Allow-Origin "*" always;
add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS, PATCH" always;
add_header Access-Control-Allow-Headers "Content-Type, Accept, Authorization, X-Requested-With" always;
add_header Access-Control-Max-Age "7200" always;

if ($request_method = 'OPTIONS') {
    return 204;
}
```

## 🧪 Testing Setelah Fix

### 1. Test dengan Curl Command

```bash
# Test OPTIONS (preflight)
curl -X OPTIONS http://192.168.100.22:8080/buku/1 \
  -H "Origin: http://localhost:64625" \
  -H "Access-Control-Request-Method: DELETE" \
  -v

# Test DELETE
curl -X DELETE http://192.168.100.22:8080/buku/1 \
  -H "Origin: http://localhost:64625" \
  -H "Content-Type: application/json" \
  -v

# Test PUT
curl -X PUT http://192.168.100.22:8080/buku/1 \
  -H "Origin: http://localhost:64625" \
  -H "Content-Type: application/json" \
  -d '{"judul":"Test"}' \
  -v
```

### 2. Cek Response Headers

Seharusnya response mengandung:
```
Access-Control-Allow-Origin: http://localhost:64625
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Accept, Authorization, X-Requested-With
```

## 📱 Alternatif: Development Mode Setup

Jika ingin quick testing tanpa konfigurasi backend yang kompleks:

### Setup Backend di Localhost
```bash
# Jika backend CI4 berjalan di localhost
# Update API_URL di lib/helper/api_url.dart
static const String baseUrl = 'http://localhost:8080';
```

### Gunakan Flutter Web dengan Dev Server
```bash
flutter run -d chrome --web-renderer=auto
```

## 🛡️ Security Best Practices

**JANGAN gunakan ini di Production:**
```php
// ❌ JANGAN
Header set Access-Control-Allow-Origin "*"
```

**Gunakan ini di Production:**
```php
// ✓ Benar - Hanya allow origin yang dipercaya
$allowedOrigins = [
    'https://yourdomain.com',
    'https://app.yourdomain.com',
];
```

## 📊 Checklist untuk Developer Backend

- [ ] Konfigurasi CORS di backend
- [ ] Test preflight OPTIONS request
- [ ] Verifikasi headers di response
- [ ] Test DELETE request
- [ ] Test PUT request
- [ ] Test POST request
- [ ] Setup CORS hanya untuk origins yang dipercaya
- [ ] Documentation untuk frontend team
- [ ] Testing di development, staging, dan production environment

## 📞 Troubleshooting

### Error masih muncul setelah update backend?

1. **Clear browser cache**: Ctrl+Shift+Delete
2. **Restart backend server**: Pastikan konfigurasi ter-reload
3. **Check response headers**: Buka DevTools > Network tab > pilih request > Headers
4. **Verify origin**: Pastikan Origin di request header sesuai dengan allowed origins
5. **Check preflight**: Cari OPTIONS request di Network tab, lihat response headers-nya

### Debug CORS Issues

Di browser console:
```javascript
// Lihat detail error
console.table(response.headers)
```

## 📚 Referensi

- MDN Web Docs: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
- CodeIgniter 4 Documentation: https://codeigniter.com/user_guide/
- CORS Tester: https://www.test-cors.org/

---

**Status**: Implementasi di Flutter sudah selesai. Menunggu konfigurasi CORS di backend.
