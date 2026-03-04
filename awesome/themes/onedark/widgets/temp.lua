local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Icon
local icon = wibox.widget.imagebox()

-- Text
local temp_text = wibox.widget.textbox()

-- Temp Widget
local temp_widget = wibox.widget {
    icon,
    {
        temp_text,
        layout = wibox.container.margin,
        top = 2,
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = 0,
}

-- Tooltip for CPU cores + battery + fans
local temp_tooltip = awful.tooltip {
    objects = { temp_widget },
    mode = "outside",
	text = "Temperature Info",
	fg = "#61AFEF",
	bg = "#111111",
	font = "FiraCode Nerd Font 9",
	preferred_aleignments = "middle",
}

-- Function to update widget and tooltip using `sensors`
local function update_temp()
    icon.image = beautiful.widget_temp

    local lines = {}
    local first_core_temp = nil

    -- Run `sensors` and parse output
    local f = io.popen("sensors")
    if f then
        for line in f:lines() do
            -- CPU core temperatures
            local core, temp = line:match("(Core %d+):%s+%+([%d%.]+)°C")
            if core and temp then
                local t = math.floor(tonumber(temp))
                table.insert(lines, string.format("%s: %d°C", core, t))
                if not first_core_temp then
                    first_core_temp = t
                end
            end

            -- Battery temperature (adjust regex if your battery is named differently)
            local batt, btemp = line:match("(temp%d.*):%s+%+([%d%.]+)°C")
            if batt and btemp then
                table.insert(lines, string.format("Battery: %d°C", math.floor(tonumber(btemp))))
            end

            -- Fan speeds
            local fan, speed = line:match("(fan%d+):%s+(%d+)%sRPM")
            if fan and speed then
                table.insert(lines, string.format("%s: %s RPM", fan, speed))
            end
        end
        f:close()
    end

    -- Update main widget text using first CPU core
    if first_core_temp then
        temp_text.markup = string.format(
            '<span font="%s %d" color="%s">%d°C</span>',
            beautiful.font,
            10,
			beautiful.color_blue,
            first_core_temp
        )
    else
        temp_text.text = "Temp N/A"
    end

    -- Update tooltip
    temp_tooltip.text = (#lines > 0) and table.concat(lines, "\n") or "No sensor data found"
end

-- Timer: update every 20 seconds
gears.timer {
    timeout = 20,
    autostart = true,
    call_now = true,
    callback = update_temp
}

return temp_widget

