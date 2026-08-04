# LaunchPad TV — content sources

*(Bản tiếng Việt: [README.vi.md](README.vi.md))*

This repository is the publisher hub for LaunchPad TV (an Android TV launcher): the code directory and publisher registration. There is no server behind it — everything is static files on GitHub.

How it works in one sentence: you host your content (a JSON file, plus APKs if you run an app store) in your own public GitHub repo, you register it here, and users type a 6-character code on their TV to load it.

## Key facts

| | |
|---|---|
| Code format | 6 characters, A–Z and 2–9 (no O/I/0/1 — they look alike on screen) |
| Where codes resolve | `https://raw.githubusercontent.com/launchpad2/tv/main/codes/{CODE}.json` |
| Content updates reach TVs | automatically, ~5 minutes (GitHub CDN cache) |
| Max APK size | 2 GB per release asset |
| APK hosting | GitHub Releases (publisher) or R2 (default content) — never commit APKs into the repo |
| Required app fields | `name`, `packageName`, `description`, `apkUrl`, `version` |
| Optional app fields | `iconUrl`, `sizeBytes`, `sha256` |
| Registration | free, via a GitHub issue |
| Link updates | open a new issue; admin applies via the admin panel |

## Are you a publisher? Register your source in 3 steps

1. **Host your content in your own public GitHub repo**, following the schemas below. If you publish apps, put the APK files in your repo's **GitHub Releases** (step-by-step guide below). Never commit an APK into the repo itself — GitHub blocks files over 100 MB.
2. **Open a registration issue**: go to this repo's Issues tab → "Register a content source" and fill in the source type, a display name and the raw JSON link. Your GitHub account is recorded as the code owner.
3. Once approved, the bot validates your JSON, issues a **6-character code** and replies right in the issue. Users just enter that code on their TV. Done.

## How to upload an APK with GitHub Releases

Never used GitHub Releases? Follow this once and you'll have it. Starting point: you have an `.apk` file on your computer and a public GitHub repo.

1. Open your repo page on github.com.
2. In the right sidebar, click **Releases**. (If you don't see it, add `/releases` to the end of your repo URL.)
3. Click **Create a new release** (or **Draft a new release**).
4. Click **Choose a tag**, type a version tag like `v1.0`, then click **Create new tag on publish**. A tag is just a version label — any short name works.
5. Give the release a title, e.g. `Version 1.0`.
6. Find the box that says **Attach binaries by dropping them here or selecting them** and drag & drop your `.apk` file into it. Wait for the upload to finish. Each file can be up to **2 GB**.
7. Click **Publish release**.
8. On the release page, right-click your `.apk` file and choose **Copy link address**. That's your download link — paste it into `apkUrl` in your `store.json`. It looks like `https://github.com/<user>/<repo>/releases/download/v1.0/x.apk`.

**Releasing a new version later?** Repeat these steps with a new tag (e.g. `v1.1`), then update `apkUrl` and `version` in your `store.json`. Old releases can stay — they don't hurt anything.

**Optional but recommended — sha256 checksum.** If you add a `sha256` field, the TV verifies the download before installing. Get the value by running one command in a terminal, in the folder containing the APK:

- macOS / Linux: `shasum -a 256 app.apk`
- Windows: `certutil -hashfile app.apk SHA256`

Copy the long string it prints into the `sha256` field. If you skip this, everything still works — the TV just doesn't verify the file.

## Schemas

Your repo needs one JSON file matching your source type. Copy a template below and replace the values.

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
- Optional: `iconUrl`, `sizeBytes`, `sha256`. If `sha256` is present the TV verifies the download against it (see the checksum step above).

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

- **Updating content** (adding apps, channels or feeds): just edit the JSON files in your repo — TVs pick the changes up automatically. Allow ~5 minutes for GitHub's CDN cache. No issue needed.
- **Moving your repo or changing the JSON path**: open a new registration issue with the new link, and mention the old code in the body so an admin can retire it. Link changes are applied through the admin panel, not automatically.

  Your users keep entering the same code either way. Do not delete your old repo until the admin confirms the new code is live.

## Repository layout

- `codes/{CODE}.json` — code directory: the TV resolves a code by fetching `https://raw.githubusercontent.com/launchpad2/tv/main/codes/{CODE}.json` to get `{type, name, url}`, then loads content directly from the publisher's repo (or from LaunchPad's R2 bucket for default content).
- `.github/` — registration form + the workflow that issues codes once an issue is labeled `approved`.
