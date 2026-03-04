local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")

-- Icon
local icon = wibox.widget.imagebox()
local icon_center = wibox.container.place(icon)

-- Text
local cpu_text = wibox.widget.textbox()

-- CPU Widget
local cpu_widget = wibox.widget {
	icon_center,
	{
		cpu_text,
		layout = wibox.container.margin,
		left = 0,
		right = 0,
		top = 2, -- adjust top margin if needed
		bottom = 0
	},
	layout = wibox.layout.fixed.horizontal,
}

-- Tooltip (we will fill text dynamically)
local tooltip = awful.tooltip {
	objects = { cpu_widget },
	mode = "outside",
	text = "CPU Info",
	fg = "#E5C07B",
	bg = "#111111",
	font = "FiraCode Nerd Font 9",
	preferred_alignments = "middle",
}

-- Internal state to compute deltas (total)
local prev_total = 0
local prev_busy = 0

-- CPU usage function (keeps original behaviour for main percentage text)
local function update_cpu()
	icon.image = beautiful.widget_cpu

    local f = io.open("/proc/stat", "r")
    if not f then
        cpu_text.text = "CPU N/A"
        return
    end

    -- read the first line (aggregate)
    local line = f:read("*l")
    if not line then
        f:close()
        cpu_text.text = "CPU ERR"
        return
    end

    local user, nice, system, idle, iowait, irq, softirq, steal =
        line:match("cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s*(%d*)")

    -- ensure numbers
    user  = tonumber(user)  or 0
    nice  = tonumber(nice)  or 0
    system= tonumber(system)or 0
    idle  = tonumber(idle)  or 0
    iowait= tonumber(iowait) or 0
    irq   = tonumber(irq)   or 0
    softirq=tonumber(softirq)or 0
    steal = tonumber(steal) or 0

    local total = user + nice + system + idle + iowait + irq + softirq + steal
    local busy  = total - idle

    local diff_total = total - (prev_total or 0)
    local diff_busy  = busy  - (prev_busy  or 0)

    local usage = 0
    if diff_total > 0 then
        usage = math.floor((diff_busy / diff_total) * 100 + 0.5)
    end

    cpu_text.markup = string.format(
        '<span font="%s %d" color="%s">%d%%</span>',
        beautiful.font or "Sans",
		10,
		beautiful.color_yellow or "#E5C07B",
        usage
    )

    prev_total = total
    prev_busy  = busy

    ----------------------------------------------------------------
    -- Tooltip Update (fixed per-core deltas + caching)
    ----------------------------------------------------------------

    -- Cache CPU model name once
    --if not tooltip._cpu_model then
    --    local cpuinfo = io.open("/proc/cpuinfo", "r")
    --    if cpuinfo then
    --        for line in cpuinfo:lines() do
    --            local model = line:match("model name%s*:%s*(.+)")
    --            if model and model ~= "" then
    --                tooltip._cpu_model = model
    --                break
    --            end
    --        end
    --        cpuinfo:close()
    --    end
    --    tooltip._cpu_model = tooltip._cpu_model or "CPU"
    --end

    -- Prepare previous per-core table
    tooltip._prev_cores = tooltip._prev_cores or {}

    -- Read all cpuN lines and compute totals for each core
    local per_core_curr = {}  -- keyed by id (string)
    -- we already read the first line; continue reading the rest
    for line in f:lines() do
        local id, u, n, s, i, iw, ir, si, st = line:match(
            "^cpu(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s*(%d*)"
        )
        if id then
            u  = tonumber(u)  or 0
            n  = tonumber(n)  or 0
            s  = tonumber(s)  or 0
            i  = tonumber(i)  or 0
            iw = tonumber(iw) or 0
            ir = tonumber(ir) or 0
            si = tonumber(si) or 0
            st = tonumber(st)  or 0

            local tot = u + n + s + i + iw + ir + si + st
            local busy_core = tot - i
            per_core_curr[id] = { total = tot, busy = busy_core }
        end
    end
    f:close()

    -- Compute per-core percentages using previous snapshot stored in tooltip._prev_cores
    local core_lines = {}
    for id, cur in pairs(per_core_curr) do
        local prev = tooltip._prev_cores[id]
        local pct = "N/A"
        if prev and (cur.total - prev.total) > 0 then
            pct = math.floor(((cur.busy - prev.busy) / (cur.total - prev.total)) * 100 + 0.5)
            if pct < 0 then pct = 0 end
            if pct > 100 then pct = 100 end
            pct = pct .. "%"
        else
            -- if no previous sample yet, show a placeholder
            pct = "?"
        end
        table.insert(core_lines, string.format("Core %s: %s", id, pct))
    end

    -- Save current per-core snapshot for next tick
    tooltip._prev_cores = {}
    for id, cur in pairs(per_core_curr) do
        tooltip._prev_cores[id] = { total = cur.total, busy = cur.busy }
    end

    -- Build tooltip text: model, total usage, per-core lines (sorted by core id)
    -- Sort core_lines by numeric id to keep order
    table.sort(core_lines, function(a,b)
        local ia = tonumber(a:match("Core%s+(%d+):"))
        local ib = tonumber(b:match("Core%s+(%d+):"))
        return (ia or 0) < (ib or 0)
    end)

    tooltip.text = string.format(
        "Total Usage: %d%%\n\n%s",
        usage,
        table.concat(core_lines, "\n")
    )
end

-- Timer to update every 2 seconds
gears.timer {
    timeout = 2,
    autostart = true,
    call_now = true,
    callback = update_cpu
}

return cpu_widget

