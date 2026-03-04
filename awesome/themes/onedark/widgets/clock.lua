local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Text
local clock = wibox.widget.textbox()

-- Function to update the time
local function update_time()
	local time = os.date("%H:%M %d-%m-%Y")
	clock.markup = string.format('<span font="%s %d">%s</span>', beautiful.font, 10, time)
end

-- Timer for the update
gears.timer {
	timeout = 60,
	autostart = true,
	call_now = true,
	callback = update_time
}

return clock
