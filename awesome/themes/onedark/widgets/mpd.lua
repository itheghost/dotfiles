local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Icon + Text
local icon = wibox.widget.imagebox()
local mpd_text = wibox.widget.textbox()

local mpd_widget = wibox.widget {
    icon,
    {
        mpd_text,
        layout = wibox.container.margin,
        top = 2,
		right = -2,
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = 1,
}

-- Tooltip (optional, remove if not needed)
local tooltip = awful.tooltip {
    objects = { mpd_widget },
    mode = "outside",
	text = "MPD Info",
	fg = "#FFFFFF",
	bg = "#111111",
	font = "FiraCode Nerd Font 9",
	preferred_alignments = "middle",
}

-- UPDATE FUNCTION
local function update()
    icon.image = beautiful.widget_music  -- your music icon

    -- Ask MPD what is playing
    local p = io.popen("mpc status 2>/dev/null", "r")
    if not p then
        mpd_text.text = "MPD Error"
        tooltip.text = "MPD unreachable"
        return
    end

    local data = p:read("*a")
    p:close()

    if data == "" then
        mpd_text.text = "MPD Off"
        tooltip.text = "MPD is not running."
        return
    end

    -- Extract the title (first line of mpc output)
    local title = data:match("([^\n]+)")
    local state = data:match("%[(%a+)%]") or "stopped"

    if not title or title:match("^volume") then
        mpd_text.text = ""
        tooltip.text = "MPD is idle."
        return
    end

	if state == "playing" then
		icon.image = beautiful.widget_music_play
	elseif state == "paused" then
		icon.image = beautiful.widget_music_pause
	else
		icon.image = beautiful.widget_music
	end

    -- Show a simple label + title
    mpd_text.markup = string.format(
        '<span font="%s %d">%s </span>',
        beautiful.font,
        10,
        title
    )

	tooltip.text = string.format("%s\nState: %s", title, state)
end

-- Timer
gears.timer {
    timeout = 2,
    autostart = true,
    call_now = true,
    callback = update,
}

return mpd_widget

