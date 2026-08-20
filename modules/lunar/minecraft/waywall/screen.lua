--------------------------------------------------------------------------------
-- # screen layout helpers
--
-- this module provides resolution-independent layout for mirrors, images and text.
-- layouts are described declaratively using anchors, offsets and sizes,
-- then resolved into absolute pixel rectangles.
--
-- # Position
--
-- for src canvas refers to the game window, for dst the waywall window
--
-- positions are defined by two anchors:
--
--   - pos_anchor  - the reference point on the canvas
--   - item_anchor - the point on the item that is aligned to the reference
--   - anchors     - shorthand for both pos_anchor and item_anchor
--
-- both default to "middle".
--
-- preset anchors:
--
--   topleft	top		topright
--   left		middle	right
--   bottomleft	bottom	bottomright
--
-- custom anchors may also be specified using normalized coordinates:
--
--   pos_anchor = { 0.25, 0.75 }
--
-- where (0,0) is the top-left of the canvas and (1,1) is the bottom-right.
--
-- # sizes
--
-- width and height may be specified as:
--
--   - absolute pixels:
--
--       w = 340
--
--   - a normalized fraction of the canvas:
--
--       w = 0.5
--
--   - an automatic sizing function (registered with function screen.auto.{function}(canvas) ):
--
--       w = "fill_side"

--   - a size of a resolution:
--
--       w = "res:thin"
--
-- if only one dimension is provided, `size` specifies the aspect ratio
-- (width / height) and the other dimension is calculated automatically.
--
-- if neither width nor height is provided, the rectangle is scaled to fit
-- inside the canvas while preserving the aspect ratio.
--
-- # Example
--
-- pie chart
-- src = { x = 0, y = -235, w = 340, h = 170, anchor = "bottomright"}
-- dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "top", w = 200, h = 200, }
--
--------------------------------------------------------------------------------

local waywall = require("waywall")

--- named anchor positions. these correspond to normalized coordinates
--- on the canvas, where (0, 0) is the top-left and (1, 1) is the bottom-right
---@alias AnchorName
---| "topleft"
---| "top"
---| "topright"
---| "left"
---| "middle"
---| "right"
---| "bottomleft"
---| "bottom"
---| "bottomright"

--- normalized anchor coordinates in the range [0, 1].
--- {0, 0} = top-left, {0.5, 0.5} = center, {1, 1} = bottom-right
---@alias AnchorVec [number, number]

--- either a named anchor or custom normalized coordinates
---@alias Anchor AnchorName|AnchorVec

--- a drawable area used for layout calculations
---@class Canvas
---@field width integer
---@field height integer

--- a pixel size or the name of an automatic sizing function
--- - [integer] - absolute size in pixels
--- - [0-1] - size as a % of the canvas
--- - "fill_side" space between the edge of the screen and the game (horizontal)
--- - "fill_vert" space between the edge of the screen and the game (vertical)
--- - "res:{name}" width/height of the resolution
---@alias AutoSize string|number

--- layout description used to compute a final rectangle
---@class RectOptions
--- horizontal offset from the position anchor in pixels
---@field x? number
--- vertical offset from the position anchor in pixels
---@field y? number
---
---@see AutoSize
---@field w? AutoSize
---
---@see AutoSize
---@field h? AutoSize
--- width-to-height aspect ratio. used to derive the missing dimension
--- or to fit the rectangle within the canvas if neither dimension is provided
---@field size? number
--- shorthand for setting both `pos_anchor` and `item_anchor`. has priority
---@field anchor? Anchor
--- anchor position on the canvas
---@field pos_anchor? Anchor
--- anchor position within the rectangle
---@field item_anchor? Anchor

--- rectangle in pixel coordinates
---@class Rect
---@field x number
---@field y number
---@field w number
---@field h number

---@class TextOptions
---@field text string
---@field size integer
---@field dst RectOptions

