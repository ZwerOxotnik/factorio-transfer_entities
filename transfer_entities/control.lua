--[[

Copyright (c) 2019, 2021, 2024 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;
Author: ZwerOxotnik

You can write and receive any information on the links below.
Source: https://gitlab.com/ZwerOxotnik/transfer_entities
Mod portal: https://mods.factorio.com/mod/transfer_entities
Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=67245

]]--

-- TODO: remove/replace "Event listener" mod with "zk-lib" etc

local transfer_entities_tool = require("shared").transfer_entities_tools.transfer_entities_tool
local __mod_data =
{
	players = {}
}

local gui = require("transfer_entities/gui")
local M = {}
M.events = {}

M.on_init = function()
	storage.transfer_entities = __mod_data
end

M.on_load = function()
	__mod_data = storage.transfer_entities
end

function M.delete_selected_entities(event)
	local player_index = event.player_index
	if not __mod_data.players[player_index] then return end
	__mod_data.players[player_index].transfer_entities = nil
	local player = game.get_player(player_index)
	if not (player and player.valid) then return end

	gui.destroy_gui(player)
end

function M.check_selected_enities(event)
	-- Validation of data
	local item = event.item
	if item ~= transfer_entities_tool then return end
	local player_index = event.player_index
	local player = game.get_player(player_index)
	if not (player and player.valid) then return end
	local entities = event.entities
	if not entities then return end

	local max_entities = settings.global["TE-max_entities"].value
	if not player.admin and #entities > max_entities then
		local message = {"transfer_entities.too-much-entities", max_entities}
		local color = {1, 1, 0}
		-- local character = player.character
		-- if character then
		-- 	rendering.draw_text{
		-- 		text = message,
		-- 		scale = 0.85,
		-- 		surface = character.surface,
		-- 		target = character,
		-- 		target_offset = {0.5, -1.5},
		-- 		color = {1, 1, 0},
		-- 		time_to_live = 230,
		-- 		players = {game.player},
		-- 		alignment = "left",
		-- 		scale_with_zoom = true
		-- 	}
		-- else
			player.print(message, color)
		-- end
		return
	end

	__mod_data.players[player_index].transfer_entities = {}
	local transfer_entities = __mod_data.players[player_index].transfer_entities
	for entity_number, entity in pairs(entities) do
		if entity.valid and entity.type ~= "character" then
			transfer_entities[entity_number] = entity
		end
	end

	if #transfer_entities == 0 then
		-- is print?
		return
	end

	gui.create_gui(player)
end

function M.delete_player_data(event)
	__mod_data.players[event.player_index] = nil
end

function M.on_player_created(event)
	__mod_data.players[event.player_index] = {}
end

function M.on_player_joined_game(event)
	-- Validation of data
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	__mod_data.players[event.player_index] = {}
end

function M.on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end

	local event_name = event.setting
	if event_name == "TE-only_online_force" or event_name == "TE-to_whom" then
		for player_index, player in pairs(game.connected_players) do
			__mod_data.players[player_index].transfer_entities = nil
			gui.destroy_gui(player)
		end
	end
end


M.events = {
	[defines.events.on_gui_click] = gui.on_gui_click,
	[defines.events.on_player_removed] = gui.delete_player_data,
	[defines.events.on_player_joined_game] = M.on_player_joined_game,
	[defines.events.on_player_created]     = M.on_player_created,
	[defines.events.on_player_died]            = M.delete_selected_entities,
	[defines.events.on_player_left_game]       = M.delete_selected_entities,
	[defines.events.on_player_changed_force]   = M.delete_selected_entities,
	[defines.events.on_player_changed_surface] = M.delete_selected_entities,
	[defines.events.on_player_selected_area]   = M.delete_selected_entities,
	[defines.events.on_runtime_mod_setting_changed] = M.on_runtime_mod_setting_changed,
	[defines.events.on_player_selected_area] = M.check_selected_enities,
	-- [defines.events.on_configuration_changed] = M.on_configuration_changed,
	-- [defines.events.on_gui_selection_state_changed] = gui.on_gui_selection_state_changed,
}


return M
