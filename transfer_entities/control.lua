--[[

Copyright (c) 2019 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;
Author: ZwerOxotnik
Version: 1.0.0 (2019.03.09)

Description: allows to transfer entities to other teams

You can write and receive any information on the links below.
Source: https://gitlab.com/ZwerOxotnik/transfer_entities
Mod portal: https://mods.factorio.com/mod/transfer_entities
Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=67245

]]--

local	transfer_entities_tool = require("shared").transfer_entities_tools.transfer_entities_tool
local data =
{
	players = {}
}

local gui = require("transfer_entities/gui")
local module = {}
module.version = "1.0.0"

local function init()
  global.transfer_entities = data
end

local function load()
	data = global.transfer_entities
end

local function delete_selected_entities(event)
	data.players[event.player_index].transfer_entities = nil
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end
	gui.destroy_gui(player)
end

local function check_selected_enities(event)
	-- Validation of data
	local item = event.item
	if item ~= transfer_entities_tool then return end
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end
	local entities = event.entities
	if not entities then return end

	local max_entities = settings.global["TE-max_entities"].value
	if not player.admin and #entities > max_entities then
		local message = {"transfer_entities.too-much-entities", max_entities}
		local color = {1, 1, 0}
		local character = player.character
		if character then
			rendering.draw_text{
				text = message,
				scale = 0.85,
				surface = character.surface,
				target = character,
				target_offset = {0.5, -1.5},
				color = {1, 1, 0},
				time_to_live = 230,
				players = {game.player},
				alignment = "left",
				scale_with_zoom = true
			}
		else
			player.print(message, color)
		end
		return
	end

	data.players[event.player_index].transfer_entities = {}
	local transfer_entities = data.players[event.player_index].transfer_entities
	for entity_number, entity in pairs(entities) do
		if entity.valid and entity.type ~= "player" then
			transfer_entities[entity_number] = entity
		end
	end

	if #transfer_entities == 0 then
		-- is print?
		return
	end

	gui.create_gui(player)
end

local function delete_player_data(event)
	data.players[event.player_index] = nil
end

local function on_player_created(event)
	data.players[event.player_index] = {}
end

local function on_player_joined_game(event)
	-- Validation of data
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end

	data.players[event.player_index] = {}
end

local function on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end

	local event_name = event.setting
	if event_name == "TE-only_online_force" or event_name == "TE-to_whom" then
		for player_index, player in pairs(game.connected_players) do
			data.players[player_index].transfer_entities = nil
			gui.destroy_gui(player)
		end
	end
end

module.events = {
	on_init = init,
	on_load = load,
	-- on_configuration_changed = on_configuration_changed,
	on_gui_click = gui.on_gui_click,
	-- on_gui_selection_state_changed = gui.on_gui_selection_state_changed,
	on_player_removed = delete_player_data,
	on_player_died = delete_selected_entities,
	on_player_created = on_player_created,
	on_player_joined_game = on_player_joined_game,
	on_player_left_game = delete_selected_entities,
	on_player_changed_force = delete_selected_entities,
	on_player_changed_surface = delete_selected_entities,
	on_player_selected_area = check_selected_enities,
	on_runtime_mod_setting_changed = on_runtime_mod_setting_changed
}

return module
