# LaunchPad TV — content sources

*(Bản tiếng Việt: [README.vi.md](README.vi.md))*

This repository is the distribution hub for LaunchPad TV (an Android TV launcher): the code directory and publisher registration. There is no server behind it — everything is static files on GitHub.

## Are you a publisher? Register your source in 3 steps

1. **Host your content on your own public GitHub repo** following the schemas below. Put APKs in your repo's **GitHub Releases** (do not commit APKs into the repo — GitHub blocks files over 100 MB).
2. **Open a registration issue**: Issues → "Register a content source" and fill in the source type, display name, raw JSON link and contact.
3. Once approved, the bot validates your JSON, issues a **6-character code** and replies right in the issue. Users just enter that code on their TV.

## Schemas

### store.json (app store)
```json
{
  "storeName": "My store",
  "apps": [
    {
      "name": "App X",
      "packageName": "com.example.x",
      "description": "What the app does, in one or two sentences.",
      "iconUrl": "https://raw.githubusercontent.com/<user>/<repo>/main/icons/x.png",
      "apkUrl": "https://github.com/<user>/<repo>/releases/download/v1.0/x.apk",
      "version": "1.0",
      "sha256": "<sha256 of the APK file>",
      "sizeBytes": 25000000
    }
  ]
}
```
- Required per app: `name`, `packageName`, `description`, `apkUrl`, `version`.
- Optional: `iconUrl`, `sizeBytes`, `sha256`. If `sha256` is present the TV verifies the download against it (`shasum -a 256 x.apk`).

### iptv.json (channel list)
```json
{
  "name": "My channels",
  "region": "US",
  "code": "",
  "channels": [
    { "id": 1, "name": "Channel 1", "logoUrl": null, "streamUrl": "https://.../index.m3u8", "group": "Entertainment" }
  ]
}
```
- `region` is a two-letter country code (ISO 3166-1 alpha-2), e.g. `US`, `VN`, `KR` — look yours up here: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

### rss.json (news feeds)
```json
{
  "name": "My news",
  "code": "",
  "feeds": [
    { "name": "Site X", "url": "https://x.example.com/rss" }
  ]
}
```

## Updating your source

- **Updating content** (adding apps, channels or feeds): just edit the JSON files in your repo — TVs pick the changes up automatically. Allow a few minutes for GitHub's CDN cache.
- **Moving your repo or changing the JSON path**: open a new registration issue with the new link and mention your existing code in it — the admin re-points your code to the new link, so your users keep entering the same code. Do not delete your old repo until the switch is confirmed in the issue.

## Repository layout

- `codes/{CODE}.json` — code directory: the TV resolves a code by fetching `https://raw.githubusercontent.com/onehud/tv/main/codes/{CODE}.json` to get `{type, name, url}`, then loads content directly from the publisher's repo.
- `.github/` — registration form + the workflow that issues codes once an issue is labeled `approved`.
