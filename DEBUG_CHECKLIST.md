# Debugging Checklist - CORS Error

Gunakan checklist ini untuk mengidentifikasi masalah. Jawab setiap pertanyaan:

## 1️⃣ Backend Status
- [ ] Sudah update `Filters.php`?
- [ ] Sudah update `Cors.php` filter?
- [ ] Backend server sudah di-restart?
- [ ] Tidak ada syntax error di PHP?

## 2️⃣ Verifikasi Request Headers
Buka browser DevTools (F12) > Network tab > coba DELETE:

- [ ] Apakah ada `OPTIONS` request sebelum `DELETE`?
- [ ] Response dari OPTIONS mengandung header `Access-Control-Allow-Origin: *`?
- [ ] Response dari OPTIONS mengandung header `Access-Control-Allow-Methods`?

## 3️⃣ Test dengan Curl (dari PowerShell)

**Jalankan command ini:**
```powershell
# Test OPTIONS
curl -X OPTIONS http://192.168.100.22:8080/buku/1 `
  -H "Origin: http://localhost:64625" `
  -H "Access-Control-Request-Method: DELETE" `
  -v
```

**Cek response:**
- [ ] Status code: 200?
- [ ] Headers mengandung `Access-Control-Allow-Origin`?
- [ ] Headers mengandung `Access-Control-Allow-Methods`?

## 4️⃣ Error Detail dari Browser

Buka DevTools > Console, coba DELETE, dan copy paste error message lengkapnya di sini:

```
[PASTE ERROR MESSAGE HERE]
```

## 5️⃣ Backend Log

Cek log file backend (biasanya di `writable/logs/`):
- [ ] Ada error message di log?
- [ ] Apakah ada CORS-related error?

---

**Setelah jawab semua ini, saya bisa bantu identify masalahnya dengan lebih akurat.**
