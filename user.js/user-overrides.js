

// user.js overrides
// Author: Viktor Szépe <viktor@szepe.net>
// Firefox version: 96.0
// Prepend: https://github.com/arkenfox/user.js/raw/96.0/user.js

/*** NOTES ***/

// - Default search engine cannot be set programmatically.
// - Test leaks: https://xsinator.com/testing.html
// - Check the console right after startup for any warnings/error messages related to non-applied prefs.
// - Check _user.js.parrot: about:config

user_pref("_user.js.parrot", "user-overrides.js parse error");


/*** [SECTION 0200]: GEOLOCATION / LANGUAGE / LOCALE ***/

// Hard-code geographic location
user_pref("geo.enabled", true);
user_pref("geo.provider.network.url",
    'data:application/json,{"location": {"lat": 47.5404847, "lng": 19.0342201}, "accuracy": 10.0}'
);
user_pref("browser.search.region", "HU");
user_pref("browser.search.isUS", false);
// test: https://browserleaks.com/geo

/*** [SECTION 1000]: DISK AVOIDANCE ***/

// Enable disk cache as it is on a RAM disk
user_pref("browser.cache.disk.enable", true);

/*** [SECTION 0600]: BLOCK IMPLICIT OUTBOUND ***/

// Disable hyperlink auditing
user_pref("browser.send_pings", false);
// test: https://requestbin.com/r
// <a href="https://www.mozilla.org/en-US/firefox/new/"
//    target="_blank"
//    ping="https://?????????????.x.pipedream.net">Click here then see empty requestbin</a>

/*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS / IPv6 ***/

// Use SOCKS proxy by PuTTY
user_pref("network.proxy.type", 1);
user_pref("network.proxy.socks", "localhost");
user_pref("network.proxy.socks_port", 4096);
user_pref("network.proxy.socks_remote_dns", true);

/*** [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP) ***/

// Disable TLS 1.0 and TLS 1.1
// Minimum required is TLS 1.2
user_pref("security.tls.version.min", 3);
// Maximum required is TLS 1.3
user_pref("security.tls.version.max", 4);
// test: https://browserleaks.com/ssl
// test: https://www.ssllabs.com/ssltest/viewMyClient.html

/*** [SECTION 1600]: HEADERS / REFERERS ***/

// Always send a cross-origin referer
user_pref("network.http.referer.XOriginPolicy", 0);

/*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/

// Disable WebRTC
// And stop internal IP address leak.
user_pref("media.peerconnection.enabled", false);
// test: https://browserleaks.com/webrtc

/*** [SECTION 2600]: MISCELLANEOUS ***/

// Disable development tools
user_pref("devtools.inspector.enabled", false);
user_pref("devtools.debugger.enabled", false);
user_pref("devtools.netmonitor.enabled", false);

// Activate extensions in core
// 15 - 8 - 2 = ALL - SCOPE_SYSTEM - SCOPE_USER
user_pref("extensions.enabledScopes", 5);
// 15 - 4 = ALL - SCOPE_APPLICATION
user_pref("extensions.autoDisableScopes", 11);

/*** [SECTION 4500]: RFP (RESIST FINGERPRINTING) ***/

// Disable RFP letterboxing
user_pref("privacy.resistFingerprinting.letterboxing", false);

// Disable webGL
user_pref("webgl.disabled", true);
// test: https://browserleaks.com/webgl

/*** [SECTION 5000]: OPTIONAL OPSEC ***/

// Do not remember signongs
user_pref("signon.rememberSignons", false);

/*** [SECTION 5500]: OPTIONAL HARDENING ***/

// Disable MathML
user_pref("mathml.disabled", true);
// test: https://browserleaks.com/features#mathml

// Disable Graphite
user_pref("gfx.font_rendering.graphite.enabled", false);

// Disable asmjs
user_pref("javascript.options.asmjs", false);

// Disable Ion and JIT
user_pref("javascript.options.ion", false);
user_pref("javascript.options.baselinejit", false);
user_pref("javascript.options.jit_trustedprincipals", true);

// Disable WebAssembly
user_pref("javascript.options.wasm", false);

/*** [SECTION 7000]: DON'T BOTHER ***/

// Disable push notifications
user_pref("dom.push.enabled", false);
// test: https://hvg.hu/

/*** [SECTION 9000]: PERSONAL ***/

// Disable Pocket
user_pref("extensions.pocket.enabled", false);

// Disable autocopy on Linux
user_pref("clipboard.autocopy", false);

// Enforce extension signing
user_pref("xpinstall.signatures.required", true);

// Do not manage offline status
user_pref("network.manage-offline-status", false);

// Disable extension and theme update checks
user_pref("extensions.update.enabled", false);

// Opt-out of add-on metadata updates
user_pref("extensions.getAddons.cache.enabled", false);

// Wrap long lines in view source
user_pref("view_source.wrap_long_lines", true);

// Proper text selection on double-click
user_pref("layout.word_select.eat_space_to_next_word", false);
user_pref("layout.word_select.stop_at_punctuation", false);

// Disable smooth scrolling on Home and End keypresses
user_pref("general.smoothScroll.other", false);

// Disable Firefox Accounts & Sync
user_pref("identity.fxaccounts.enabled", false);

// Export bookmarks to an HTML file at shutdown
user_pref("browser.bookmarks.autoExportHTML", true);

// uBlock Origin extension configuration
user_pref("extensions.ublock0.adminSettings",
    '{"userSettings":{"advancedUserEnabled":true,"webrtcIPAddressHidden":true},"netWhitelist":"paypal.com\\nszepe.net"}'
);


user_pref("_user.js.parrot", "SUCCESS: user.js and user-overrides.js are OK.");
