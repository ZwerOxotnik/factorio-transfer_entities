-- Copyright (c) 2019, 2021 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the MIT licence;

local util = require("data/util/te_util")
local tools = require("shared").transfer_entities_tools
local path = util.path("data/transfer_entities/")

local selection_mode = {"same-force", "entity-with-health"}
local transfer_entities_tool = {
	type = "selection-tool",
	name = tools.transfer_entities_tool,
	localised_name = {"item-name." .. tools.transfer_entities_tool},
	selection_mode = selection_mode,
	alt_selection_mode = selection_mode,
	selection_cursor_box_type = "copy",
	alt_selection_cursor_box_type = "pair",
	select = {
		border_color = {1, 1, 1},
		mode = {"blueprint"},
		cursor_box_type = "copy",
	},
	alt_select = {
		border_color = {0, 1, 0},
		mode = {"blueprint"},
		cursor_box_type = "copy",
	},
	icon = path .. "transfer_entities.png",
	icon_size = 128,
	stack_size = 1,
	flags = {"spawnable"},
	show_in_library = true,
	selection_color = {g = 1},
	alt_selection_color = {g = 1, b = 1},
	draw_label_for_cursor_render = true,
}
local select_units_shortcut = {
	type = "shortcut",
	name = tools.transfer_entities_shortcut,
	order = "y",
	action = "spawn-item",
	localised_name = {"item-name." .. tools.transfer_entities_tool},
	item_to_spawn = tools.transfer_entities_tool,
	style = "blue",
	small_icon = path .. "transfer_entities_shortcut-24x.png",
	icon       = path .. "transfer_entities_shortcut.png",
	small_icon_size = 24,
	icon_size       = 128,
}

data:extend{
	transfer_entities_tool,
	select_units_shortcut
}
