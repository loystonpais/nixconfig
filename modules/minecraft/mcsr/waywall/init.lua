local waywall = require("waywall")
local helpers = require("waywall.helpers")

pcall(require, "stylix")

local config = {
    input = {
        layout = "us",
        repeat_rate = 40,
        repeat_delay = 300,

        sensitivity = 1.0,
        confine_pointer = false,
    },
    theme = {
        background = stylix.colors.withHashtag.base00 or "#303030",
    },
}


local make_image = function(path, dst)
    local this = nil

    return function(enable)
        if enable and not this then
            this = waywall.image(path, { dst = dst })
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

local make_mirror = function(options)
    local this = nil

    return function(enable)
        if enable and not this then
            this = waywall.mirror(options)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

local make_res = function(width, height, enable, disable)
    return function()
        local active_width, active_height = waywall.active_res()

        if active_width == width and active_height == height then
            disable()
            waywall.sleep(17)
            waywall.set_resolution(0, 0)
        else
            enable()
            waywall.sleep(17)
            waywall.set_resolution(width, height)
        end
    end
end

-- Mirrors and resolution toggles
local mirrors = {
    eye_measure = make_mirror({
        src = { x = 130, y = 7902, w = 60, h = 580 },
        dst = { x = 0, y = 315, w = 800, h = 450 },
    }),
    tall_pie = make_mirror({
        src = { x = 0, y = 15980, w = 320, h = 260 },
        dst = { x = 480, y = 765, w = 320, h = 260 },
    }),

    f3_ccache = make_mirror({
        src       = { x = 101, y = 55, w = 27, h = 9 },
        dst       = { x = 1120, y = 504, w = 0, h = 0 },
        color_key = {
            input  = "#dddddd",
            output = "#ffffff",
        },
    }),
    f3_ecount = make_mirror({
        src       = { x = 0, y = 36, w = 50, h = 9 },
        dst       = { x = 1338, y = 144, w = 200, h = 36 },
        color_key = {
            input  = "#dddddd",
            output = "#000000",
        },
    }),

    tall_pie_entities = make_mirror({
        src       = { x = 227, y = 16163, w = 33, h = 42 },
        dst       = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#e145c2",
            output = "#323AA3",
        },
    }),
    tall_pie_blockentities = make_mirror({
        src       = { x = 227, y = 16163, w = 33, h = 42 },
        dst       = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#e96d4d",
            output = "#83046c",
        },
    }),
    tall_pie_unspec = make_mirror({
        src       = { x = 227, y = 16163, w = 33, h = 42 },
        dst       = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#45cb65",
            output = "#000000",
        },
    }),

    lowest_pie_entities = make_mirror({
        src       = { x = 227, y = 16163, w = 33, h = 42 },
        dst       = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#e145c2",
            output = "#323AA3",
        },
    }),
    lowest_pie_blockentities = make_mirror({
        src       = { x = 227, y = 16163, w = 33, h = 42 },
        dst       = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#e96d4d",
            output = "#83046c",
        },
    }),
    lowest_pie_unspec = make_mirror({
        src       = { x = 227, y = 16163, w = 33, h = 42 },
        dst       = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#45cb65",
            output = "#000000",
        },
    }),

    thin_pie_entities = make_mirror({
        src = { x = 227, y = 859, w = 33, h = 42 },
        dst = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#e145c2",
            output = "#323AA3",
        },
    }),
    thin_pie_blockentities = make_mirror({
        src = { x = 227, y = 859, w = 33, h = 42 },
        dst = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#e96d4d",
            output = "#83046c",
        },
    }),
    thin_pie_unspec = make_mirror({
        src = { x = 227, y = 859, w = 33, h = 42 },
        dst = { x = 1340, y = 200, w = 198, h = 251 },
        color_key = {
            input  = "#45cb65",
            output = "#000000",
        },
    }),
}

local images = {
    overlay = make_image(
        "/home/chloe/Desktop/overlay.png",
        { x = 0, y = 315, w = 800, h = 450 }
    )
}

local show_mirrors = function(eye, f3, tall, thin, lowest)
    -- images.overlay(eye)
    mirrors.eye_measure(eye)
    mirrors.tall_pie(eye)

    mirrors.f3_ccache(f3)
    mirrors.f3_ecount(f3)

    mirrors.tall_pie_entities(tall)
    mirrors.tall_pie_blockentities(tall)
    mirrors.tall_pie_unspec(tall)

    mirrors.thin_pie_entities(thin)
    mirrors.thin_pie_blockentities(thin)
    mirrors.thin_pie_unspec(thin)

    mirrors.lowest_pie_entities(lowest)
    mirrors.lowest_pie_blockentities(lowest)
    mirrors.lowest_pie_unspec(lowest)
end

local thin_enable = function()
    os.execute('echo "320x1000" > ~/.waywall_state')
    waywall.set_sensitivity(0)
    show_mirrors(false, true, false, true, false)
    -- waywall.show_floating = true
end

local thin_disable = function()
    os.execute('echo "1920x1080" > ~/.waywall_state')
    show_mirrors(false, false, false, false, false)
    -- waywall.show_floating = false
end

local tall_enable = function()
    os.execute('echo "320x16384" > ~/.waywall_state')
    waywall.set_sensitivity(0.29)
    show_mirrors(true, true, true, false, false)
end

local tall_disable = function()
    os.execute('echo "1920x1080" > ~/.waywall_state')
    waywall.set_sensitivity(0)
    show_mirrors(false, false, false, false, false)
end

local wide_enable = function()
    os.execute('echo "1920x300" > ~/.waywall_state')
    waywall.set_sensitivity(0)
    show_mirrors(false, false, false, false, false)
end

local wide_disable = function()
    os.execute('echo "1920x1080" > ~/.waywall_state')
end

local lowest_enable = function()
    os.execute('echo "320x16384" > ~/.waywall_state')
    waywall.set_sensitivity(0)
    show_mirrors(true, true, true, false, false)
    -- waywall.show_floating = true
end

local lowest_disable = function()
    os.execute('echo "1920x1080" > ~/.waywall_state')
    waywall.set_sensitivity(0)
    show_mirrors(false, false, false, false, false)
    -- waywall.show_floating = false
end

local semithin_enable = function()
    os.execute('echo "328x1080" > ~/.waywall_state')
    waywall.set_sensitivity(0)
    show_mirrors(false, false, false, false, false)
end

local semithin_disable = function()
    os.execute('echo "1920x1080" > ~/.waywall_state')
end

local resolutions = {
    thin     = make_res(320, 1080, thin_enable, thin_disable),
    tall     = make_res(320, 16384, tall_enable, tall_disable),
    wide     = make_res(1920, 300, wide_enable, wide_disable),
    semithin = make_res(328, 1080, semithin_enable, semithin_disable),
    lowest   = make_res(320, 16384, lowest_enable, lowest_disable),
}

config.actions = {
    ["*-O"] = function()
        waywall.exec("ninjabrainbot")
    end,

    ["*-N"] = helpers.toggle_floating,


    ["*-F11"] = waywall.toggle_fullscreen,


    ["*-G"] = resolutions.thin,
    ["*-H"] = resolutions.wide,
    ["*-J"] = resolutions.tall,

    ["Caps_lock"] = function()
        print("")
    end,

    ["*-Caps_lock"] = function()
        print("")
    end


    -- ["*-Alt-M"] = resolutions.semithin,
    -- ["*-U"]     = resolutions.lowest,
}

config.input = {
    remaps = {
        ["X"] = "F3",
        ["F3"] = "X",
        ["L"] = "B",
        ["B"] = "L"
    }
};

return config
