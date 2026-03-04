---------------
--- Onedark ---
---------------

-- Requires
local theme_assets = require("beautiful.theme_assets")
local dpi = require("beautiful.xresources").apply_dpi

local awful = require("awful")
local lain = require("lain")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local mytable = awful.util.table or gears.table
local theme = {}

-- Theme Directory
theme.dir = os.getenv("HOME") .. "/.config/awesome/themes/onedark"

-- Wallpaper
theme.wallpaper = theme.dir .. "/wall.png"

-- Font
theme.font = "FiraCode Nerd Font 11"

-- Tag colors ??
theme.fg_normal = "#DDDDFF"
theme.fg_focus  = "#FFFFFF"
theme.fg_urgent = "#CC9393"
theme.bg_normal = "#1A1A1A"
theme.bg_focus  = "#313131"
theme.bg_urgent = "#1A1A1A"

-- Border
theme.border_width  = dpi(0)
theme.border_normal = "#3F3F3F"
theme.border_focus  = "#7F7F7F"
theme.border_marker = "#CC9393"

-- Colors
theme.color_black   = "#282C34"
theme.color_red     = "#E06C75"
theme.color_green   = "#98C379"
theme.color_yellow  = "#E5C07B"
theme.color_blue    = "#61AFEF"
theme.color_magenta = "#C678DD"
theme.color_cyan    = "#56B6C2"
theme.color_grey    = "#ABB2BF"

-- Tasklist and Titlebar (Disabled)
theme.tasklist_bg_focus  = "#1A1A1A"
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_focus  = theme.fg_focus

-- Menu
theme.menu_height = dpi(16)
theme.menu_width  = dpi(140)

-- Taglist
theme.taglist_squares_sel   = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"

-- Layout
theme.layout_tile       = theme.dir .. "/icons/tile.png"
theme.layout_fairh      = theme.dir .. "/icons/fairh.png"
theme.layout_floating   = theme.dir .. "/icons/floating.png"

-- Widgets
theme.widget_ac            = theme.dir .. "/icons/ac.png"
theme.widget_battery       = theme.dir .. "/icons/battery.png"
theme.widget_battery_low   = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem           = theme.dir .. "/icons/mem.png"
theme.widget_cpu           = theme.dir .. "/icons/cpu.png"
theme.widget_temp          = theme.dir .. "/icons/temp.png"
theme.widget_net           = theme.dir .. "/icons/net.png"
theme.widget_hdd           = theme.dir .. "/icons/hdd.png"
theme.widget_music         = theme.dir .. "/icons/music.png"
theme.widget_music_play    = theme.dir .. "/icons/play.png"
theme.widget_music_stop    = theme.dir .. "/icons/stop.png"
theme.widget_music_pause   = theme.dir .. "/icons/pause.png"
theme.widget_vol           = theme.dir .. "/icons/vol.png"
theme.widget_vol_low       = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no        = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute      = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail          = theme.dir .. "/icons/mail.png"
theme.widget_mail_on       = theme.dir .. "/icons/mail_on.png"

-- Useless gap
theme.useless_gap = dpi(5)

-- Tasklist
theme.tasklist_disable_icon = true
theme.tasklist_disable_task_name = true

-- Widgets
local widgets = require("themes.onedark.widgets")

local clock = widgets.clock
local batt = widgets.battery
local cpu = widgets.cpu
local temp = widgets.temp
local mem = widgets.mem
local hdd = widgets.hdd
local vol = widgets.vol
local mpd = widgets.mpd

-- Separators
local spr = wibox.widget.textbox(' ')

-- Wibar
function theme.at_screen_connect(s)

	-- Quake application !LOOK UP!
	s.quake = lain.util.quake({ app = awful.util.terminal })

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(mytable.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(25), bg = theme.bg_normal, fg = theme.fg_normal, margins = { top = dpi(7), left = dpi(7), right = dpi(7), bottom = dpi(-3)} })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
		wibox.container.place(clock), -- Clock
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            keyboardlayout,
            spr,

			mpd, -- MPD

			vol, -- Volume

            spr,

			hdd, -- HDD

            spr,

			mem, -- Memory

            spr,
			
			temp, -- CPU Temp

            spr,

			cpu, -- CPU

            spr,

			batt, -- Battery

            spr,
            s.mylayoutbox,
        },
    }

end

return theme

