local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Helper to read files safely
local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*a")
    f:close()
    return content and content:gsub("%s+", "") or nil
end

-- Icon
local icon = wibox.widget.imagebox()
local icon_center = wibox.container.place(icon)
icon_center.valign = "center"

-- Text
local battery_text = wibox.widget.textbox("N/A")
local text_center = wibox.container.place(battery_text)
text_center.valign = "center"

-- Widget layout
local battery_widget = wibox.widget {
    {
        icon_center,
        layout = wibox.layout.fixed.horizontal,
        spacing = -1
    },
    {
        text_center,
        layout = wibox.container.margin,
        left = -3,
        right = 0,
        top = 4,
        bottom = 0,
        spacing = -1
    },
    layout = wibox.layout.fixed.horizontal,
    font = beautiful.font,
}

-- Tooltip
local tooltip = awful.tooltip {
	objects = { battery_widget },
	mode = "outside",
	text = "Battery Info",
	fg = "#98C379",
	bg = "#111111",
	font = "FiraCode Nerd Font 9",
	preferred_alignments = "middle",
	--opacity = 0.5,
}


-- Update function
local function update_battery()
    local charge = tonumber(read_file("/sys/class/power_supply/BAT0/capacity")) or 0
    local status = read_file("/sys/class/power_supply/BAT0/status") or "Unknown"
    local energy_now = tonumber(read_file("/sys/class/power_supply/BAT0/energy_now"))
    local power_now = tonumber(read_file("/sys/class/power_supply/BAT0/power_now"))
    local energy_full = tonumber(read_file("/sys/class/power_supply/BAT0/energy_full"))

    -- Icon
    icon.image = beautiful.widget_battery
    if status == "Charging" then
        icon.image = beautiful.widget_ac
    elseif charge < 20 then
        icon.image = beautiful.widget_battery_empty
    elseif charge < 40 then
        icon.image = beautiful.widget_battery_low
    end

    -- Text color (optional)
    battery_text.markup = string.format(
        '<span font="%s %d" color="%s">%d%%</span>',
        beautiful.font, 10, beautiful.color_green, charge
    )

    -- Tooltip text
    local t_text = status .. " " .. charge .. "%"
    if power_now and power_now > 0 and energy_now then
        local time_hours
        if status == "Discharging" then
            time_hours = energy_now / power_now
            t_text = string.format("Discharging — %.1f h left", time_hours)
        elseif status == "Charging" and energy_full then
            time_hours = (energy_full - energy_now) / power_now
            t_text = string.format("Charging — %.1f h to full", time_hours)
        end
    end

	tooltip.text = t_text
end

-- Timer to update every 30s
gears.timer {
    timeout = 30,
    autostart = true,
    call_now = true,
    callback = update_battery,
}

return battery_widget

