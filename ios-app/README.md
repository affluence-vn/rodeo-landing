# RODEO iOS wrapper — background audio on the lock screen

A ~60-line app whose only job is to host rodeo.affluence.vn in a web view **while holding an
audio session**, so iOS keeps the music playing when the screen locks.

This is the same mechanism Brave uses. Safari and Chrome on iOS deliberately don't do it for
web content, which is why the site alone can't achieve it no matter how it's written.

## Prerequisite

**Xcode must be installed** (App Store, ~10 GB). Command Line Tools alone are not enough —
they ship no iOS SDK. Verify with:

```bash
xcodebuild -version
```

## Build it (about 5 minutes)

1. Xcode → **File ▸ New ▸ Project… ▸ iOS ▸ App**.
   - Product Name: `Rodeo`
   - Interface: **SwiftUI**, Language: **Swift**
   - Save it anywhere (not inside this folder, to keep the site repo clean).

2. Delete the generated `ContentView.swift` and the generated `<Name>App.swift`, then drag
   **`RodeoApp.swift`** from this folder into the project ("Copy items if needed" checked).

3. Select the project in the sidebar → target **Rodeo** → **Info** tab. Add this key:
   - **Permitted background modes** (`UIBackgroundModes`) → add item → **Audio, AirPlay, and Picture in Picture**

   This is the non-negotiable half. Without it iOS suspends the audio the moment the screen
   locks, no matter what the Swift code does.

4. Target → **Signing & Capabilities** → check *Automatically manage signing* and pick your
   Apple ID under Team. A free personal Apple ID works.

5. Plug in the iPhone, select it as the run destination, press **▶**.
   First launch: the phone will ask you to trust the developer under
   *Settings ▸ General ▸ VPN & Device Management*.

## The catch with a free Apple ID

Apps signed with a free personal team **expire after 7 days** and must be re-run from Xcode
to renew. A paid Apple Developer account ($99/yr) extends that to a year. Nothing else
differs — the app itself is identical.

## Note on distribution

This is built for your own device. Apple rejects App Store submissions that are thin wrappers
around a website (Guideline 4.2), and shipping something that plays YouTube audio in the
background would run into YouTube's terms besides — background playback is a Premium feature.
Personal sideloading is the realistic path.

## If you'd rather not install Xcode

Use Brave, which already holds that audio session:

1. **Shortcuts** app → new shortcut → add the **Open URLs** action.
2. URL: `https://rodeo.affluence.vn` — set it to open in **Brave**.
3. Shortcut's share menu → **Add to Home Screen**.

You get a tappable icon and working lock-screen audio with nothing to build.
