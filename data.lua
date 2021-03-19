-- Copyright (c) 2019-2021 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the MIT licence;

local util = require("data/util/te_util")
local tools = require("shared").transfer_entities_tools
local path = util.path("data/transfer_entities/")

local selection_mode = {"same-force", "entity-with-health"}
local transfer_entities_tool =
{
	type = "selection-tool",
	name = tools.transfer_entities_tool,
	localised_name = {"item-name." .. tools.transfer_entities_tool},
	selection_mode = selection_mode,
	alt_selection_mode = selection_mode,
	selection_cursor_box_type = "copy",
	alt_selection_cursor_box_type = "pair",
	icon = path .. "transfer_entities.png",
	icon_size = 128,
	stack_size = 1,
	flags = {},
	show_in_library = true,
	selection_color = {g = 1},
	alt_selection_color = {g = 1, b = 1},
	draw_label_for_cursor_render = true,
}
local select_units_shortcut =
{
	type = "shortcut",
	name = tools.transfer_entities_shortcut,
	order = "y",
	action = "spawn-item",
	localised_name = {"item-name." .. tools.transfer_entities_tool},
	item_to_create = tools.transfer_entities_tool,
	style = "blue",
	icon =
	{
		filename = path .. "transfer_entities_shortcut.png",
		size = 128,
		priority = "extra-high-no-scale",
		flags = {"icon"}
	}
}

data:extend{
	transfer_entities_tool,
	select_units_shortcut
}
