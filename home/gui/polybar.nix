{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.gui.polybar;
in
{
  options.local.gui.polybar.enable = mkEnableOption "Polybar";
  config = mkIf cfg.enable {
    services.polybar = mkIf (!config.home.isolation.active) {
      enable = true;
      package = pkgs.polybarFull;
      script = ''
        # Terminate already running bar instances
        killall -q polybar
        
        # Wait until the processes have been shut down
        while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
        
        # Launch Polybar, using default config location ~/.config/polybar/config
        polybar -r main & polybar -r secondary &
      '';

      settings = {
        "colors" = {
          # background = "\${xrdb:color0:#222}";
          background = "#AA000000";
          background-alt = "#00000000";
          # foreground = "\${xrdb:color7:#222}";
          foreground = "#ffffff";
          foreground-alt = "#ffffff";
          primary = "#ffffff";
          secondary = "#e60053";
          alert = "#bd2c40";
        };

        "bar/main" = {
          monitor = "${config.local.display."0"}";
          width = "100%";
          height = 30;
          offset-x = "0%";
          offset-y = "0%";
          radius = 0.0;
          fixed-center = false;

          background = "\${colors.background}";
          foreground = "\${colors.foreground}";

          line-size = 1;
          line-color = "#f0000000";

          border-size = 0;
          border-color = "#00000000";

          padding-left = 0;
          padding-right = 0;

          module-margin-left = 1;
          module-margin-right = 1;

          # font-0 = "fixed:pixelsize=10;1";
          font-0 = "JetBrains Mono Light:size=10;0";
          font-1 = "unifont:fontformat=truetype:size=8:antialias=false;0";
          font-2 = "siji:pixelsize=10;1";
          # font-2 = "FontAwesome5Free:style=Regular:size=10;4";

          modules-left = "i3";
          modules-center = "xwindow";
          modules-right = "xkeyboard pulseaudio filesystem memory cpu temperature gputemperature nvmetemperature wlan eth date semanatec";
          separator = "|";

          tray-position = "right";
          tray-padding = 2;

          # To allow other windows to be placed above the bar, or to avoid having the bar visible when in fullscreen mode,
          # you need to use the following two parameters. Note that it will tell the window manager to back off so no
          # area will be reserved, etc.
          #
          # wm-restack = "i3";
          # override-redirect = true;

          cursor-click = "pointer";
          cursor-scroll = "ns-resize";
        };

        "bar/secondary" = optionalAttrs (config.local.display."1" != null) {
          monitor = "${config.local.display."1"}";
          "inherit" = "bar/main";

          modules-left = "i3";
          modules-center = "xwindow";
          modules-right = "xkeyboard pulseaudio date";
          tray-position = "none";
        };

        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title:0:30:...%";
        };

        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          blacklist-0 = "num lock";

          format-prefix = "";
          format-prefix-foreground = "\${colors.foreground-alt}";

          label-layout = "%layout%";

          label-indicator-padding = 2;
          label-indicator-margin = 1;
          label-indicator-background = "\${colors.secondary}";
        };

        "module/filesystem" = {
          type = "internal/fs";
          interval = 10;

          mount-0 = "/";

          label-mounted = "%{F#0a81f5}%mountpoint%%{F-}: %used%/%total%";
          label-unmounted = "";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;

          # Only show workspaces on the same output as the bar
          # pin-workspaces = true

          label-mode-padding = 1;
          label-mode-foreground = "#000";
          label-mode-background = "\${colors.primary}";

          # focused = Active workspace on focused monitor
          label-focused = "%index%";
          label-focused-background = "\${colors.background}";
          label-focused-underline = "\${colors.primary}";
          label-focused-padding = 1;

          # unfocused = Inactive workspace on any monitor
          label-unfocused = "%index%";
          label-unfocused-padding = 1;

          # visible = Active workspace on unfocused monitor
          label-visible = "%index%";
          label-visible-background = "\${self.label-focused-background}";
          label-visible-underline = "\${self.label-focused-underline}";
          label-visible-padding = "\${self.label-focused-padding}";

          # urgent = Workspace with urgency hint set
          label-urgent = "%index%";
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding = 1;
        };

        "module/xbacklight" = {
          type = "internal/xbacklight";

          format = "<label> <bar>";
          label = "BL";

          bar-width = 10;
          bar-indicator = "|";
          bar-indicator-foreground = "#fff";
          bar-indicator-font = 2;
          bar-fill = "─";
          bar-fill-font = 2;
          bar-fill-foreground = "#9f78e1";
          bar-empty = "─";
          bar-empty-font = 2;
          bar-empty-foreground = "\${colors.foreground-alt}";
        };

        "module/backlight-acpi" = {
          "inherit" = "module/xbacklight";
          type = "internal/backlight";
          card = "intel_backlight";
        };

        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = "cpu ";
          format-prefix-foreground = "\${colors.foreground-alt}";
          label = "%percentage:2%%";
        };

        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = "mem ";
          format-prefix-foreground = "\${colors.foreground-alt}";
          label = "%percentage_used%%";
        };

        "module/wlan" = {
          type = "internal/network";
          interface = "wlp7s0";
          interval = 3.0;

          format-connected = "<ramp-signal> <label-connected>";
          label-connected = "%essid%";

          format-disconnected = "";
          # format-disconnected = "<label-disconnected>";
          # format-disconnected-underline = "\${self.format-connected-underline}";
          # label-disconnected = "%ifname% disconnected";
          # label-disconnected-foreground = "\${colors.foreground-alt}";

          ramp-signal-0 = "";
          ramp-signal-1 = "";
          ramp-signal-2 = "";
          ramp-signal-3 = "";
          ramp-signal-4 = "";
          ramp-signal-foreground = "\${colors.foreground-alt}";
        };

        "module/eth" = {
          type = "internal/network";
          interface = "enp8s0";
          interval = 3.0;

          format-connected-prefix = "";
          format-connected-prefix-foreground = "\${colors.foreground-alt}";
          label-connected = "%local_ip%";

          format-disconnected = "";
          # format-disconnected = "<label-disconnected>";
          # format-disconnected-underline = "\${self.format-connected-underline}";
          # label-disconnected = "%ifname% disconnected";
          # label-disconnected-foreground = "\${colors.foreground-alt}";
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;

          date = " %d/%m/%Y";
          date-alt = " %c";

          time = "%H:%M";
          time-alt = " [%s]";

          format-prefix = "";
          format-prefix-foreground = "\${colors.foreground-alt}";

          label = "%date% %time%";
        };

        #      "module/semanatec" = {
        #        type = "custom/script"
        #        exec = "/home/fabian/bin/semanatec/target/release/semanatec"
        #        interval = 3600
        #        format-prefix = ""
        #      };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";

          format-volume = "<label-volume>";
          label-volume = "vol %percentage%%";
          label-volume-foreground = "\${root.foreground}";

          label-muted = "vol 0%";
          label-muted-foreground = "\${root.foreground}";

          bar-volume-width = 10;
          bar-volume-foreground-0 = "#55aa55";
          bar-volume-foreground-1 = "#55aa55";
          bar-volume-foreground-2 = "#55aa55";
          bar-volume-foreground-3 = "#55aa55";
          bar-volume-foreground-4 = "#55aa55";
          bar-volume-foreground-5 = "#f5a70a";
          bar-volume-foreground-6 = "#ff5555";
          bar-volume-gradient = false;
          bar-volume-indicator = "|";
          bar-volume-indicator-font = 2;
          bar-volume-fill = "─";
          bar-volume-fill-font = 2;
          bar-volume-empty = "─";
          bar-volume-empty-font = 2;
          bar-volume-empty-foreground = "\${colors.foreground-alt}";
        };

        "module/alsa" = {
          type = "internal/alsa";

          format-volume = "<label-volume> <bar-volume>";
          label-volume = "VOL";
          label-volume-foreground = "\${root.foreground}";

          format-muted-prefix = "vol ";
          format-muted-foreground = "\${colors.foreground-alt}";
          label-muted = "sound muted";

          bar-volume-width = 10;
          bar-volume-foreground-0 = "#55aa55";
          bar-volume-foreground-1 = "#55aa55";
          bar-volume-foreground-2 = "#55aa55";
          bar-volume-foreground-3 = "#55aa55";
          bar-volume-foreground-4 = "#55aa55";
          bar-volume-foreground-5 = "#f5a70a";
          bar-volume-foreground-6 = "#ff5555";
          bar-volume-gradient = false;
          bar-volume-indicator = "|";
          bar-volume-indicator-font = 2;
          bar-volume-fill = "─";
          bar-volume-fill-font = 2;
          bar-volume-empty = "─";
          bar-volume-empty-font = 2;
          bar-volume-empty-foreground = "\${colors.foreground-alt}";
        };

        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "ADP1";
          full-at = 98;

          format-charging = "<animation-charging> <label-charging>";
          format-charging-underline = "#ffb52a";

          format-discharging = "<animation-discharging> <label-discharging>";
          format-discharging-underline = "\${self.format-charging-underline}";

          format-full-prefix = " ";
          format-full-prefix-foreground = "\${colors.foreground-alt}";
          format-full-underline = "\${self.format-charging-underline}";

          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-foreground = "\${colors.foreground-alt}";

          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-foreground = "\${colors.foreground-alt}";
          animation-charging-framerate = 750;

          animation-discharging-0 = "";
          animation-discharging-1 = "";
          animation-discharging-2 = "";
          animation-discharging-foreground = "\${colors.foreground-alt}";
          animation-discharging-framerate = 750;
        };

        "module/temperature" = {
          type = "internal/temperature";
          warn-temperature = 60;
          hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1/temp2_input";

          format = "<ramp> <label>";
          format-warn = "<ramp> <label-warn>";

          label = "cpu %temperature-c%";
          label-warn = "cpu %temperature-c%";
          label-warn-foreground = "\${colors.secondary}";

          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
          ramp-foreground = "\${colors.foreground-alt}";
        };

        "module/gputemperature" = {
          type = "internal/temperature";
          warn-temperature = 60;
          hwmon-path = "/sys/devices/pci0000:00/0000:00:03.1/0000:09:00.0/hwmon/hwmon3/temp1_input";

          format = "<ramp> <label>";
          format-warn = "<ramp> <label-warn>";

          label = "gpu %temperature-c%";
          label-warn = "gpu %temperature-c%";
          label-warn-foreground = "\${colors.secondary}";

          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
          ramp-foreground = "\${colors.foreground-alt}";
        };

        "module/nvmetemperature" = {
          type = "internal/temperature";
          warn-temperature = 60;
          hwmon-path = "/sys/devices/pci0000:00/0000:00:01.1/0000:01:00.0/hwmon/hwmon0/temp1_input";

          format = "<ramp> <label>";
          format-warn = "<ramp> <label-warn>";

          label = "M.2 %temperature-c%";
          label-warn = "M.2 %temperature-c%";
          label-warn-foreground = "\${colors.secondary}";

          ramp-0 = "";
          ramp-1 = "";
          ramp-2 = "";
          ramp-foreground = "\${colors.foreground-alt}";
        };

        "module/powermenu" = {
          type = "custom/menu";

          expand-right = true;

          format-spacing = 1;

          label-open = "";
          label-open-foreground = "\${colors.secondary}";
          label-close = " cancel";
          label-close-foreground = "\${colors.secondary}";
          label-separator = "|";
          label-separator-foreground = "\${colors.foreground-alt}";

          menu-0-0 = "reboot";
          menu-0-0-exec = "menu-open-1";
          menu-0-1 = "power off";
          menu-0-1-exec = "menu-open-2";

          menu-1-0 = "cancel";
          menu-1-0-exec = "menu-open-0";
          menu-1-1 = "reboot";
          menu-1-1-exec = "sudo reboot";

          menu-2-0 = "power off";
          menu-2-0-exec = "sudo poweroff";
          menu-2-1 = "cancel";
          menu-2-1-exec = "menu-open-0";
        };

        "module/sink_changer" = {
          type = "custom/script";
          exec = "/home/fabian/bin/polybar_scripts/info.sh";
          label = "%output%";
          click-left = "/home/fabian/bin/polybar_scripts/sink_changer.sh";
          # format-prefix = " ";
          interval = "0";
          # format-prefix-foreground = "${colors.foreground-alt}";
        };

        "settings" = {
          screenchange-reload = true;
          # compositing-background = "xor";
          # compositing-background = "screen";
          # compositing-foreground = "source";
          # compositing-border = "over";
          # pseudo-transparency = false;
        };

        "global/wm" = {
          margin-top = 5;
          margin-bottom = 5;
        };
      };
    };
  };
}
