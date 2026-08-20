local waywall = require("waywall")
local helpers = require("waywall.helpers")
local utils = require("utils")

local config_path = os.getenv("HOME") .. "/.config/waywall/"
local tools_path = os.getenv("HOME") .. "/.config/waywall/tools/"

-- paths to files
local path = {
	tools          = tools_path,
	config         = config_path,
	paceman        = tools_path .. "paceman-tracker-0.7.2.jar",
	ninjabrain_bot = tools_path .. "Ninjabrain-Bot-1.5.2.jar",
	overlay        = config_path .. "images/overlay.png",
	overlay_border = config_path .. "images/overlay_border.png",
	x_border       = config_path .. "images/x_border.png",
	y_border       = config_path .. "images/y_border.png",
	tall_border    = config_path .. "images/tall_border.png",
	pie_bg         = config_path .. "images/pie.png",
	pie_border     = config_path .. "images/pie_border.png",
	background     = config_path .. "images/background.png",
}

-- quick resolution config
local screen_width = 1920
local screen_height = 1080
local thin_w = 340
local thin_h = 1080
local wide_w = 1920
local wide_h = 340
local overlay_w = 790
local overlay_h = 350
local pie_d = 200
local border = 5

---@class options
local options = {
	path = path,
	var = {},

	window = {
		width = screen_width,
		height = screen_height,
	},

	input = {
		layout = "us",
		repeat_rate = 40,
		repeat_delay = 300,
		confine_pointer = false,
	},

	theme = {
		background_png = path.background,
	},

	experimental = {
		jit = true,
	},

	safe_guards = {
		state_output = true,
		filter = true,
		macro = true,
		safe_resolution = true,
	},

	sens = {
		_use_maccel = false,
		_normal = 1.0,
		tall = 0.29,
	},

	remapped_kb = {
		["X"] = "F3",
		["F3"] = "X",
		["L"] = "B",
		["B"] = "L",
	},
	normal_kb = {},

	res = {
		thin = {
			key = "*-G",
			ingame_only = true,
			auto_disable = true,
			f3_safe = false,
			size = { w = thin_w, h = thin_h },
		},

		wide = {
			key = "*-H",
			ingame_only = true,
			auto_disable = true,
			f3_safe = true,
			size = { w = wide_w, h = wide_h },
		},

		tall = {
			key = "*-J",
			ingame_only = false,
			auto_disable = false,
			f3_safe = false,
			defer = true,
			size = { w = "res:thin", h = 16384 },
		},
	},

	action = {
		fullscreen = { key = "*-F11" },
		toggle_ninbot = { key = "*-N" },

		chat_key1 = { "Return", "Enter" },
		chat_key2 = "Slash",

		on_launch = {
			key = "Ctrl-Shift-R",
		},

		extra = {
			launch_ninbot = {
				key = "*-O",
				exec = function(options)
					if not utils.is_running("ninjabrainbot") and not utils.is_running("Ninjabrain.*\\.jar") then
						waywall.exec("ninjabrainbot")
					end
				end,
			},

			launch_paceman = {
				key = "Shift-P",
				exec = function(options)
					if not utils.is_running("paceman.*") then
						waywall.exec("java -jar " .. options.path.paceman .. " --nogui")
					end
				end,
			},

			copy_coords = {
				key = "*-C",
				exec = function(options)
					if not waywall.get_key("F3") then return false end

					waywall.press_key("C")
					waywall.show_floating(true)

					local seconds = 5
					local show_ms = seconds * 1000
					local current_ms = waywall.current_time()
					local new_hide_ms = current_ms + show_ms

					options.var.hide_ms = math.max((options.var.hide_ms or 0), new_hide_ms)

					waywall.sleep(show_ms)
					if not waywall.floating_shown() then return end

					if options.var.hide_ms <= waywall.current_time() then
						waywall.show_floating(false)
					end
				end,
			},

			show_keybinds = {
				key = "Shift-I",
				exec = function(options)
					if not options.var.keybinds then
						local text = "KEYBINDINGS:\n\n" ..
							"fullscreen: " .. utils.get_key(options.action.fullscreen, "none") .. "\n" ..
							"toggle ninbot: " .. utils.get_key(options.action.toggle_ninbot, "none") .. "\n" ..
							"on_launch functions: " .. utils.get_key(options.action.on_launch, "none") .. "\n" ..
							"toggle remaps: " .. utils.get_key(options.action.chat_key1, "none") ..
							", " .. utils.get_key(options.action.chat_key2, "none") .. "\n" ..
							"mpk launch: " .. utils.get_key(options.mpk.launch_key, "none") .. "\n" ..
							"mpk quit: " .. utils.get_key(options.mpk.quit_key, "none") .. "\n" ..
							"\n-resolutions-\n"
						for name, res in pairs(options.res) do
							text = text .. name .. ": " .. res.key .. "\n"
						end
						for name, res in pairs(options.action.extra) do
							text = text .. name .. ": " .. res.key .. "\n"
						end
						if waywall.profile() then
							text = "active profile: " .. waywall.profile() .. "\n\n" .. text
						end
						options.var.keybinds = utils.make_text {
							text = text, dst = { anchor = "topright", x = -8, y = 8 },
							size = 1, color = "#ffffff",
						}
					end
					options.var.keybinds("toggle")
				end,
			},
		},
	},

	objects = {
		y_border = {
			enabled = utils.set { "thin" },
			utils.make_image {
				path = path.y_border,
				dst = { w = thin_w + border * 2, h = math.min(thin_h + border * 2, screen_height) },
			},
		},

		x_border = {
			enabled = utils.set { "wide" },
			utils.make_image {
				path = path.x_border,
				dst = { w = math.min(wide_w + border * 2, screen_width), h = wide_h + border * 2 },
			},
		},

		tall_border = {
			enabled = utils.set { "tall" },
			utils.make_image {
				path = path.tall_border,
				dst = { w = thin_w + border * 2, h = 1 },
			},
		},

		e = {
			enabled = utils.set { "thin", "tall" },
			utils.f3_mirror {
				src = { gui_scale = 1, line = 4, x = 1, w = 49 },
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "bottom", scale = 4 },
			},
		},

		eye_measure = {
			enabled = utils.set { "tall" },
			utils.make_mirror {
				src = { x = 0, y = 0, w = 30, h = 580 },
				dst = { pos_anchor = "left", w = overlay_w, h = overlay_h, x = (screen_width - thin_w) / 4 },
			},
			utils.make_image {
				path = path.overlay,
				dst = { pos_anchor = "left", w = overlay_w, h = overlay_h, x = (screen_width - thin_w) / 4 },
				depth = 1,
			},
			utils.make_image {
				path = path.overlay_border,
				dst = { pos_anchor = "left", w = overlay_w, h = overlay_h, x = (screen_width - thin_w) / 4 },
				depth = 2,
			},
		},

		pie_chart = {
			enabled = utils.set { "thin", "tall" },
			utils.make_mirror {
				src = { x = 0, y = -235, w = 340, h = 170, anchor = "bottomright" },
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "top", w = pie_d, h = pie_d },
				shader = "pie_chart", depth = 1, multi_res = true,
			},
			utils.make_image {
				path = path.pie_bg, depth = 0,
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "top", w = pie_d, h = pie_d },
			},
			utils.make_image {
				path = path.pie_border, depth = 2,
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "top", w = pie_d, h = pie_d },
			},
		},

		pie_percent = {
			enabled = utils.set { "thin", "tall" },
			utils.text_mirror {
				src = { x = -60, y = -188, w = 32, h = 32, anchor = "bottomright" },
				dst = { pos_anchor = { 0.75, 0.5 }, item_anchor = "left", x = pie_d / 2, y = pie_d / 2, scale = 4 },
				shader = "pie_text", shadow = { shader = "pie_text_shadow" }, multi_res = true,
			},
		},

		glowdar = {
			enabled = utils.set { "_normal" },
			utils.text_mirror {
				src = { x = -60, y = -196, w = 32, h = 24, anchor = "bottomright" },
				dst = { x = -170, y = -305, scale = 4, pos_anchor = "bottomright" },
				shader = "pie_text", shadow = { shader = "pie_text_shadow" },
			},
		},
	},

	mpk = {
		launch_key = "F9",
		launch_macro = { "Esc", "Esc", "Esc", "Tab", "Space", "Tab", "Tab", "Tab", "Space", "Tab", "Space", "Space", "Tab", "Tab", "Tab", "Tab", "Tab", "Tab", "Space" },
		quit_key = "F10",
		quit_macro = { "Esc", "Esc", "Tab", "Space", "Esc", "Tab", "Tab", "Tab", "Tab", "Tab", "Tab", "Tab", "Tab", "Space" },
		load = "1",
	},
}

return options
