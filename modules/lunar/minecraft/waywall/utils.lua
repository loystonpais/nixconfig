local waywall = require("waywall")
local helpers = require("waywall.helpers")
local screen  = require("screen")

local utils   = {}


-- converts a sequential array-like list into a dictionary-style set for O(1) lookups by mapping the list values to true
---@generic T
---@param list T[]
---@return table<T, boolean>
function utils.set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

-- makes a basic copy of a table (does not copy tables inside tables)
---@generic T : table
---@param original T
---@return T
function utils.shallow_copy(original)
    local copy = {}
    for key, value in pairs(original) do
        copy[key] = value
    end
    return copy
end

-- read a file from the config directory
-- - gore's generic config
---@param name string filename
---@return string File contents
function utils.read_file(name)
    local home = os.getenv("HOME")

    local file = io.open(home .. "/.config/waywall/" .. name, "r")
    local data = file:read("*a")
    file:close()

    return data
end

-- wrapper for waywall.set_resolution to create a toggleable resolution, with extra features
-- - gore's generic config
---@param width number width
---@param height number height
---@param enable fun() function to run when enabling
---@param disable fun() function to run when disabling
---@param animate? boolean animate for https://github.com/char3210/resize_animation/blob/main/resize_animation_waywall.py
---@return fun(force: boolean): boolean
function utils.make_res(width, height, enable, disable, animate)
    return function(force)
        local active_width, active_height = waywall.active_res()

        if active_width == width and active_height == height and force ~= true then
            if animate then
                os.execute('echo "0x0" > ~/.resetti_state')
                waywall.sleep(17)
            end
            waywall.set_resolution(0, 0)
            disable()
        elseif force ~= false then
            if animate then
                os.execute(string.format('echo "%dx%d" > ~/.resetti_state', width, height))
                waywall.sleep(17)
            end
            waywall.set_resolution(width, height)
            enable()
        end
        return false
    end
end

---@class DstRectOptions: RectOptions
---@field scale number copies and multiplies src.w and src.h, requires them to be static pixel values

---@class MirrorOptions
---@field src RectOptions
---@field dst RectOptions|DstRectOptions|"src" dst = "src" copies the values of src
---@field shader? string "", "default", "none" set this to nil
---@field depth? integer
---@field multi_res? boolean set to true if src can change based on resolution
---@field color_key? {input: string, output: string} | {input: string, output: string}[] can be an array to create multiple mirrors

-- wrapper for waywall.mirror to create a toggleable mirror
---@param options MirrorOptions
---@return fun(enable: boolean|"toggle")
function utils.make_mirror(options)
    local mirrors = {}
    ---@type {[string]: {src: table, dst: table}}
    local cache = {}

    if options.dst == "src" then
        options.dst = options.src
    end

    if options.dst.scale then
        options.dst.w = options.src.w * options.dst.scale
        options.dst.h = options.src.h * options.dst.scale
    end

    if options.shader == "" or options.shader == "default" or options.shader == "none" then
        options.shader = nil
    end

    local keys
    if options.color_key then
        if options.color_key.input then
            keys = { options.color_key }
        else
            keys = options.color_key
        end
    end

    local function close()
        for _, mirror in ipairs(mirrors) do
            mirror:close()
        end
        mirrors = {}
    end

    return function(enable)
        if not enable or (enable == "toggle" and #mirrors ~= 0) then
            close()
            return
        end

        if #mirrors ~= 0 then
            if not options.multi_res then
                return
            end
            close()
        end

        local src, dst
        local res = "default"

        if options.multi_res then
            local w, h = waywall.active_res()
            res = w .. ":" .. h
        end

        local cached = cache[res]

        if not cached then
            cached = {
                src = screen.src(options.src),
                ---@diagnostic disable-next-line: param-type-mismatch
                dst = screen.dst(options.dst),
            }
            cache[res] = cached
        end
        src, dst = cached.src, cached.dst

        if keys then
            for _, key in ipairs(keys) do
                mirrors[#mirrors + 1] = waywall.mirror({
                    src = src,
                    dst = dst,
                    shader = options.shader,
                    depth = options.depth,
                    color_key = key,
                })
            end
        else
            mirrors[1] = waywall.mirror({
                src = src,
                dst = dst,
                shader = options.shader,
                depth = options.depth,
            })
        end
    end
end

-- wrapper for waywall.image to create a toggleable image
---@param options {path: string, dst: RectOptions, depth?: integer, shader?: string}
---@return fun(enable: boolean|"toggle")
function utils.make_image(options)
    local this = nil
    local applied = false
    local path = options.path

    ---@cast options {path: string, dst: {}}

    return function(enable)
        if enable == "toggle" then enable = this == nil end
        if enable and not this then
            if not applied then
                options.dst = screen.dst(options.dst)
                applied = true
            end
            this = waywall.image(path, options)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

-- wrapper for waywall.text to create toggleable text
---@param options {text: string, dst: RectOptions, depth?: integer, shader?: string, size?: number, color?: string}
---@return fun(enable: boolean|"toggle")
function utils.make_text(options)
    local this = nil
    local applied = false
    local text = options.text

    ---@cast options {text: string, dst: {}, x: number,  y: number}
    return function(enable)
        if enable == "toggle" then enable = this == nil end
        if enable and not this then
            if not applied then
                local dst = screen.text(options)
                options.x = dst.x
                options.y = dst.y
                applied = true
            end
            this = waywall.text(text, options)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

