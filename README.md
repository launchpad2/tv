# LaunchPad TV — Hướng dẫn tạo nội dung

> Repository này chứa file mẫu để sử dụng với [LaunchPad TV](https://tv.launchpad2.app).

## Cách sử dụng

1. **Tạo tài khoản** tại [tv.launchpad2.app](https://tv.launchpad2.app)
2. **Tạo code** từ Dashboard, chọn loại (Store / IPTV / RSS)
3. **Tạo file nội dung** theo mẫu bên dưới
4. **Lấy link Raw** từ GitHub và paste vào form

## File mẫu

Xem thư mục `examples/`:

| File | Mô tả | Loại code |
|------|-------|-----------|
| [`store.json`](examples/store.json) | Danh sách ứng dụng | `store` |
| [`rss.json`](examples/rss.json) |Nguồn tin tức RSS | `rss` |
| [`channels.m3u`](examples/channels.m3u) | Kênh IPTV | `iptv` |

## Cách tạo link nội dung

### Bước 1: Tạo file nội dung

Tạo file theo mẫu trong thư mục `examples/`:
- `store.json` — Danh sách ứng dụng
- `rss.json` — Nguồn tin tức
- `channels.m3u` — Kênh IPTV

### Bước 2: Upload lên hosting

Upload file lên bất kỳ hosting nào hỗ trợ link trực tiếp, ví dụ:
- **GitHub**: Tạo repo → upload file → nhấn **Raw** → copy link
- **Google Drive**: Upload file → đổi link thành `https://drive.google.com/uc?export=download&id=...`
- **Dropbox**: Upload file → đổi link `dl=0` thành `dl=1`
- **Hosting riêng**: Upload file và lấy link trực tiếp

### Bước 3: Dán link vào LaunchPad TV

1. Vào Dashboard → nhấn **Tạo**
2. Chọn loại code
3. Paste link vào ô **Link**
4. Nhấn **Lưu**

## Cấu trúc file

### Store (`store.json`)

```json
{
  "apps": [
    {
      "name": "Tên app",
      "packageName": "com.example.app",
      "description": "Mô tả app",
      "icon": "https://link-den-icon.png",
      "url": "https://link-tai-ve-hoac-trang-web"
    }
  ]
}
```

**Trường bắt buộc:**
- `name` — Tên hiển thị trên TV
- `packageName` — Package name (Android)
- `url` — Link tải hoặc trang web

**Trường tuỳ chọn:**
- `description` — Mô tả
- `icon` — Link icon (PNG/JPG)

### RSS (`rss.json`)

```json
{
  "name": "Tên nguồn tin",
  "feeds": [
    {
      "name": "Tên chuyên mục",
      "url": "https://vnexpress.net/rss/so-hoa.rss"
    }
  ]
}
```

### IPTV (`channels.m3u`)

```m3u
#EXTM3U
#EXTINF:-1 tvg-name="Tên kênh" tvg-logo="https://link-icon.png",Tên kênh hiển thị
http://link-stream.m3u8
```
