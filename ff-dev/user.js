// about:config
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.rights.3.shown", true);

user_pref("app.update.enabled", false);
user_pref("app.update.auto", false);
user_pref("app.update.service.enabled", false);
user_pref("browser.search.update", false);
user_pref("extensions.update.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("device.sensors.enabled", false);
user_pref("devtools.debugger.enabled", false);
user_pref("devtools.inspector.enabled", false);
user_pref("devtools.netmonitor.enabled", false);

user_pref("browser.cache.disk.enable", false);
user_pref("browser.cache.memory.capacity", 256000); // 256 MB
user_pref("places.history.enabled", false);
user_pref("privacy.clearOnShutdown.cache", false);
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.formdata", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.offlineApps", false);
user_pref("privacy.clearOnShutdown.passwords", false);
user_pref("privacy.clearOnShutdown.sessions", false);
user_pref("privacy.clearOnShutdown.siteSettings", false);
user_pref("browser.formfill.enable", false);
user_pref("signon.rememberSignons", false);
user_pref("datareporting.healthreport.service.firstRun", true);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);
user_pref("browser.newtabpage.enhanced", false);

user_pref("plugin.state.flash", 1);
user_pref("browser.displayedE10SPrompt.1", 1);
user_pref("browser.displayedE10SNotice", 4);
user_pref("browser.tabs.remote", true);
user_pref("browser.tabs.remote.autostart", true);
user_pref("browser.reader.detectedFirstArticle", true);
user_pref("browser.urlbar.userMadeSearchSuggestionsChoice", true);

user_pref("extensions.autoDisableScopes", 11); // 15 - 4 = ALL - SCOPE_APPLICATION
user_pref("extensions.enabledScopes", 5); // 15 - 8 - 2 = ALL - SCOPE_SYSTEM - SCOPE_USER
user_pref("extensions.adblockplus.savestats", false);
user_pref("extensions.adblockplus.frameobjects", false);

user_pref("layout.word_select.stop_at_punctuation", false);
user_pref("layout.word_select.eat_space_to_next_word", false);