-- true if mpk is starting
utils.starting_mpk = false
-- configure mpk keybinds
-- - https://discord.com/channels/1095808506239651942/1374968058506117130/1451035479288840304
---@param cfg mpk
function utils.mpk(cfg, config)
    config.actions[cfg.launch_key] = function()
        for _, key in ipairs(cfg.launch_macro) do
            waywall.press_key(key)
        end
        utils.starting_mpk = true
    end

    config.actions[cfg.quit_key] = function()
        for _, key in ipairs(cfg.quit_macro) do
            waywall.press_key(key)
        end
    end
end

-- use pgrep to check if a process is running
---@param regex string
---@return boolean
function utils.is_running(regex)
    local handle = io.popen("pgrep -f '" .. regex .. "'")
    local result = handle:read("*l")
    handle:close()
    return result ~= nil
end

-- true if the game has state output
utils.has_state = false

-- wrapper for helpers.ingame_only to run when state output is missing
---@return boolean
function utils.is_ingame()
    if utils.has_state then
        local state = waywall.state()

        if state.screen == "inworld" and state.inworld == "unpaused" then
            return true
        else
            return false
        end
    end
    return true
end

-- wrapper for helpers.ingame_only to run when state output is missing
---@param func fun()
---@return fun()
function utils.ingame_only(func)
    return function()
        if utils.has_state then
            return helpers.ingame_only(func)()
        end
        return func()
    end
end

---@class ShadowSettings
---@field x? integer x offset (default 1)
---@field y? integer y offset (default 1)
---@field shader? string shader (default shadow)
---@field color_key? {input: string, output: string} color_key (default none)

-- create a function that creates a toggleable text mirror with an optional shadow
-- - options = mirror options & shadow shader (set shadow to {} to disable)
---@param options {src: RectOptions, dst: RectOptions|"src", multi_res?: boolean, shadow?: ShadowSettings, shader?: string, depth?: integer, color_key?: {input: string, output: string}}
---@return fun(enable: boolean)
function utils.text_mirror(options)
    options.shader = options.shader or "text"

    ---@cast options any

    local text = utils.make_mirror(options)
    local shadow

    if options.shadow ~= {} then
        if options.shadow == nil then options.shadow = {} end
        options = utils.shallow_copy(options)
        options.dst = utils.shallow_copy(options.dst)
        options.dst.h = options.dst.scale and options.src.h * options.dst.scale or options.dst.h
        options.dst.x = (options.dst.x or 0) + (options.shadow.x or 1) * (options.dst.scale or 1) or options.dst.w
        options.dst.y = (options.dst.y or 0) + (options.shadow.y or 1) * (options.dst.scale or 1) or options.dst.h
        options.dst.w = options.dst.scale and options.src.w * options.dst.scale or options.dst.w
        options.dst.h = options.dst.scale and options.src.h * options.dst.scale or options.dst.h
        options.shader = options.shadow.shader or "shadow"
        options.color_key = options.shadow.color_key

        shadow = utils.make_mirror(options)
    end

    return function(enable)
        text(enable)
        if shadow then
            shadow(enable)
        end
    end
end

---@class f3RectOptions: RectOptions
---@field gui_scale number
---@field line number

-- create a function that creates a toggleable mirror for the f3 screen
---@param options {src: f3RectOptions, dst: RectOptions|"src", multi_res?: boolean, shadow?: ShadowSettings, shader?: string, depth?: integer, color_key?: {input: string, output: string}}
---@param maker? function function to create the mirror with (defaults to utils.text_mirror)
---@return fun(enable: boolean)
function utils.f3_mirror(options, maker)
    if options.shadow ~= {} then
        if options.shadow == nil then
            options.shadow = {
                x = options.src.gui_scale,
                y = options.src.gui_scale,
            }
        end
    end
    if maker == nil then
        maker = utils.text_mirror
    end
    local src = {
        x = options.src.x * options.src.gui_scale,
        y = (1 + options.src.line * 9) * options.src.gui_scale,
        w = options.src.w * options.src.gui_scale,
        h = 9 * options.src.gui_scale,
        anchor = "topleft",
    }
    options.src = src
    if options.src.x < 0 then
        options.src.anchor = "topright"
    end
    if not options.dst then
        options.dst = {}
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    return maker(options)
end

-- create a function that creates a toggleable mirror for the f3 screen without shaders and shadows
---@param options {src: f3RectOptions, dst: RectOptions|"src", multi_res?: boolean, shader?: string, depth?: integer, color_key?: {input: string, output: string}}
---@return fun(enable: boolean)
function utils.f3_mirror_basic(options)
    return utils.f3_mirror(options, utils.make_mirror)
end

-- get the key from the action
---@param action Action|string|nil|string[]
---@param default? string
function utils.get_key(action, default)
    if not action then return default end
    if action.key == nil then
        if action[1] ~= nil then return action[1] end
        return action
    end
    return action.key
end

-- apply an action
---@param cfga table config.actions
---@param action? Action|string action configuration
---@param exec fun(...): boolean? function to run
---@param ...? any params for the function
function utils.apply_action(cfga, action, exec, ...)
    if not action then return end
    local args = { ... }
    local n = select("#", ...)
    cfga[utils.get_key(action)] = function()
        if action.f3_safe and waywall.get_key("F3") then return false end
        if action.ingame_only and utils.has_state then
            local state = waywall.state()
            if state.screen ~= "inworld" or state.inworld ~= "unpaused" then return false end
        end

        local out = exec(unpack(args, 1, n))
        if action.consume_input == nil then return out end
        return action.consume_input
    end
end

return utils
