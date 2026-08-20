import SwiftUI
import WebKit
import AVFoundation

// RODEO.VN — minimal iOS wrapper.
//
// The only reason this app exists: iOS suspends web audio when the screen locks
// UNLESS the hosting app holds an audio session and declares the `audio` background
// mode. Safari and Chrome decline to do that for web content; Brave does it, which is
// why playback survives there. This app does the same thing for one site.
//
// Two pieces make it work, and BOTH are required:
//   1. AVAudioSession category .playback, activated at launch (below).
//   2. UIBackgroundModes -> audio in Info.plist.

private let siteURL = URL(string: "https://rodeo.affluence.vn")!

@main
struct RodeoApp: App {
    init() {
        // Claim an audio session so iOS treats this app as a media player.
        // .playback keeps sound alive when the screen locks and ignores the ring/silent switch.
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("audio session failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            WebView(url: siteURL)
                .ignoresSafeArea(edges: .bottom)
                .preferredColorScheme(.dark)
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()

        // Play inline rather than handing off to the fullscreen native player,
        // which would take over the screen and defeat the custom UI.
        config.allowsInlineMediaPlayback = true

        // Empty set = no user gesture required, so playback can resume programmatically
        // (the page's own background-resume logic depends on this).
        config.mediaTypesRequiringUserActionForPlayback = []

        config.allowsPictureInPictureMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.bounces = false
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
