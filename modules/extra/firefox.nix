{ inputs, ... }:
{
  flake.homeModules.firefox =
    { pkgs, ... }:
    {
      stylix.targets.firefox = {
        profileNames = [ "default" ];
      };
      programs.firefox = {
        enable = true;
        policies = {
          AppAutoUpdate = false;
          BackgroundAppUpdate = false;
          DisableBuiltinPDFViewer = true;
          DisableFirefoxStudies = true;
          DisableFirefoxAccounts = true;
          DisableFirefoxScreenshots = true;
          DisableForgetButton = true;
          DisableMasterPasswordCreation = true;
          DisableProfileImport = true;
          DisableProfileRefresh = true;
          DisableSetDesktopBackground = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFormHistory = true;
          DisablePasswordReveal = true;
          BlockAboutConfig = false;
          BlockAboutProfiles = true;
          BlockAboutSupport = true;
          DisplayMenuBar = "never";
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          ExtensionSettings = {
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              default_area = "navbar";
            };
          };
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
        };
        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          userContent = ''
            * { scrollbar-width: thin !important; }
          '';
          settings = {
            "browser.compactmode.show" = true;
            "browser.newtab.url" = "about:blank";
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.enabled" = false;
            "browser.quickactions.enabled" = false;
            "browser.startup.homepage" = "https://glance.elpsy.moe";
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.uidensity" = 1;
            "dom.security.https_only_mode" = true;
            "extensions.autoDisableScopes" = 0;
            "extensions.pocket.enabled" = false;
            "findbar.highlightAll" = true;
            "general.smoothScroll" = false;
            "privacy.trackingprotection.enabled" = true;
            "toolkit.cosmeticAnimations.enabled" = false;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };
          extensions = {
            packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              ublock-origin
              bitwarden
              tridactyl
              seventv
              stylus
              sponsorblock
            ];
          };
          userChrome = ''
            :root {
            	--ctp-base:      #1e1e2e;
            	--ctp-mantle:     #181825;
            	--ctp-crust:      #11111b;
            	--ctp-surface0:   #313244;
            	--ctp-surface1:   #45475a;
            	--ctp-overlay1:   #7f849c;
            	--ctp-subtext0:   #a6adc8;
            	--ctp-text:       #cdd6f4;
            	--ctp-mauve:      #cba6f7;
              --ctp-blue:       #89b4fa;
            	--ctp-pink:       #f5c2e7;
            	--tab-active-bg-color: var(--ctp-blue);
            	--tab-inactive-bg-color: var(--ctp-surface0);
            	--tab-active-fg-fallback-color: var(--ctp-crust);		/* color of text in an active tab without a container */
            	--tab-inactive-fg-fallback-color: var(--ctp-overlay1);		/* color of text in an inactive tab without a container */
            	--urlbar-focused-bg-color: var(--ctp-surface1);
            	--urlbar-not-focused-bg-color: var(--ctp-mantle);
            	--toolbar-bgcolor: var(--ctp-base) !important;
            	--tab-font: 'DejaVu Sans Mono';
            	--urlbar-font: 'DejaVu Sans Mono';
            	--navbar-height-setting: 24px;
            	--tab-min-height: 16px !important;
            	--arrowpanel-menuitem-padding: 2px !important;
            	--arrowpanel-border-radius: 0 !important;
            	--arrowpanel-menuitem-border-radius: 0 !important;
            	--toolbarbutton-border-radius: 0 !important;
            	--toolbar-field-focus-background-color: var(--urlbar-focused-bg-color) !important;
            	--toolbar-field-background-color: var(--urlbar-not-focused-bg-color) !important;
            	--toolbar-field-focus-border-color: transparent !important;
            	--chrome-block-radius: 0 !important;
            	--urlbar-border-radius: 0 !important;
            	--panel-box-shadow-margin: 0 !important;
            	--toolbarbutton-padding-inner: 0.3em !important;
            }
            #statuspanel { display: none !important; }
            menupopup, panel { --panel-border-radius: 0 !important; }
            menu, menuitem, menucaption { border-radius: 0 !important; }
            menupopup > #context-navigation { display: none !important; }
            menupopup > #context-sep-navigation { display: none !important; }
            #back-button { display: none; }
            #forward-button { display: none; }
            #reload-button { display: none; }
            #stop-button { display: none; }
            #home-button { display: none; }
            #library-button { display: none; }
            #customizableui-special-spring1, #customizableui-special-spring2 { display: none; }
            .private-browsing-indicator-with-label { display: none; }
            toolbar .toolbarbutton-1 { padding: 0 0 !important; }
            #downloads-button {
            	margin-left: 2px !important;
            }
            #PanelUI-menu-button {
            	padding: 0 4px 0 0 !important;
            }
            #urlbar-container {
            	--urlbar-container-height: var(--navbar-height-setting) !important;
            	margin-left: 0 !important;
            	margin-right: 0 !important;
            	padding-top: 0 !important;
            	padding-bottom: 0 !important;
            	font-family: var(--urlbar-font, 'monospace');
            	font-size: 11px;
            }
            #urlbar {
            	padding-left: 0.5em !important;
            	--urlbar-height: var(--navbar-height-setting) !important;
            	--urlbar-toolbar-height: var(--navbar-height-setting) !important;
            	min-height: var(--navbar-height-setting) !important;
            }
            .urlbar {
            	overflow: hidden !important;
            	background-color: var(--urlbar-not-focused-bg-color);
            }
            #urlbar-input {
            	margin-left: 0.4em !important;
            	margin-right: 0.4em !important;
            }
            #urlbar > .urlbar-input-container {
            	padding: 0 0.4em 0 0 !important;
            }
            #navigator-toolbox {
            	border: none !important;
            }
            toolbarbutton, toolbaritem {
            	padding: 0 !important;
            	margin: 0 !important;
            }
            #nav-bar {
            	height: var(--navbar-height-setting) !important;
            }
            #unified-extensions-view {
            	--uei-icon-size: 16px;
            }
            .unified-extensions-item-message-deck,
            #unified-extensions-view > .panel-header,
            #unified-extensions-view > toolbarseparator,
            #unified-extensions-manage-extensions {
            	display: none !important;
            }
            .panel-subview-body {
            	padding: 3px 0 !important;
            }
            #unified-extensions-view .toolbarbutton-icon {
            	padding: 0 !important;
            }
            .unified-extensions-item-contents {
            	line-height: 1 !important;
            	white-space: nowrap !important;
            }
            #unified-extensions-panel .unified-extensions-item {
            	margin-block: 0 !important;
            }
            .toolbar-menupopup :is(menu, menuitem), .subview-subheader, panelview
            .toolbarbutton-1, .subviewbutton, .widget-overflow-list .toolbarbutton-1 {
            	padding: 4px !important;
            }
            menupopup, panel { &::part(content) { height: auto !important; } }
            #editBMPanel_folderTree, #editBMPanel_tagsSelector {
            	height: 40vh !important;
            }
            #editBMPanel_folderMenuList {
            	display: none !important;
            }
            #pageActionButton { display: none; }
            #pocket-button { display: none; }
            #urlbar-zoom-button { display: none; }
            #tracking-protection-icon-container { display: none !important; }
            #urlbar-searchmode-switcher { display: none; }
            #searchmode-switcher-chicklet { display: none !important; }
            #identity-icon-box {
            	margin-inline-end: 0 !important;
            	padding: 0 4px !important;
            }
            .tabbrowser-tab[usercontextid] > .tab-stack > .tab-background > .tab-context-line {
            	display: none !important;
            }
            .urlbar-go-button, #urlbar-revert-button-container { display: none !important; }
            #userContext-label, #userContext-indicator { display: none !important;}
            #titlebar {
            	--proton-tab-block-margin: 0 !important;
            	--tab-block-margin: 0 !important;
            }
            #TabsToolbar, .tabbrowser-tab {
            	max-height: var(--tab-min-height) !important;
            	font-size: 11px !important;
            }
            tab:not([selected="true"]) {
            	background-color: var(--tab-inactive-bg-color) !important;
            	color: var(--identity-icon-color, var(--tab-inactive-fg-fallback-color)) !important;
            }
            tab {
            	font-family: var(--tab-font, monospace);
            	font-weight: bold;
            	border: none !important;
            	padding-top: 0 !important;
            }
            .tab-content {
            	padding: 0 0 0 var(--tab-inline-padding);
            }
            .tab-background {
            	margin-block: 0 !important;
            	min-height: var(--tab-min-height);
            	outline-offset: 0 !important;
            }
            .tabbrowser-tab[fadein] {
            	max-width: 100vw !important;
            	border: none
            }
            #tabbrowser-tabs .tabbrowser-tab .tab-close-button { display: none !important; }
            .tabbrowser-tab {
            	/* remove border between tabs */
            	padding-inline: 0 !important;
            	/* reduce fade effect of tab text */
            	--tab-label-mask-size: 1em !important;
            	/* fix pinned tab behaviour on overflow */
            	overflow-clip-margin: 0 !important;
            }
            #tabbrowser-tabs .tabbrowser-tab[selected] .tab-content {
            	background: var(--tab-active-bg-color) !important;
            	color: var(--identity-icon-color, var(--tab-active-fg-fallback-color)) !important;
            }
            #tabbrowser-tabs .tabbrowser-tab:hover:not([selected]) .tab-content {
            	background: var(--tab-active-bg-color) !important;
            }
            .titlebar-buttonbox-container { display: none; }
            #trust-icon-container {margin: auto 0 !important;}
            .titlebar-spacer { display: none !important; }
            #tabbrowser-tabs:not([noshadowfortests]) .tab-background:is([selected], [multiselected]) {
            	box-shadow: none !important;
            }
            #pinned-tabs-container {
            	margin-inline-end: 0 !important;
            }
            #alltabs-button { display: none !important }
            #tabbrowser-tabs:not([secondarytext-unsupported]) .tab-label-container {
            	height: var(--tab-min-height) !important;
            }
            #tabbrowser-tabs {
            	min-height: var(--tab-min-height) !important;
            }
            #scrollbutton-up, #scrollbutton-down { display: none !important; }
            #tabs-newtab-button {
            	display: none !important;
            }
            #private-browsing-indicator-with-label {
            	display: none;
            }
            :root[inFullscreen] > body > #browser {
            	margin-top: 0 !important;
            }
            :root {
            	--uc-navbar-transform: calc(0px - var(--navbar-height-setting));
            }
            #navigator-toolbox > div {
            	display: contents;
            }
            :root[sessionrestored] :where(
            	#nav-bar,
            	#PersonalToolbar,
            	#tab-notification-deck,
            	.global-notificationbox
            ) {
            	transform: translateY(var(--uc-navbar-transform));
            }
            :root:is([customizing], [chromehidden*="toolbar"]) :where(
            	#nav-bar,
            	#PersonalToolbar,
            	#tab-notification-deck,
            	.global-notificationbox
            ) {
            	transform: none !important;
            	opacity: 1 !important;
            }
            #nav-bar:not([customizing]) {
            	opacity: 0;
            	position: relative;
            	z-index: 2;
            }
            #titlebar {
            	position: relative;
            	z-index: 3;
            }
            #navigator-toolbox,
            #sidebar-box,
            #sidebar-main,
            #sidebar-splitter,
            #tabbrowser-tabbox {
            	z-index: auto !important;
            }
            #navigator-toolbox:focus-within > .browser-toolbar {
            	transform: translateY(0);
            	opacity: 1;
            }
            #titlebar:hover ~ .browser-toolbar,
            .browser-titlebar:hover ~ :is(#nav-bar, #PersonalToolbar),
            #nav-bar:hover,
            #nav-bar:hover + #PersonalToolbar {
            	transform: translateY(0);
            	opacity: 1;
            }
            :root[sessionrestored] #urlbar[popover] {
            	opacity: 0;
            	pointer-events: none;
            	transform: translateY(var(--uc-navbar-transform));
            }
            #mainPopupSet:has(> [panelopen]:not(
            	#ask-chat-shortcuts,
            	#selection-shortcut-action-panel,
            	#chat-shortcuts-options-panel,
            	#tab-preview-panel
            )) ~ toolbox #urlbar[popover],
            .browser-titlebar:is(:hover, :focus-within) ~ #nav-bar #urlbar[popover],
            #nav-bar:is(:hover, :focus-within) #urlbar[popover],
            #urlbar-container > #urlbar[popover]:is([focused], [open]) {
            	opacity: 1;
            	pointer-events: auto;
            	transform: translateY(0);
            }
            #mainPopupSet:has(> [panelopen]:not(
            	#ask-chat-shortcuts,
            	#selection-shortcut-action-panel,
            	#chat-shortcuts-options-panel,
            	#tab-preview-panel
            )) ~ #navigator-toolbox > .browser-toolbar {
            	transform: translateY(0);
            	opacity: 1;
            }
            :root[sessionrestored]:not([chromehidden~="toolbar"]) > body > #browser {
            	margin-top: var(--uc-navbar-transform);
            }
          '';
        };
      };
    };
}
