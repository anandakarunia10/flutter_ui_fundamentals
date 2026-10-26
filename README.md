# Course Data Manager - Pertemuan 7

Aplikasi Course Data Manager yang mengintegrasikan Flutter UI dengan RESTful API, Backend Services, dan Database Supabase.

## Identitas Mahasiswa
- **Nama**: Gede Ananda Karunia Putra
- **NIM**: 2455011010
- **Kelas**: TRPL 5A

---

## Dokumentasi REST API (Tahap 1)

### Pengujian endpoint

- **Endpoint yang berhasil diuji:** `https://jsonplaceholder.typicode.com/posts/1`
- **HTTP Method:** `GET`
- **Status Code:** `200 OK`
- **Resource:** `posts`
- **Format response:** JSON

### Struktur Response Body JSON

```json
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}
```

### Identifikasi field JSON

- `userId`: ID pengguna pemilik post.
- `id`: ID post.
- `title`: judul post.
- `body`: isi post.