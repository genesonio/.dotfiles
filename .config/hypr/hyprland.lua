-- waybar, hyprpaper and hypridle run as systemd user services
-- under the uwsm session (graphical-session.target), so they are not started here.

hl.monitor({ output = "desc:Samsung Electric Company S24D332 0x59325956", mode = "1920x1080@74.97", position = "0x0", scale = 1 })

local terminal    = "kitty"
local fileManager = "thunar"

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprlock || uwsm stop")
    hl.dispatch(hl.dsp.focus({ workspace = 1 }))
    hl.exec_cmd(terminal)
end)

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 2,
        border_size = 1,
        col = {
            active_border   = "rgb(7dcfff)",
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper    = 0,
        disable_hyprland_logo      = true,
        initial_workspace_tracking = 1,
    },

    input = {
        kb_layout          = "us",
        kb_variant         = "intl",
        follow_mouse       = 1,
        force_no_accel     = false,
        sensitivity        = -0.8,
        numlock_by_default = true,
    },

    cursor = {
        inactive_timeout    = 0,
        no_hardware_cursors = true,
    },

    binds = {
        allow_workspace_cycles = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

hl.animation({ leaf = "global",        enabled = true,  speed = 1, bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 1, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 1, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 1, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 1, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 1, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1, bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = false })
hl.animation({ leaf = "workspacesOut", enabled = false })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 1, bezier = "quick" })

local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("$HOME/.local/bin/vicinae toggle"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("$HOME/.local/bin/vicinae deeplink vicinae://launch/clipboard/history"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("$HOME/.local/bin/vicinae deeplink vicinae://launch/core/search-emojis"))

hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd([[kill -9 "$(hyprctl activewindow -j | jq -r .pid)"]]))

local directions = { h = "left", l = "right", k = "up", j = "down" }
for key, dir in pairs(directions) do
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ direction = dir }))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ direction = dir }))
end

local workspaceKeys = {
    { key = "1",       ws = 1 },
    { key = "2",       ws = 2 },
    { key = "3",       ws = 3 },
    { key = "4",       ws = 4 },
    { key = "5",       ws = 5 },
    { key = "A",       ws = 6 },
    { key = "ALT + 1", ws = 7 },
    { key = "ALT + 2", ws = 8 },
    { key = "ALT + 3", ws = 9 },
    { key = "ALT + 4", ws = 10 },
}
for _, w in ipairs(workspaceKeys) do
    hl.bind(mainMod .. " + " .. w.key,            hl.dsp.focus({ workspace = w.ws }))
    hl.bind(mainMod .. " + SHIFT + " .. w.key,    hl.dsp.window.move({ workspace = w.ws }))
    hl.bind(mainMod .. " + CTRL + " .. w.key,     hl.dsp.window.move({ workspace = w.ws, follow = false }))
end

hl.bind("Print",                    hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mainMod .. " + B",          hl.dsp.exec_cmd("flatpak run com.google.Chrome --ozone-platform=wayland --disable-gpu"))
hl.bind(mainMod .. " + SHIFT + S",  hl.dsp.exec_cmd("flatpak run com.slack.Slack"))
hl.bind(mainMod .. " + SHIFT + P",  hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + TAB",        hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + SHIFT + R",  hl.dsp.exec_cmd("hyprcap rec region -c -n"))
hl.bind(mainMod .. " + N",          hl.dsp.exec_cmd("dunstctl set-paused toggle && pkill -RTMIN+8 waybar"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

for ws = 1, 6 do
    hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-3", persistent = true, default = ws == 1 })
end
for ws = 7, 10 do
    hl.workspace_rule({ workspace = tostring(ws), monitor = "DP-3", persistent = false })
end

hl.layer_rule({ match = { namespace = "vicinae" }, name = "vicinae-blur", blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "vicinae" }, name = "vicinae-no-animation", no_anim = true })

hl.window_rule({ name = "slack-ws3",   match = { class = "^(com.slack.Slack)$" }, workspace = "3 silent" })
hl.window_rule({ name = "salinha-ws5", match = { class = "^(salinha)$" }, workspace = "5 silent" })

hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name    = "flameshot",
    match   = { class = "flameshot", title = "flameshot" },
    no_anim = true,
    pin     = true,
    float   = true,
    move    = "0 0",
})

hl.window_rule({
    name             = "screen-sharing",
    match            = { class = "^(xwaylandvideobridge)$" },
    opacity          = "0.0 override",
    no_anim          = true,
    no_initial_focus = true,
    max_size         = "1 1",
    no_blur          = true,
    no_focus         = true,
})
