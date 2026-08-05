# LaunchPad TV — Content Examples

Working example files for [LaunchPad TV](https://tv.launchpad2.app). Copy them, replace the
content with your own, host them anywhere that serves a direct link, and register the link as a
code on LaunchPad TV.

Every file in this repository is live and usable as-is — the links below are real.

Vietnamese version: [README.vi.md](README.vi.md)

## Quick start

1. Create an account at [tv.launchpad2.app](https://tv.launchpad2.app).
2. Copy one of the example files from this repository and edit it.
3. Upload it somewhere that returns the raw file over HTTPS (see [Hosting](#hosting-your-file)).
4. In your Dashboard, create a code, pick the type, and paste the link.
5. Enter the 6-character code on your TV.

## Files in this repository

| File | Code type | What it is |
|------|-----------|------------|
| [`store.json`](store.json) | `store` | App store manifest — a list of installable APKs |
| [`rss.json`](rss.json) | `rss` | News source list — a list of RSS feeds |
| [`us.m3u`](us.m3u) | `iptv` | IPTV playlist in M3U format (United States channels) |

APK binaries are **not** in the repository tree. GitHub does not serve tree files as downloadable
binaries, so they are published as release assets instead:

- [`apkpure-3.20.7609.apk`](https://github.com/launchpad2/tv/releases/download/apk-v1/apkpure-3.20.7609.apk)
- [`aptoide-10.0.0.apk`](https://github.com/launchpad2/tv/releases/download/apk-v1/aptoide-10.0.0.apk)

## Direct links to use

Use these exact URL shapes for your own files.

| Content | Link shape |
|---------|-----------|
| A file in the repo tree | `https://raw.githubusercontent.com/<user>/<repo>/main/<file>` |
| A release asset (APK) | `https://github.com/<user>/<repo>/releases/download/<tag>/<file>` |

## store.json

A store code points at a JSON manifest listing the apps your TV can install.

```json
{
  "storeName": "My Store",
  "apps": [
    {
      "name": "APKPure",
      "packageName": "com.apkpure.aegon",
      "description": "Alternative app store.",
      "iconUrl": null,
      "apkUrl": "https://github.com/launchpad2/tv/releases/download/apk-v1/apkpure-3.20.7609.apk",
      "version": "3.20.7609",
      "sha256": "3e2d45aaafc2e894c922f6964848ef8410bdfac93470ed9ebc672b6d22218395",
      "sizeBytes": 26434115
    }
  ]
}
```

| Field | Required | Notes |
|-------|----------|-------|
| `storeName` | yes | Shown as the store title on the TV |
| `apps[].name` | yes | App name shown on the TV |
| `apps[].packageName` | yes | Android package name, used to detect "already installed" |
| `apps[].apkUrl` | yes | Direct HTTPS link to the `.apk` file |
| `apps[].version` | yes | Version string shown in the app list |
| `apps[].sha256` | yes | SHA-256 of the APK — the TV verifies the download against it |
| `apps[].sizeBytes` | no | File size in bytes, used for the progress bar |
| `apps[].iconUrl` | no | PNG/JPG link, or `null` for a generated placeholder |
| `apps[].description` | no | Short description |

Get the checksum and size of your APK with:

```bash
shasum -a 256 my-app.apk
wc -c < my-app.apk
```

The `sha256` value must match the file byte for byte. A mismatch fails the install on purpose —
that check is what stops a swapped or truncated download from being installed.

## rss.json

An RSS code points at a JSON list of feeds. Each feed is a standard RSS or Atom URL.

```json
{
  "name": "My News",
  "feeds": [
    { "name": "Google News", "url": "https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en" },
    { "name": "BBC News", "url": "https://feeds.bbci.co.uk/news/rss.xml" }
  ]
}
```

| Field | Required | Notes |
|-------|----------|-------|
| `name` | yes | Title of the whole source list |
| `feeds[].name` | yes | Label shown in the news menu |
| `feeds[].url` | yes | RSS or Atom feed URL |

Test a feed before adding it — open it in a browser and confirm you get XML with `<item>` or
`<entry>` elements, not an HTML page.

## IPTV playlist (.m3u)

An IPTV code points at a plain M3U playlist. This is the same format every IPTV player uses, so
any existing playlist works unchanged.

```m3u
#EXTM3U
#EXTINF:-1 tvg-id="ABC.us" tvg-logo="https://example.com/abc.png" group-title="USA",ABC
https://example.com/abc/index.m3u8
#EXTINF:-1 tvg-logo="https://example.com/cnn.png" group-title="News",CNN
https://example.com/cnn/index.m3u8
```

- `tvg-logo` — channel logo, optional
- `group-title` — groups channels into rows, optional
- The text after the comma is the channel name shown on the TV
- The next line is the stream URL — HLS (`.m3u8`) is the safest choice

`us.m3u` in this repository comes from the [iptv-org](https://github.com/iptv-org/iptv) project.

## Hosting your file

Any host works as long as the link returns the raw file, not a preview page.

| Host | How to get a direct link |
|------|--------------------------|
| GitHub (this way) | Commit the file, open it, press **Raw**, copy the URL |
| GitHub Releases | For binaries such as APKs — upload as a release asset, copy the asset link |
| Google Drive | Share the file publicly, then use `https://drive.google.com/uc?export=download&id=<FILE_ID>` |
| Dropbox | Share the file, then change `dl=0` to `dl=1` at the end of the link |
| Your own server | Serve the file over HTTPS with the correct content type |

Two things to check before pasting a link into LaunchPad TV:

- Opening the link in a browser downloads or shows the raw content, not an HTML page.
- The link works in a private window — a link that needs a login will not work on the TV.

GitHub raw links are served through a CDN and can take a few minutes to reflect an edit. That
delay is normal; the TV will pick up the change on the next refresh.

## Default content

LaunchPad TV ships with code `000000`, which is maintained by us and always works:

| Type | Content |
|------|---------|
| `store` | APKPure and Aptoide |
| `rss` | Vietnamese and English news sources |
| `iptv` | Vietnam and United States channel lists |

Use it to check that your TV is set up correctly before you create your own code.
