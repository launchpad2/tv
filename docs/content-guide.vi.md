# LaunchPad TV — File nội dung mẫu

File mẫu dùng được ngay cho [LaunchPad TV](https://tv.launchpad2.app). Bạn copy file, thay nội
dung của mình vào, đưa lên bất kỳ chỗ nào cho link trực tiếp, rồi đăng ký link đó thành một code
trên LaunchPad TV.

Mọi file trong repository này đều là link thật, dùng được ngay.

English version: [content-guide.md](content-guide.md)

## Bắt đầu nhanh

1. Tạo tài khoản tại [tv.launchpad2.app](https://tv.launchpad2.app).
2. Copy một file mẫu trong repository này rồi sửa lại.
3. Upload file lên chỗ nào trả về nội dung thô qua HTTPS (xem [Hosting](#hosting-file-của-bạn)).
4. Vào Dashboard, tạo code, chọn loại, dán link vào.
5. Nhập code 6 ký tự trên TV.

## Các file trong repository

| File | Loại code | Là gì |
|------|-----------|-------|
| [`store.json`](../store.json) | `store` | Manifest cửa hàng ứng dụng — danh sách APK cài được |
| [`rss.json`](../rss.json) | `rss` | Danh sách nguồn tin RSS |
| [`us.m3u`](../us.m3u) | `iptv` | Playlist IPTV định dạng M3U (kênh Mỹ) |

File APK **không** nằm trong repository. GitHub không cho tải file trong cây repo bằng link trực
tiếp, nên APK được phát hành dưới dạng release asset:

- [`apkpure-3.20.7609.apk`](https://github.com/launchpad2/tv/releases/download/apk-v1/apkpure-3.20.7609.apk)
- [`aptoide-10.0.0.apk`](https://github.com/launchpad2/tv/releases/download/apk-v1/aptoide-10.0.0.apk)

## Dạng link trực tiếp

Dùng đúng hai dạng URL này cho file của bạn.

| Nội dung | Dạng link |
|----------|-----------|
| File trong cây repo | `https://raw.githubusercontent.com/<user>/<repo>/main/<file>` |
| Release asset (APK) | `https://github.com/<user>/<repo>/releases/download/<tag>/<file>` |

## store.json

Code loại store trỏ tới một file JSON liệt kê các app mà TV có thể cài.

```json
{
  "storeName": "My Store",
  "apps": [
    {
      "name": "APKPure",
      "packageName": "com.apkpure.aegon",
      "description": "Cửa hàng ứng dụng thay thế.",
      "iconUrl": null,
      "apkUrl": "https://github.com/launchpad2/tv/releases/download/apk-v1/apkpure-3.20.7609.apk",
      "version": "3.20.7609",
      "sha256": "3e2d45aaafc2e894c922f6964848ef8410bdfac93470ed9ebc672b6d22218395",
      "sizeBytes": 26434115,
      "minSdk": 19,
      "versionCode": 3207697
    }
  ]
}
```

| Trường | Bắt buộc | Ghi chú |
|--------|----------|---------|
| `storeName` | có | Tên cửa hàng hiển thị trên TV |
| `apps[].name` | có | Tên app hiển thị trên TV |
| `apps[].packageName` | có | Package name Android, dùng để biết app đã cài chưa |
| `apps[].apkUrl` | có | Link HTTPS trực tiếp tới file `.apk` |
| `apps[].version` | có | Chuỗi phiên bản hiển thị trong danh sách |
| `apps[].sha256` | có | SHA-256 của file APK — TV kiểm tra file tải về theo giá trị này |
| `apps[].sizeBytes` | không | Kích thước file theo byte, dùng cho thanh tiến trình |
| `apps[].iconUrl` | không | Link PNG/JPG, hoặc `null` để dùng icon tự sinh |
| `apps[].bannerUrl` | không | Ảnh ngang (16:9) hiện trong khung chi tiết |
| `apps[].description` | không | Mô tả ngắn |
| `apps[].minSdk` | không | API level Android tối thiểu của gói. Máy thấp hơn sẽ KHÔNG thấy app |
| `apps[].versionCode` | không | `versionCode` của gói, dùng để chọn bản mới nhất khi một gói có nhiều bản |

Đọc `minSdk` và `versionCode` thẳng từ file APK, đừng gõ tay:

```bash
aapt dump badging my-app.apk | grep -E "^package:|^sdkVersion"
```

Bỏ trống cả hai thì giữ nguyên hành vi cũ: app hiện trên mọi TV và không bị gom với bản nào khác.

### Một app có nhiều bản

TV đời cũ và TV đời mới thường cần hai bản khác nhau của cùng một app. Cứ khai mỗi bản thành một
entry riêng với cùng `packageName`, TV sẽ tự xử lý:

1. Bỏ mọi bản có `minSdk` cao hơn API của máy — không ai phải tải 90 MB rồi mới nhận thông báo
   "App not installed".
2. Hiện **một thẻ cho một gói**: bản còn lại có `versionCode` cao nhất.
3. Các bản còn lại nằm ở mục **Phiên bản khác** trong khung chi tiết, để người dùng vẫn cài được
   bản cũ khi bản mới lỗi trên máy của họ.

Nếu không bản nào qua được bước 1 thì app biến mất khỏi cửa hàng.

```json
{
  "storeName": "My Store",
  "apps": [
    {
      "name": "LeanKeyboard",
      "packageName": "org.liskovsoft.androidtv.rukeyboard",
      "apkUrl": "https://example.com/apk/leankeyboard-6.1.31.apk",
      "version": "6.1.31",
      "sha256": "…",
      "minSdk": 14,
      "versionCode": 201
    },
    {
      "name": "LeanKeyboard",
      "packageName": "org.liskovsoft.androidtv.rukeyboard",
      "apkUrl": "https://example.com/apk/leankeyboard-6.1.28.apk",
      "version": "6.1.28",
      "sha256": "…",
      "minSdk": 14,
      "versionCode": 198
    }
  ]
}
```

Hai app muốn hiện song song thì `packageName` phải KHÁC nhau — đó là lý do `cm.aptoide.pt` và
`cm.aptoidetv.pt` mỗi cái một thẻ.

Lấy checksum và kích thước file APK:

```bash
shasum -a 256 my-app.apk
wc -c < my-app.apk
```

Giá trị `sha256` phải khớp từng byte. Không khớp thì TV chặn cài — đó chính là cơ chế ngăn file
bị thay hoặc tải thiếu được cài lên máy.

## rss.json

Code loại rss trỏ tới một file JSON liệt kê các feed. Mỗi feed là một URL RSS hoặc Atom chuẩn.

```json
{
  "name": "My News",
  "feeds": [
    { "name": "VnExpress", "url": "https://vnexpress.net/rss/tin-moi-nhat.rss" },
    { "name": "Google News Việt Nam", "url": "https://news.google.com/rss/headlines/section/topic/NATION.vi_vn/Vietnam?hl=vi&gl=VN&ceid=VN:vi" }
  ]
}
```

| Trường | Bắt buộc | Ghi chú |
|--------|----------|---------|
| `name` | có | Tên của cả danh sách nguồn tin |
| `feeds[].name` | có | Nhãn hiển thị trong menu tin tức |
| `feeds[].url` | có | URL feed RSS hoặc Atom |

Kiểm tra feed trước khi thêm — mở link trên browser, phải thấy XML có thẻ `<item>` hoặc `<entry>`,
không phải trang HTML.

## Playlist IPTV (.m3u)

Code loại iptv trỏ tới một playlist M3U thuần. Đây đúng là định dạng mọi trình phát IPTV đang
dùng, nên playlist có sẵn của bạn dùng được luôn, không cần sửa.

```m3u
#EXTM3U
#EXTINF:-1 tvg-id="VTV1.vn" tvg-logo="https://example.com/vtv1.png" group-title="VTV",VTV1
https://example.com/vtv1/index.m3u8
#EXTINF:-1 tvg-logo="https://example.com/htv7.png" group-title="HTV",HTV7
https://example.com/htv7/index.m3u8
```

- `tvg-logo` — logo kênh, không bắt buộc
- `group-title` — gom kênh thành từng hàng, không bắt buộc
- Phần chữ sau dấu phẩy là tên kênh hiển thị trên TV
- Dòng tiếp theo là URL stream — HLS (`.m3u8`) là lựa chọn an toàn nhất

File `us.m3u` trong repository này lấy từ dự án [iptv-org](https://github.com/iptv-org/iptv).

## Hosting file của bạn

Chỗ nào cũng được, miễn là link trả về nội dung thô chứ không phải trang xem trước.

| Nơi lưu | Cách lấy link trực tiếp |
|---------|-------------------------|
| GitHub (cách trong repo này) | Commit file, mở file, bấm **Raw**, copy URL |
| GitHub Releases | Dành cho file nhị phân như APK — upload thành release asset rồi copy link asset |
| Google Drive | Chia sẻ công khai, rồi dùng `https://drive.google.com/uc?export=download&id=<FILE_ID>` |
| Dropbox | Chia sẻ file, rồi đổi `dl=0` thành `dl=1` ở cuối link |
| Server riêng | Cho file chạy qua HTTPS với content type đúng |

Hai thứ cần kiểm tra trước khi dán link vào LaunchPad TV:

- Mở link trên browser thì tải file hoặc thấy nội dung thô, không phải trang HTML.
- Link mở được ở cửa sổ ẩn danh — link cần đăng nhập sẽ không chạy trên TV.

Link raw của GitHub đi qua CDN nên sửa file có thể mất vài phút mới thấy. Chuyện đó là bình
thường; TV sẽ nhận nội dung mới ở lần làm mới sau.

## Nội dung mặc định

LaunchPad TV có sẵn code `000000` do chúng tôi quản lý, luôn dùng được:

| Loại | Nội dung |
|------|----------|
| `store` | APKPure và Aptoide |
| `rss` | Nguồn tin tiếng Việt và tiếng Anh |
| `iptv` | Danh sách kênh Việt Nam và Mỹ |

Dùng code này để kiểm tra TV đã cài đúng chưa, trước khi tự tạo code riêng.
