local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Icon
local icon = wibox.widget.imagebox()

-- Text
local disk_text = wibox.widget.textbox()

-- Layout: icon + text
local disk_widget = wibox.widget {
    icon,
    {
        disk_text,
        layout = wibox.container.margin,
        top = 2,
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = 4,
}

local tooltip = awful.tooltip {
	objects = { disk_widget },
	mode = "outside",
	text = "HDD Info",
	bg = "#111111",
	preferred_alignments = "middle",
}

-- Function to get disk usage percentage for /
local function update_disk()
	icon.image = beautiful.widget_hdd

    local f = io.open("/proc/self/mountstats", "r")
    if not f then
        disk_text.text = "HDD N/A"
        return
    end
	f:close()

    -- Look for root partition line
    local usage_percent = "N/A"
	local df = io.popen("df -h / | tail -1 | awk '{print $5}'")

	if df then
		usage_percent = df:read("*a"):gsub("%s+", "")
		df:close()
	end

	-- Full info for tooltip
	local tt_df = io.popen("df -h /")
	local tt_text = "N/A"

	if tt_df then
		tt_text = tt_df:read("*a")
		tt_df:close()
	end

	tooltip.markup = string.format(
		'<span font="%s %d" color="%s">%s</span>',
		beautiful.font,
		9,
		beautiful.color_cyan,
		tt_text
	)


    disk_text.markup = string.format(
        '<span font="%s %d" color="%s">%s</span>',
        beautiful.font,
        10,
		beautiful.color_cyan,
        usage_percent
    )
end

-- Timer: update every 30 seconds
gears.timer {
    timeout = 30,
    autostart = true,
    call_now = true,
    callback = update_disk
}

return disk_widget
