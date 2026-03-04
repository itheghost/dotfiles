local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")

-- Icon
local icon = wibox.widget.imagebox()

-- Text
local mem_text = wibox.widget.textbox()

-- Memory Widget
local mem_widget = wibox.widget {
    icon,
    {
        mem_text,
        layout = wibox.container.margin,
        top = 2,
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = 4,
}

-- Tooltip
local tooltip = awful.tooltip {
    objects = { mem_widget },
    mode = "outside",
	text = "RAM Info",
	fg = "#C678DD",
	bg = "#111111",
	font = "FiraCode Nerd Font 9",
	preferred_alignments = "middle",
}

-- SINGLE FUNCTION: updates RAM widget + tooltip
local function update_ram()
    icon.image = beautiful.widget_mem

    -- Read /proc/meminfo
    local f = io.open("/proc/meminfo", "r")
    if not f then
        mem_text.text = "RAM N/A"
        tooltip.text = "Could not read meminfo."
        return
    end
    local info = f:read("*a")
    f:close()

    local mem_total = tonumber(info:match("MemTotal:%s+(%d+)"))
    local mem_available = tonumber(info:match("MemAvailable:%s+(%d+)"))

    if not mem_total or not mem_available then
        mem_text.text = "RAM ERR"
        tooltip.text = "meminfo parsing error."
        return
    end

    local mem_used_kb = mem_total - mem_available
    local mem_used_mb = math.floor(mem_used_kb / 1024)

    mem_text.markup = string.format(
        '<span font="%s %d" color="%s">%d MB</span>',
        beautiful.font,
        10,
		beautiful.color_magenta,
        mem_used_mb
    )

    -- Collect top 5 RAM-hungry processes using io.popen
    local p = io.popen(
        [[ps --no-headers -eo pid,comm,rss --sort=-rss | head -n 5]],
        "r"
    )

    local tip = ""
    if p then
        for line in p:lines() do
            local pid, comm, rss = line:match("(%d+)%s+(%S+)%s+(%d+)")
            if pid and comm and rss then
                local ram_mb = math.floor(tonumber(rss) / 1024)
                tip = tip .. string.format("%-20s %4d MB\n", comm, ram_mb)
            end
        end
        p:close()
    end

    if tip == "" then
        tip = "No process data available."
    end

    tooltip.text = tip
end

-- Timer calls the single update function
gears.timer {
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = update_ram
}

return mem_widget

