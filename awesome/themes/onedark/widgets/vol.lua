local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Icon and text
local icon = wibox.widget.imagebox()
local vol_text = wibox.widget.textbox()

-- Layout
local volume_widget = wibox.widget {
    icon,
    {
        vol_text,
        layout = wibox.container.margin,
        top = 2,
    },
    layout = wibox.layout.fixed.horizontal,
}

-- Volume updater
local function update_volume()
	icon.image = beautiful.widget_vol

	-- Dump amixer output to a temp file (since /proc doesn’t expose volume)
	local tmp = "/tmp/.volume_check"
	os.execute("amixer get Master > " .. tmp .. " 2>/dev/null")

	local f = io.open(tmp, "r")
	if not f then
		vol_text.text = "N/A"
		return
	end
	local content = f:read("*a")
	f:close()

    -- Parse volume and mute
    --local vol = content:match("Volume:%s+front%-left:%s+[%d]+%s+/%s+(%d+)%%")
	local vol = content:match("(%d+)%%")
	local mute = content:match("%[(off)%]")

    vol = tonumber(vol) or 0

    local display = vol .. "%"

    if mute then
        icon.image = beautiful.widget_vol_mute
    elseif vol == 0 then
        display = "0%"
        icon.image = beautiful.widget_vol_no
    elseif vol < 35 then
        icon.image = beautiful.widget_vol_low
    else
        icon.image = beautiful.widget_vol
    end

    vol_text.markup = string.format(
        '<span font="%s %d" color="%s">%s</span>',
        beautiful.font,
        10,
		beautiful.color_green,
        display
    )
end

-- Timer
gears.timer {
    timeout = 2,
    autostart = true,
    call_now = true,
    callback = update_volume
}

return volume_widget

