local assdraw = require "mp.assdraw"
local options = require "mp.options"

local o = {
    font_size = 10,
    font_color = "FFFFFF",
    border_size = 1.0,
    border_color = "000000",
    alpha = "64",
}
options.read_options(o)

function get_formatting()
    return string.format(
        "{\\fs%d}{\\1c&H%s&}{\\bord%f}{\\3c&H%s&}{\\alpha&H%s&}",
        o.font_size, o.font_color,
        o.border_size, o.border_color,
	o.alpha
    )
end

function timestamp(duration)
    -- mpv may return nil before exiting.
    if not duration then return "" end
    local hours = duration / 3600
    local minutes = duration % 3600 / 60
    local seconds = duration % 60
    return string.format("%02d:%02d:%06.03f", hours, minutes, seconds)
end

function get_info()
    return string.format(
        "%sName: %s\\NTime: %s / %s",
        get_formatting(),
        mp.get_property("filename"),
        timestamp(mp.get_property_native("time-pos")),
    	timestamp(mp.get_property_native("duration"))
    )
end

function render_info()
    ass = assdraw.ass_new()
    ass:pos(2, 0)
    ass:append(get_info())
    mp.set_osd_ass(0, 0, ass.text)
end

function clear_info()
    mp.set_osd_ass(0, 0, "")
end

local osd_info = mp.add_periodic_timer(0.001, render_info)
osd_info:kill()
function toggle_info()
    if osd_info:is_enabled() then
    	clear_info()
	osd_info:kill()
    else
	osd_info:resume()
    end
end

mp.add_key_binding("TAB", mp.get_script_name(), toggle_info)
