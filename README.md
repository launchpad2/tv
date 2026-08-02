# LaunchPad TV — nguồn nội dung

Repo này là hạ tầng phân phối của LaunchPad TV (Android TV launcher): danh bạ code, nội dung mặc định, và nơi publisher đăng ký nguồn của mình. Không có server nào phía sau — mọi thứ là file tĩnh trên GitHub.

## Bạn là publisher? Đăng ký nguồn trong 3 bước

1. **Tự chứa nội dung trên GitHub public của bạn** theo đúng schema dưới. APK để ở **GitHub Releases** của repo bạn (không commit APK vào repo — GitHub chặn file >100MB).
2. **Mở issue đăng ký** tại tab Issues → "Đăng ký nguồn nội dung", điền loại nguồn + tên + link raw JSON + liên hệ.
3. Admin duyệt → bot tự kiểm tra JSON của bạn, cấp **code 6 ký tự** và trả lời ngay trong issue. Người dùng chỉ cần nhập code đó trên TV.

## Schema

### store.json (kho ứng dụng)
```json
{
  "storeName": "Kho của A",
  "apps": [
    {
      "name": "Ứng dụng X",
      "packageName": "com.example.x",
      "iconUrl": "https://raw.githubusercontent.com/<user>/<repo>/main/icons/x.png",
      "apkUrl": "https://github.com/<user>/<repo>/releases/download/v1.0/x.apk",
      "version": "1.0",
      "sha256": "<sha256 của file APK>",
      "sizeBytes": 25000000
    }
  ]
}
```
- `sha256` **bắt buộc** — TV từ chối cài nếu thiếu hoặc lệch. Tính bằng: `shasum -a 256 x.apk`
- `iconUrl`, `sizeBytes` không bắt buộc.

### iptv.json (danh sách kênh)
```json
{
  "name": "Kênh của A",
  "region": "VN",
  "code": "",
  "channels": [
    { "id": 1, "name": "Kênh 1", "logoUrl": null, "streamUrl": "https://.../index.m3u8", "group": "Giải trí" }
  ]
}
```

### rss.json (nguồn tin)
```json
{
  "name": "Tin của A",
  "code": "",
  "feeds": [
    { "name": "Trang X", "url": "https://x.example.com/rss" }
  ]
}
```

## Cấu trúc repo này

- `codes/{CODE}.json` — danh bạ: TV nhập code sẽ fetch `https://raw.githubusercontent.com/onehud/tv/main/codes/{CODE}.json` để lấy `{type, name, url}` rồi tải nội dung trực tiếp từ repo của publisher.
- `store.json`, `iptv/`, `rss.json` — nội dung mặc định do LaunchPad phát hành.
- `.github/` — form đăng ký + workflow tự cấp code (chạy khi admin gắn label `approved`).
