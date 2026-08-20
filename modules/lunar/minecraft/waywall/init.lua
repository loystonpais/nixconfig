-- ==== IMPORTS ====

local waywall = require("waywall")
local helpers = require("waywall.helpers")
local options = require("options")
local utils = require("utils")
local screen = require("screen")

-- ==== HELPERS ====

-- currently active remap
local active_remap = "default"

-- paused keymap indicator
local chat_text = utils.make_text({
    text = "keymap paused",
    dst = { pos_anchor = "bottomleft", item_anchor = "bottomleft" },
    size = 1,
    color = "ffffff7f"
})
local function chat_key(key)
    return function()
        if not utils.has_state and active_remap == "chat" then
            waywall.press_key(key)
            waywall.sleep(100)
            waywall.set_remaps(options.remapped_kb)
            active_remap = "default"
            chat_text(false)
            return false
        end
        if active_remap ~= "chat" then
            waywall.press_key(key)
            waywall.sleep(100)
            waywall.set_remaps(options.normal_kb)
            active_remap = "chat"
            chat_text(true)
            return false
        end
        return false
    end
end

local current_sens = options.sens._normal
local function res_enable(current)
    local sens = options.sens[current] ---@cast sens number
    if sens ~= current_sens then
        if sens == nil then
            sens = options.sens._normal
        end

        if options.sens._use_maccel then
            waywall.exec("maccel set param sens_mult " .. sens)
        else
            waywall.set_sensitivity(sens)
        end

        current_sens = sens
    end

    for _, o in pairs(options.objects) do
        for name, obj in pairs(o) do
            if name ~= "enabled" and name ~= "action" and o.enabled then
                if (o.enabled == true) then
                    obj(true)
                else
                    obj(o.enabled[current])
                end
            end
        end
    end
end

local function res_disable()
    res_enable("_normal")
end


local has_launched = false
local function on_launch()
    has_launched = true

    local counter = 0
    while true do
        -- print("running on_launch #" .. counter)
        local did_something = false
        for name, obj in pairs(options.action.on_launch) do
            if name ~= "key" then
                if obj(options) then
                    did_something = true
                end
            end
        end
        if did_something then
            waywall.sleep(1000)
            counter = counter + 1
            if counter > 10 then
                error("on launch function looped " .. counter .. " times!")
                break
            end
        else
            break
        end
    end
end


-- ==== CONFIG ====
local config = { actions = {} }
if options.safe_guards.filter then
    config.shaders = {
        ["pie_chart"] = {
            vertex = utils.read_file("shaders/general.vert"),
            fragment = utils.read_file("shaders/pie_chart.frag"),
        },
        ["pie_chart_modern"] = {
            vertex = utils.read_file("shaders/general.vert"),
            fragment = utils.read_file("shaders/pie_chart_modern.frag"),
        },
        ["pie_chart_modern_shadow"] = {
            vertex = utils.read_file("shaders/general.vert"),
            fragment = utils.read_file("shaders/pie_chart_modern_shadow.frag"),
        },
        ["pie_text"] = {
            vertex = utils.read_file("shaders/general.vert"),
            fragment = utils.read_file("shaders/pie_text.frag"),
        },
        ["pie_text_shadow"] = {
            vertex = utils.read_file("shaders/general.vert"),
            fragment = utils.read_file("shaders/pie_text_shadow.frag"),
        },
        ["text"] = {
            vertex = utils.read_file("shaders/general.vert"),
            fragment = utils.read_file("shaders/text.frag"),
        },
        ["shadow"] = {
            vertex = utils.read_file("shaders/general.vert"),
            fragment = utils.read_file("shaders/text_shadow.frag"),
        },
    }
end
-- allowed under proposed filter ban
config.shaders["pie_crop"] = {
    vertex = utils.read_file("shaders/general.vert"),
    fragment = utils.read_file("shaders/pie_crop.frag"),
}


-- apply default waywall options
config.input = options.input
config.input.remaps = options.remapped_kb
config.input.sensitivity = options.sens._normal
config.theme = options.theme
config.window = {
    fullscreen_width = options.window.width,
    fullscreen_height = options.window.height,
}
config.experimental = options.experimental
screen.width = options.window.width
screen.height = options.window.height


-- apply base actions
utils.apply_action(config.actions, options.action.fullscreen, waywall.toggle_fullscreen)
utils.apply_action(config.actions, options.action.on_launch, on_launch)
utils.apply_action(config.actions, options.action.toggle_ninbot, helpers.toggle_floating)

-- apply chat key action
if type(options.action.chat_key1) == "string" then
    config.actions[options.action.chat_key1] = chat_key(options.action.chat_key1)
elseif type(options.action.chat_key1) == "table" then
    config.actions[options.action.chat_key1[1]] = chat_key(options.action.chat_key1[2])
end
if type(options.action.chat_key2) == "string" then
    config.actions[options.action.chat_key2] = chat_key(options.action.chat_key2)
elseif type(options.action.chat_key2) == "table" then
    config.actions[options.action.chat_key2[1]] = chat_key(options.action.chat_key2[2])
end


-- apply extra actions
for _, extra in pairs(options.action.extra) do
    utils.apply_action(config.actions, extra.key, extra.exec, options)
end

for _, obj in pairs(options.objects) do
    if obj.action then
        utils.apply_action(config.actions, obj.action, function()
            for name, el in pairs(obj) do
                if name ~= "enabled" and name ~= "action" then
                    el("toggle", options)
                end
            end
        end)
    end
end


-- apply resolutions
screen.res = {}

---@param name string
---@param res res
local function apply_res(name, res)
    local size
    if type(res.size) == "number" then
        ---@diagnostic disable-next-line: assign-type-mismatch
        size = screen.dst({ size = res.size })
    else
        ---@diagnostic disable-next-line: param-type-mismatch
        size = screen.dst(res.size)
    end
    if options.safe_guards.safe_resolution then
        size.w = math.min(math.max(size.w, 340), 16384)
        size.h = math.min(math.max(size.h, 340), 16384)
    end

    screen.res["res:" .. name] = size

    local res_fun = utils.make_res(size.w, size.h, function() res_enable(name) end, res_disable, res.animate)
    utils.apply_action(config.actions, res, res_fun)

    if res.auto_disable and options.safe_guards.state_output then
        waywall.listen("state", function()
            local state = waywall.state()
            if state.screen ~= "inworld" or state.inworld ~= "unpaused" then
                res_fun(false)
            end
        end)
    end
end

for name, res in pairs(options.res) do
    if not res.defer then
        apply_res(name, res)
    end
end
for name, res in pairs(options.res) do
    if res.defer then
        apply_res(name, res)
    end
end


-- apply mpk
if options.safe_guards.macro then
    utils.mpk(options.mpk, config)
end

waywall.listen("load", function()
    pcall(waywall.set_resolution, 0, 0) -- minecraft window doesn't exist at this point when launching
    res_disable()
end)


waywall.listen("state", function()
    utils.has_state = options.safe_guards.state_output
    if not options.safe_guards.state_output then return end

    local state = waywall.state()
    if not has_launched then
        on_launch()
    end
    if state.screen == "inworld" and state.inworld == "unpaused" then
        waywall.set_remaps(options.remapped_kb)
        chat_text(false)
        active_remap = "default"
        if utils.starting_mpk then
            utils.starting_mpk = false
            waywall.press_key(options.mpk.load)
        end
    end
    if state.screen ~= "inworld" then
        waywall.set_remaps(options.normal_kb)
        chat_text(true)
        active_remap = "chat"
    end
end)

return config
