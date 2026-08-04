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

## Cách tạo link Raw từ GitHub

### Bước 1: Tạo tài khoản GitHub

Vào [github.com/signup](https://github.com/signup) để đăng ký miễn phí.

### Bước 2: Tạo repo mới

1. Nhấn nút **+** góc trên phải → **New repository**
2. Đặt tên repo (ví dụ: `my-tv-content`)
3. Chọn **Public**
4. Nhấn **Create repository**

### Bước 3: Tạo file nội dung

1. Trong repo mới, nhấn **Add file** → **Create new file**
2. Đặt tên file (ví dụ: `store.json`, `rss.json`, hoặc `channels.m3u`)
3. Copy nội dung từ thư mục `examples/` vào
4. Nhấn **Commit changes**

### Bước 4: Lấy link Raw

1. Mở file vừa tạo
2. Nhấn nút **Raw** góc trên phải
3. Copy link URL (bắt đầu bằng `https://raw.githubusercontent.com/...`)

### Bước 5: Dán link vào LaunchPad TV

1. Vào Dashboard → nhấn **Tạo**
2. Chọn loại code
3. Paste link Raw vào ô **Link**
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

## Câu hỏi thường gặp

**Q: Cập nhật nội dung mất bao lâu?**
A: Khoảng 5 phút (do cache CDN của GitHub).

**Q: Có thể dùng Google Drive thay GitHub không?**
A: Không. Phải dùng link `raw.githubusercontent.com`.

**Q: File JSON cần đúng format không?**
A: Có. JSON phải hợp lệ và đúng cấu trúc như ví dụ.

## Hỗ trợ

- Website: [tv.launchpad2.app](https://tv.launchpad2.app)
- Email: xtieume@gmail.com
