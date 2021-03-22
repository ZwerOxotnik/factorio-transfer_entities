-- Copyright (c) 2019, 2021 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the MIT licence;

local module = {}

module.destroy_gui = function(player)
    local frame = player.gui.left.transfer_entities_frame
    if not frame then return end
    frame.destroy()
end

module.create_gui = function(player)
    -- Find forces
    local forces = {}
    local is_check_online = settings.global["TE-only_online_force"].value
    local player_force = player.force
    if settings.global["TE-to_whom"].value == "ally" then
        for _, force in pairs(game.forces) do
            if not is_check_online or #force.connected_players > 0 then
                if player_force.get_friend(force) and player.force ~= force then -- Is ally?
                    table.insert(forces, force.name)
                end
            end
        end
    else
        for _, force in pairs(game.forces) do
            if (not is_check_online or #force.connected_players > 0) and player.force ~= force then
                if player_force.get_friend(force) then  -- Is ally?
                    table.insert(forces, force.name)
                elseif player_force.get_cease_fire(force) then  -- Is neutral?
                    table.insert(forces, force.name)
                end
            end
        end
    end
    if #forces == 0 then
        local message = {"transfer_entities.forces-not-found"}
        local color = {1, 1, 0}
        -- local character = player.character
        -- if character then
        --     rendering.draw_text{
        --         text = message,
        --         scale = 0.85,
        --         surface = character.surface,
        --         target = character,
        --         target_offset = {0.5, -1.5},
        --         color = {1, 1, 0},
        --         time_to_live = 230,
        --         players = {game.player},
        --         alignment = "left",
        --         scale_with_zoom = true
        --     }
        -- else
            player.print(message, color)
        -- end
        module.destroy_gui(player)
        global.transfer_entities.players[player.index].transfer_entities = nil
        return
    end

    module.destroy_gui(player)
    -- Create gui
    local left = player.gui.left
    local frame = left.add{type = 'frame', name = 'transfer_entities_frame', caption = {"mod-name.transfer_entities"}}
    local main_table = frame.add{type = 'table', name = 'main_table', column_count = 3}
    local x = main_table.add{type = 'button', name = "X", caption = 'X', tooltip = {"controls.close-gui"}}
    x.style.minimal_width = 30
    x.style.maximal_width = 30
    x.style.font = 'default'
    x.style.left_padding = 0
    x.style.top_padding = 0
    x.style.bottom_padding = 0
    x.style.right_padding = 0
    local drop_down_forces = main_table.add{type = 'drop-down', name = 'to_force', items = forces, selected_index = 1}
    drop_down_forces.style.maximal_width = 240
    local button = main_table.add{type = 'button', name = "transfer_entities", caption = '➤', tooltip = {"gui-train-rename.perform-change"}}
    button.style.maximal_height = 22
    button.style.minimal_height = 22
    button.style.minimal_width = 24
    button.style.maximal_width = 24
    button.style.font = 'default'
    button.style.left_padding = 0
    button.style.top_padding = 0
    button.style.bottom_padding = 0
    button.style.right_padding = 0
end

module.on_gui_click = function(event)
    -- Validation of data
	local gui = event.element
	if not (gui and gui.valid) then return end
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end
	local parent = gui.parent
    if not parent then return end
    if parent.name ~= "main_table" then return end

    if gui.name == "X" then
        global.transfer_entities.players[player.index].transfer_entities = nil
        module.destroy_gui(player)
    elseif gui.name == "transfer_entities" then
        local drop_down = parent.to_force
        local new_force = game.forces[drop_down.items[drop_down.selected_index]]
        if not new_force then
            local message = {"transfer_entities.forces-not-found"}
            local color = {1, 1, 0}
            -- local character = player.character
            -- if character then
            --     rendering.draw_text{
            --         text = message,
            --         scale = 0.85,
            --         surface = character.surface,
            --         target = character,
            --         target_offset = {0.5, -1.5},
            --         color = {1, 1, 0},
            --         time_to_live = 230,
            --         players = {game.player},
            --         alignment = "left",
            --         scale_with_zoom = true
            --     }
            -- else
                player.print(message, color)
            -- end
            return
        end

        -- Set new force
        local transfer_entities = global.transfer_entities.players[player.index].transfer_entities
        for _, entity in pairs(transfer_entities) do
            entity.force = new_force
        end
        transfer_entities = nil
        module.destroy_gui(player)
    end
end

-- module.on_gui_selection_state_changed = function(event)
--     -- Validation of data
-- 	local gui = event.element
-- 	if not (gui and gui.valid) then return end
-- 	local player = game.players[event.player_index]
-- 	if not (player and player.valid) then return end
-- 	local parent = gui.parent
-- 	if not parent then return end
-- 	if not (parent.name == "to_force" and parent.name == "main_table") then return end
-- end

return module
