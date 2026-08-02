# LaunchPad TV — nguồn nội dung

*(English version: [README.md](README.md))*

Repo này là trung tâm phân phối của LaunchPad TV (launcher cho Android TV): danh bạ code và nơi publisher đăng ký nguồn. Không có server nào phía sau — mọi thứ là file tĩnh trên GitHub.

## Bạn là publisher? Đăng ký nguồn trong 3 bước

1. **Tự chứa nội dung trên repo GitHub public của bạn** theo đúng schema bên dưới. APK để ở **GitHub Releases** của repo bạn (không commit APK vào repo — GitHub chặn file trên 100 MB).
2. **Mở issue đăng ký**: tab Issues → "Register a content source", điền loại nguồn + tên hiển thị + link raw JSON + liên hệ.
3. Admin duyệt xong, bot tự kiểm tra JSON của bạn, cấp **code 6 ký tự** và trả lời ngay trong issue. Người dùng chỉ cần nhập code đó trên TV.

## Schema

### store.json (kho ứng dụng)
```json
{
  "storeName": "Kho của tôi",
  "apps": [
    {
      "name": "Ứng dụng X",
      "packageName": "com.example.x",
      "description": "Mô tả ứng dụng làm gì, một hai câu.",
      "iconUrl": "https://raw.githubusercontent.com/<user>/<repo>/main/icons/x.png",
      "apkUrl": "https://github.com/<user>/<repo>/releases/download/v1.0/x.apk",
      "version": "1.0",
      "sha256": "<sha256 của file APK>",
      "sizeBytes": 25000000
    }
  ]
}
```
- Bắt buộc mỗi app: `name`, `packageName`, `description`, `apkUrl`, `version`.
- Tuỳ chọn: `iconUrl`, `sizeBytes`, `sha256`. Nếu có `sha256` thì TV sẽ kiểm tra file tải về theo nó (`shasum -a 256 x.apk`).

### iptv.json (danh sách kênh)
```json
{
  "name": "Kênh của tôi",
  "region": "VN",
  "code": "",
  "channels": [
    { "id": 1, "name": "Kênh 1", "logoUrl": null, "streamUrl": "https://.../index.m3u8", "group": "Giải trí" }
  ]
}
```
- `region` là mã nước 2 chữ (ISO 3166-1 alpha-2), ví dụ `VN`, `US`, `KR` — tra mã của bạn tại: https://vi.wikipedia.org/wiki/ISO_3166-1_alpha-2

### rss.json (nguồn tin)
```json
{
  "name": "Tin của tôi",
  "code": "",
  "feeds": [
    { "name": "Trang X", "url": "https://x.example.com/rss" }
  ]
}
```

## Cập nhật nguồn của bạn

- **Cập nhật nội dung** (thêm app, kênh, feed): chỉ cần sửa file JSON trong repo của bạn — TV tự nhận thay đổi, chờ vài phút do CDN của GitHub có cache.
- **Chuyển repo hoặc đổi đường dẫn file JSON**: mở issue đăng ký mới kèm link mới và ghi rõ code hiện có của bạn — admin sẽ trỏ code cũ sang link mới, người dùng vẫn nhập đúng code cũ. Đừng xoá repo cũ cho tới khi việc chuyển được xác nhận trong issue.

## Cấu trúc repo này

- `codes/{CODE}.json` — danh bạ: TV nhập code sẽ fetch `https://raw.githubusercontent.com/onehud/tv/main/codes/{CODE}.json` để lấy `{type, name, url}` rồi tải nội dung trực tiếp từ repo của publisher.
- `.github/` — form đăng ký + workflow tự cấp code khi issue được gắn label `approved`.
