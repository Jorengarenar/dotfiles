// Don't see first-run welcome messages etc.
user_pref("browser.shell.checkDefaultBrowser",        false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("datareporting.policy.firstRunURL",         "");
user_pref("browser.uitour.enabled",                   false);
user_pref("doh-rollout.doneFirstRun",                 true);
user_pref("trailhead.firstrun.didSeeAboutWelcome",    true);

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// General prefs
user_pref("browser.startup.page",          1);
user_pref("browser.startup.homepage",      "about:home");
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"downloads-button\",\"bookmarks-menu-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"cookieautodelete_kennydo_com-browser-action\",\"find-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"personal-bookmarks\"]},\"seen\":[\"developer-button\",\"ublock0_raymondhill_net-browser-action\",\"_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action\",\"cookieautodelete_kennydo_com-browser-action\",\"firefox_tampermonkey_net-browser-action\",\"simple-translate_sienori-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"toolbar-menubar\",\"TabsToolbar\",\"PersonalToolbar\"],\"currentVersion\":16,\"newElementCount\":11}");

user_pref("dom.webnotifications.enabled ", false);

user_pref("widget.content.allow-gtk-dark-theme", true);

user_pref("browser.compactmode.show", true);
user_pref("browser.proton.enabled", false);

user_pref("extensions.webextensions.uuids", "{\"CookieAutoDelete@kennydo.com\":\"0b6488ee-307d-456f-a73d-79f23aad543a\",\"simple-translate@sienori\":\"2b28de58-ee73-4916-8cf3-58cd399a1c14\",\"{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}\":\"7e6879ad-8bcb-4554-b092-35c895d50629\",\"firefox@tampermonkey.net\":\"0d0b4346-e57b-4e66-96c8-daf3a7350b1b\",\"{4d567245-e70d-466a-bb2f-390fc7fb25c2}\":\"9539c9f2-6fbe-4f26-b561-ff20d2376260\",\"doh-rollout@mozilla.org\":\"9ebab69c-ca09-4aba-9f37-c0c54e569c2c\",\"formautofill@mozilla.org\":\"a6427358-c534-4558-ae6f-dc4e998d9291\",\"screenshots@mozilla.org\":\"46225d83-fb07-4b0f-97d7-5293d83cc3a5\",\"webcompat-reporter@mozilla.org\":\"1e1bfd00-ce80-4bb2-8366-8b72e65ac259\",\"webcompat@mozilla.org\":\"d5f61907-d7da-415f-aac2-e3950d9b9dad\",\"google@search.mozilla.org\":\"651625ee-e00e-4c53-8c46-db84d4ea2eec\",\"amazondotcom@search.mozilla.org\":\"57102ad8-5148-4132-99e7-45272e9be40a\",\"wikipedia@search.mozilla.org\":\"2e45368c-0098-4e28-ab3f-a2489523730e\",\"bing@search.mozilla.org\":\"16574398-2a51-4de6-a987-a3d5be9d561f\",\"ddg@search.mozilla.org\":\"c5b63b48-4cb6-4cf5-9ea7-dc60879ae202\",\"firefox-compact-dark@mozilla.org\":\"76a7d454-f8c0-4667-9ca7-00b4bc9b7d3c\",\"uBlock0@raymondhill.net\":\"9452ba93-8dc6-4993-9cc5-7bec7c0cb5c2\"}");

user_pref("browser.aboutConfig.showWarning", false);

user_pref("browser.ctrlTab.recentlyUsedOrder", false);
user_pref("browser.download.useDownloadDir",   false);
user_pref("browser.urlbar.suggest.topsites",   false);
user_pref("general.autoScroll",                true);
user_pref("media.eme.enabled",                 true);   // enable DRM

user_pref("browser.tabs.closeTabByDblclick", true);
user_pref("browser.bookmarks.editDialog.showForNewBookmarks", true);
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

user_pref("browser.search.geoSpecificDefaults", true);

user_pref("identity.fxaccounts.enabled", false);

user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons",   false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// New tabpage
user_pref("browser.newtabpage.activity-stream.default.sites",            "");
user_pref("browser.newtabpage.pinned",                                   "");
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets",           false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites",           false);
user_pref("browser.newtabpage.activity-stream.showSearch",               true);

user_pref("browser.chrome.toolbar_tips", false);

// Privacy and telemery
user_pref("browser.pagethumbnails.capturing_disabled",  true);
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.healthreport.uploadEnabled",   false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("network.cookie.cookieBehavior",              3);
user_pref("network.cookie.thirdparty.sessionOnly",      true);
user_pref("privacy.donottrackheader.enabled",           true);
user_pref("security.insecure_password.ui.enabled",      true);
user_pref("signon.rememberSignons",                     false);
user_pref("toolkit.telemetry.unified", false);

// The developer tools configuration
user_pref("devtools.theme",                    "dark");
user_pref("devtools.editor.tabsize",           2);
user_pref("devtools.editor.expandtab",         true);
user_pref("devtools.editor.autoclosebrackets", false);
user_pref("devtools.editor.detectindentation", true);
user_pref("devtools.editor.enableCodeFolding", true);
user_pref("devtools.editor.autocomplete",      true);