---@class Screen
---@field width integer
---@field height integer
--- built-in named anchors
---@field anchors {[AnchorName]: AnchorVec}
--- automatic sizing functions referenced by name
---@field auto {[string]: fun(canvas: Canvas): number}
--- automatic sizing presets from resolutions
---@field res {[string]: { w: integer, h: integer }}
local screen = {
	width = 1920,
	height = 1080,

	anchors = {
		topleft = { 0, 0 },
		top = { 0.5, 0 },
		topright = { 1, 0 },

		left = { 0, 0.5 },
		middle = { 0.5, 0.5 },
		right = { 1, 0.5 },

		bottomleft = { 0, 1 },
		bottom = { 0.5, 1 },
		bottomright = { 1, 1 },
	},

	auto = {},
	res = {}
}

---@return Canvas
local function safe_res()
	local ok, width, height = pcall(waywall.active_res)
	if not ok or (width == 0 and height == 0) then return { width = screen.width, height = screen.height } end
	return { width = width, height = height }
end

function screen.auto.fill_side(canvas)
	return (canvas.width - safe_res().width) / 2
end

function screen.auto.fill_vert(canvas)
	return (canvas.height - safe_res().height) / 2
end

---@param v number
---@return integer
local function round(v)
	return math.floor(v + 0.5)
end

---@param a? Anchor
---@return AnchorVec
local function norm_anchor(a)
	if type(a) == "string" then
		return screen.anchors[a] or screen.anchors.middle
	end
	if type(a) == "table" then
		return a
	end
	return screen.anchors.middle
end

---@param v any
---@return boolean
local function is_num(v)
	return type(v) == "number"
end

---@param t RectOptions
---@param canvas Canvas
---@return Rect
local function apply(t, canvas)
	if t.anchor then
		t.pos_anchor = t.anchor
		t.item_anchor = t.anchor
	end
	local pos_a = norm_anchor(t.pos_anchor)
	local item_a = norm_anchor(t.item_anchor)

	local w, h = t.w, t.h
	local aspect = t.size

	if screen.auto[w] then w = screen.auto[w](canvas) end
	if screen.auto[h] then h = screen.auto[h](canvas) end
	if screen.res[w] then w = screen.res[w].w end
	if screen.res[h] then h = screen.res[h].h end
	if w ~= nil and w <= 1 then w = w * canvas.width end
	if h ~= nil and h <= 1 then h = h * canvas.height end

	-- aspect resolution
	if aspect then
		if is_num(w) and not is_num(h) then
			h = w / aspect
		elseif is_num(h) and not is_num(w) then
			w = h * aspect
		elseif not is_num(w) and not is_num(h) then
			-- contain fit to screen
			local sw, sh = canvas.width, canvas.height

			local h1 = sw / aspect
			if h1 <= sh then
				w, h = sw, h1
			else
				h = sh
				w = sh * aspect
			end
		end
	end

	---@cast w number
	---@cast h number

	local px = canvas.width * pos_a[1]
	local py = canvas.height * pos_a[2]

	px = px + (t.x or 0)
	py = py + (t.y or 0)

	local x = px - (w * item_a[1])
	local y = py - (h * item_a[2])

	return {
		x = round(x),
		y = round(y),
		w = round(w),
		h = round(h),
	}
end

---@param src RectOptions
---@return Rect
function screen.src(src)
	local t = apply(src, safe_res())
	return t
end

---@param dst RectOptions
---@return Rect
function screen.dst(dst)
	local t = apply(dst, { width = screen.width, height = screen.height })
	return t
end

---@param options TextOptions
---@return Rect
function screen.text(options)
	local maxw = 0
	for line in (options.text .. "\n"):gmatch("(.-)\n") do
		maxw = math.max(maxw, #line)
	end

	options.dst.w = 8 * maxw * options.size
	options.dst.h = 16 * (1 + select(2, options.text:gsub("\n", ""))) * options.size

	return screen.dst(options.dst)
end

return screen
