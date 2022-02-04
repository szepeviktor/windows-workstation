// # user.js overrides
// Author: Viktor Szépe <viktor@szepe.net>
// Firefox version: 96.0

/*** NOTES ***/

// - Default search engine cannot be set programmatically.
// - Test leaks: https://xsinator.com/testing.html
// - Check _user.js.parrot: about:config
// - Check the console right after startup for any warnings/error messages related to non-applied prefs.

/*** [SECTION 0200]: GEOLOCATION / LANGUAGE / LOCALE ***/

// Hard-code geographic location
user_pref("geo.enabled", true);
user_pref("geo.provider.network.url",
    'data:application/json,{"location": {"lat": 47.5404847, "lng": 19.0342201}, "accuracy": 10.0}'
);
user_pref("browser.search.region", "HU");
user_pref("browser.search.isUS", false);
// test: https://browserleaks.com/geo

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

// Disable webGL
user_pref("webgl.disabled", true);
// test: https://browserleaks.com/webgl

/*** [SECTION 5500]: OPTIONAL HARDENING ***/

// Disable MathML
user_pref("mathml.disabled", true);
// test: https://browserleaks.com/features#mathml

// Disable in-content SVG
user_pref("svg.disabled", true);
// test: https://browserleaks.com/features#inlinesvg

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

// Disable updates
user_pref("extensions.update.enabled", false);

// uBlock Origin extension configuration
user_pref("extensions.ublock0.adminSettings",
    '{"userSettings":{"advancedUserEnabled":true,"webrtcIPAddressHidden":true},"netWhitelist":"paypal.com\\nszepe.net"}'
);

// Wrap long line in view source
user_pref("view_source.wrap_long_lines", true);

// Disable smooth scrolling on Home and End keypresses
user_pref("general.smoothScroll.other", false);
