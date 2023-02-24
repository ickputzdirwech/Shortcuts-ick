--[[ Copyright (c) 2022 npc_strider, ickputzdirwech
	* Original mod by npc_strider.
	* For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
	* This mod may contain modified code sourced from base/core Factorio.
	* This mod has been modified by ickputzdirwech.
]]

--[[ Overview of control.lua:
	* Scripts for updating armor, drawing grids and managing toggles and variables.
		- Equipment functions
		- Reset equipment states
		- Startup
	* Scripts for artillery cannon fire selection tool
	* Scripts for basic shortcuts
		- Character lamp
		- Emergency locator beacon
		- Grid
		- Rail block visualisation
		- Zoom
	* Script for shortcuts that give an item
	* Scripts for vehicle shortcuts
		- Functions
		- on_player_driving_changed_state
		- on_gui_closed
	* on_lua_shortcut
		- Basic
		- Equipment
		- Vehicle
		- Give item
	* Custom inputs
		- Functions
		- Basic
		- Blueprint
		- Equipment
		- Vehicle
		- Give item
]]


require("scripts.on-player-created")
require("scripts.on-research-finished")


---------------------------------------------------------------------------------------------------
-- STARTUP
---------------------------------------------------------------------------------------------------
local function initialize()
	for name in pairs(game.forces) do
		game.forces[name].reset_technology_effects()
	end
	if global.shortcuts_light == nil then
		global.shortcuts_light = {}
	end
	if global.toggle_rail == nil then
		global.toggle_rail = {}
	end
	if global.shortcuts_armor == nil then
		global.shortcuts_armor = {}
	end
	if global.shortcuts_grid == nil then
		global.shortcuts_grid = {}
	end
	if global.shortcuts_jetpack == nil then
		global.shortcuts_jetpack = {}
	end
end

script.on_init(initialize)

local function configuration_changed()
	initialize()
	for _, player in pairs(game.players) do
		if settings.startup["ick-compatibility-mode"].value == false then
			ick_reset_available_shortcuts(player)
		end
	end
end

script.on_configuration_changed(configuration_changed)


---------------------------------------------------------------------------------------------------
-- EQUIPMENT FUNCTIONS
---------------------------------------------------------------------------------------------------
local function update_armor(player)
	local power_armor = player.get_inventory(defines.inventory.character_armor)
	if power_armor and power_armor.valid then
		if power_armor[1].valid_for_read then
			if power_armor[1].grid and power_armor[1].grid.valid and power_armor[1].grid.width > 0 then
				global.shortcuts_armor[player.index] = power_armor[1].grid
			else
				table.remove(global.shortcuts_armor, player.index)
			end
		else
			table.remove(global.shortcuts_armor, player.index)
		end
	end
end

local function update_state(event, equipment_type) -- toggles the armor
	local player = game.players[event.player_index]
	if player.character then
		update_armor(player)
		local grid = global.shortcuts_armor[event.player_index]
		if grid and grid.valid then
			for _, equipment in pairs(grid.equipment) do
				if equipment.valid and equipment.type == equipment_type then
					local name = equipment.name
					local position = equipment.position
					local energy = equipment.energy
					if not (string.sub(equipment.name, 1, 9) == "disabled-" or string.sub(equipment.name, 1, 4) == "nvt-") then
						if equipment_type ~= "active-defense-equipment" or (equipment_type == "active-defense-equipment" and game.equipment_prototypes["disabled-" .. equipment.name]) then
							grid.take{name = name, position = position}
							local new_equipment = grid.put{name = "disabled-" .. name, position = position}
							if new_equipment and new_equipment.valid then
								new_equipment.energy = energy
							end
							player.set_shortcut_toggled(equipment_type, false)
						end
					elseif (string.sub(equipment.name, 1, 9) == "disabled-") then
						grid.take{name = name, position = position}
						local new_equipment = grid.put{name = (string.sub(name, 10, #name)), position = position}
						if new_equipment and new_equipment.valid then
							new_equipment.energy = energy
						end
						player.set_shortcut_toggled(equipment_type, true)
					-- make it compatible with NightvisionToggles
					elseif (string.sub(equipment.name, 1, 4) == "nvt-") then
						grid.take{name = name, position = position}
						local new_equipment = grid.put{name = (string.sub(name, 5, #name)), position = position}
						if new_equipment and new_equipment.valid then
							new_equipment.energy = energy
						end
						player.set_shortcut_toggled(equipment_type, true)
					end
				end
			end
		end
	end
end

local function false_shortcuts(player) -- disables things
	if settings.startup["night-vision-equipment"].value then
		player.set_shortcut_available("night-vision-equipment", false)
		player.set_shortcut_toggled("night-vision-equipment", false)
	end
	if settings.startup["active-defense-equipment"].value then
		player.set_shortcut_available("active-defense-equipment", false)
		player.set_shortcut_toggled("active-defense-equipment", false)
	end
	if settings.startup["belt-immunity-equipment"].value then
		player.set_shortcut_available("belt-immunity-equipment", false)
		player.set_shortcut_toggled("belt-immunity-equipment", false)
	end
end

local function enable_it(player, equipment, grid, type) -- enables things
	if grid.valid and equipment.valid then
		local name = equipment.name
		local position = equipment.position
		local energy = equipment.energy
		player.set_shortcut_available(type, true)
		player.set_shortcut_toggled(type, true)
		if (string.sub(equipment.name, 1, 9) == "disabled-") then
			grid.take{name = name, position = position}
			local new_equipment = grid.put{name = (string.sub(name, 10, #name)), position = position}
			if new_equipment and new_equipment.valid then
				new_equipment.energy = energy
			end
		end
	end
end

---------------------------------------------------------------------------------------------------
-- RESET EQUIPMENT STATE
---------------------------------------------------------------------------------------------------
local function reset_state(event, toggle) -- verifies placement of equipment and armor switching
	local player = game.players[event.player_index]
	update_armor(player)
	local grid = global.shortcuts_armor[event.player_index]
	if grid and grid.valid then
		if settings.startup["discharge-defense-remote"].value then
			player.set_shortcut_available("discharge-defense-remote", false)
			for _, equipment in pairs(grid.equipment) do
				if equipment.name == "discharge-defense-equipment" then
					player.set_shortcut_available("discharge-defense-remote", true)
				end
			end
		end
		local equipment = event.equipment
		if equipment and toggle == 1 then --place
			local type = equipment.type
			if type == "night-vision-equipment" or type == "belt-immunity-equipment" or (type == "active-defense-equipment" and game.equipment_prototypes["disabledinactive-" .. equipment.name] == nil) then
				if settings.startup[type] and settings.startup[type].value then
					for _, equipment in pairs(grid.equipment) do	--	Enable all of a type of equipment, even if only one is placed in the grid.
						if equipment.valid and equipment.type == type then
							enable_it(player, equipment, grid, type)
						end
					end
				end
			end
		elseif equipment and toggle == 2 then --take
			local type = game.equipment_prototypes[equipment].type
			local name = game.equipment_prototypes[equipment].name
			if type == "night-vision-equipment" or type == "belt-immunity-equipment" or type == "active-defense-equipment" then
				if settings.startup[type] and settings.startup[type].value then
					local value = false
					for _, equipment in pairs(grid.equipment) do
						if equipment.type == type and equipment.valid then
							if game.equipment_prototypes["disabledinactive-" .. equipment.name] then else
								value = true
								break
							end
						end
					end
					if value == false then
						player.set_shortcut_available(type, false)
						player.set_shortcut_toggled(type, false)
					end
				end
			end
		elseif toggle == 0 then --armor place
			false_shortcuts(player)
			for _, equipment in pairs(grid.equipment) do
				local type = equipment.type
				if equipment.valid and type == "night-vision-equipment" or type == "belt-immunity-equipment" or (type == "active-defense-equipment" and game.equipment_prototypes["disabledinactive-" .. equipment.name] == nil) then
					if settings.startup[type] and settings.startup[type].value then
						enable_it(player, equipment, grid, equipment.type)
					end
				end
			end
		end
	else
		false_shortcuts(player)
		if settings.startup["discharge-defense-remote"].value then
			player.set_shortcut_available("discharge-defense-remote", false)
		end
	end
end


remote.add_interface("Shortcuts-ick", { -- Checks if the armor inventory change was caused by the jetpack mod.
	on_character_swapped = function(data)
		if data.new_character.get_inventory(defines.inventory.character_armor).is_empty() == false and data.new_character.player then
			global.shortcuts_jetpack[data.new_character.player.index] = true
		end
	end
})


script.on_event(defines.events.on_player_armor_inventory_changed, function(event)
	if global.shortcuts_jetpack[event.player_index] == nil then
		reset_state(event, 0) -- If no change by the jetpack mod was detected the equipment gets reset.
	else
		global.shortcuts_jetpack[event.player_index] = nil -- Otherwise clear the global again.
	end
end)
script.on_event(defines.events.on_player_placed_equipment, function(event)
	reset_state(event, 1)
end)
script.on_event(defines.events.on_player_removed_equipment, function(event)
	reset_state(event, 2)
end)
-- Not using on_equipment_inserted and on_equipment_removed because the changes would trigger them again.


script.on_event(defines.events.on_player_toggled_map_editor, function(event) -- make equipment shortcuts unavailable while in editor
	local player = game.players[event.player_index]
	local toggle = true
	if player.controller_type == defines.controllers.editor then
		toggle = false
	end
	if settings.startup["night-vision-equipment"].value then
		player.set_shortcut_available("night-vision-equipment", toggle)
	end
	if settings.startup["active-defense-equipment"].value then
		player.set_shortcut_available("active-defense-equipment", toggle)
	end
	if settings.startup["belt-immunity-equipment"].value then
		player.set_shortcut_available("belt-immunity-equipment", toggle)
	end
	if settings.startup["discharge-defense-remote"].value then
		player.set_shortcut_available("discharge-defense-remote", toggle)
	end
end)


---------------------------------------------------------------------------------------------------
-- TOGGLE ARTILLERY CANNON FIRE SELECTION TOOL
---------------------------------------------------------------------------------------------------
local function artillery_swap(entity, new_name)
	local shellname = {}
	local shellcount = {}
	local inventory = {}
	local manual_mode = true
	local speed = 0
	local old_equipment = false
	if entity.type == "artillery-wagon" and entity.name ~= "entity-ghost" then
		inventory = entity.get_inventory(defines.inventory.artillery_wagon_ammo)
		manual_mode = entity.train.manual_mode
		speed = entity.train.speed
		if entity.grid and entity.grid.equipment[1] then
			old_equipment = {}
			for _, equipment in pairs(entity.grid.equipment) do
				table.insert(old_equipment, {name = equipment.name, position = equipment.position, energy = equipment.energy, shield = equipment.shield})
			end
		end
	elseif entity.type == "artillery-turret" and entity.name ~= "entity-ghost" then
		inventory = entity.get_inventory(defines.inventory.artillery_turret_ammo)
	end

	for i=1,(#inventory) do
		if inventory[i].valid_for_read then
			shellname[#shellname+1] = inventory[i].name
			shellcount[#shellcount+1] = inventory[i].count
		end
	end

	local surface = entity.surface.name
	local position = entity.position
	local direction = entity.direction
	local orientation = entity.orientation
	local force = entity.force
	local kills = entity.kills
	local damage = entity.damage_dealt
	local health = entity.health
	local new_entity = {}

	if entity.name == "entity-ghost" then
		local ghost = string.sub(entity.ghost_name,10)
		if string.sub(entity.ghost_name,1,9) ~= "disabled-" then
			ghost = "disabled-"..entity.ghost_name
		end
		entity.destroy()
		new_entity = game.surfaces[surface].create_entity{
			name = "entity-ghost",
			ghost_name = ghost,
			position = position,
			direction = direction,
			orientation = orientation,
			force = force,
		}
	else
		entity.destroy()
		new_entity = game.surfaces[surface].create_entity{
			name = new_name,
			position = position,
			direction = direction,
			orientation = orientation,
			force = force,
			create_build_effect_smoke = false
		}
	end
	if new_entity and new_entity.name ~= "entity-ghost" then
		new_entity.kills = kills
		new_entity.damage_dealt = damage
		new_entity.health = health
		for i, stack in pairs(shellcount) do
			if new_entity.can_insert({name = shellname[i], count = shellcount[i]}) then
				new_entity.insert({name = shellname[i], count = shellcount[i]})
			end
		end
		if new_entity.type == "artillery-wagon" then
			new_entity.train.speed = speed
			new_entity.train.manual_mode = manual_mode
		end
		if old_equipment then
			for _, old_equipment in pairs(old_equipment) do
				local new_equipment = new_entity.grid.put{name = old_equipment.name, position = old_equipment.position}
				new_equipment.energy = old_equipment.energy
				if new_equipment.max_shield > 0 then
					new_equipment.shield = old_equipment.shield
				end
			end
		end
	elseif new_entity.name ~= "entity-ghost" then
		player.print({"", {"Shortcuts-ick.error-artillery"}, " (ERROR 1)"})
	end
	return new_entity
end

local artillery_setting = settings.startup["artillery-toggle"].value
if artillery_setting == "both" or artillery_setting == "artillery-turret" or artillery_setting == "artillery-wagon" then

	local entity_type_filter = {}

	if artillery_setting == "both" then
		entity_type_filter = {{filter="type", type = "artillery-turret"}, {filter="type", type = "artillery-wagon"}}
	else
		entity_type_filter = {{filter="type", type = artillery_setting}}
	end

	local function draw_warning_icon(entity)
		rendering.draw_sprite{
			sprite = "utility.warning_icon",
			x_scale = 1, y_scale = 1,
			target_offset = {0.0,-0.25},
			render_layer = "entity-info-icon-above",
			target = entity,
			surface = entity.surface,
			forces = {entity.force}
		}
	end

	script.on_event(defines.events.on_player_selected_area, function(event)
		if event.item == "artillery-jammer-tool" and event.entities ~= nil then
			local i = 0
			local j = 0
			for _, entity in pairs(event.entities) do
				local name = entity.name
				local type = entity.type
				if entity.valid then
					if string.sub(name,1,9) == "disabled-" or (name == "entity-ghost" and string.sub(entity.ghost_name, 1, 9) == "disabled-") then
						j = j+1
						artillery_swap(entity, string.sub(name, 10, #name))
					else
						local new_name = "disabled-" .. name
						if game.entity_prototypes[new_name] or (name == "entity-ghost" and game.entity_prototypes["disabled-"..entity.ghost_name]) then
							i = i+1
							draw_warning_icon(artillery_swap(entity, new_name))
						else
							player.print({"", {"Shortcuts-ick.error-artillery"}, " (ERROR 2)"})
						end
					end
				end
			end
			if game.is_multiplayer() then
				local player = game.players[event.player_index]
				local message = ("Player " .. player.name .. " on surface " .. player.surface.name .. " has ")
				if i ~= 0 and j == 0 then
					player.force.print(message .. "disabled " .. i .. " artillery")
				elseif i == 0 and j ~= 0 then
					player.force.print(message .. "enabled " .. j .. " artillery")
				elseif i ~= 0 and j ~= 0 then
					player.force.print(message .. "enabled " .. j .. " and disabled " .. i .. " artillery")
				end
			end
		end
	end)

	--[[
	script.on_event(defines.events.on_player_reverse_selected_area, function(event)
		-- enable selected artillery
		-- replace above
	end)

	script.on_event(defines.events.on_player_reverse_selected_area, function(event)
		-- disable selected artillery
	end)

	script.on_event(defines.events.on_player_alt_selected_area, function(event)
		-- enable not selected artillery on that surface
	end)

	script.on_event(defines.events.on_player_alt_reverse_selected_area, function(event)
		-- disable not selected artillery on that surface
		-- this event doen't exist
	end)
	]]

	script.on_event(defines.events.on_robot_built_entity, function(event)
		local entity = event.created_entity
		if string.sub(entity.name, 1, 9) == "disabled-" then
			draw_warning_icon(entity)
		end
	end, entity_type_filter)

	script.on_event(defines.events.on_built_entity, function(event)
		local entity = event.created_entity
		if string.sub(entity.ghost_name, 1, 9) == "disabled-" then
			draw_warning_icon(entity)
		end
	end, {{filter="ghost"}})
end

---------------------------------------------------------------------------------------------------
-- PREPARE UNINSTAL
---------------------------------------------------------------------------------------------------
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	local mode = settings.global["ick-prepare-uninstall"].value
	if event.setting_type == "runtime-global" and event.setting == "ick-prepare-uninstall" and mode ~= "" then
		local function enable_artillery()
			for surface_name in pairs(game.surfaces) do
				local surface = game.surfaces[surface_name]
				local artillery = surface.find_entities_filtered{type= {"artillery-turret", "artillery-wagon"}}
				local artillery_ghosts = surface.find_entities_filtered{ghost_type= {"artillery-turret", "artillery-wagon"}}
				local count = 0
				for _, array in pairs({artillery, artillery_ghosts}) do
					for _, entity in ipairs(array) do
						if entity.valid then
							local name = entity.name
							if string.sub(name, 1, 9) == "disabled-" or (name == "entity-ghost" and string.sub(entity.ghost_name, 1, 9) == "disabled-") then
								artillery_swap(entity, string.sub(name, 10, #name))
								count = count + 1
							end
						end
					end
				end
				if count > 0 then
					game.print("SURFACE: " .. surface_name .. "\nNumber of artillery turrets and waggons (including ghosts) enabled: " .. count)
				end
			end
		end
		
		local function enable_equipment(equipment_name)
			for _, player in pairs(game.players) do
				local armor = player.get_inventory(defines.inventory.character_armor)
				if armor and armor.valid and armor[1].valid_for_read then
					local grid = armor[1].grid
					if grid and grid.valid and grid.get_contents() then
						local count = 0
						for _, equipment in pairs(grid.equipment) do
							if equipment.name == "disabled-" .. equipment_name then
								local position = equipment.position
								grid.take{name = equipment.name, position = position}
								local new_equipment = grid.put{name = equipment_name, position = position}
								if global.shortcuts_armor[i] and global.shortcuts_armor[i].get(position) then
									new_equipment.energy = global.shortcuts_armor[i].get(position).energy
									global.shortcuts_armor[i] = grid
								end
								count = count + 1
							end
						end
						if count > 0 then
							game.print("PLAYER: " .. player.name .. "\nNumber of equipment pieces enabled: " .. count)
						end
					end
				end
			end
		end

		local function enable_recipe(recipe, tech)
			if game.recipe_prototypes[recipe] and game.technology_prototypes[tech] then
				for _, force in pairs(game.forces) do
					if force.technologies[tech].researched then
						force.recipes[recipe].enabled = true
						game.print("FORCE: " .. force.name .."\nEnabled Recipe: " .. game.recipe_prototypes[recipe].name)
					end
				end
			end
		end

		if mode == "uninstall" then
			enable_artillery()
			for _, equipment_name in pairs({"active-defense-equipment", "belt-immunity-equipment", "night-vision-equipment"}) do
				enable_equipment(equipment_name)
			end
			enable_recipe("artillery-targeting-remote", "artillery")
			enable_recipe("discharge-defense-remote", "discharge-defense-equipment")
			enable_recipe("spidertron-remote", "spidertron")
			enable_recipe("artillery-cluster-remote-artillery-shell", "artillery")
			enable_recipe("artillery-discovery-remote", "artillery")
			enable_recipe("mirv-targeting-remote", "mirv-technology")
			enable_recipe("atomic-artillery-targeting-remote", "atomic-artillery")
			enable_recipe("landmine-thrower-remote", "landmine-thrower")
			enable_recipe("winch", "vehicle-wagons")
			enable_recipe("ion-cannon-targeter", "orbital-ion-cannon")
			game.print("\nREADY TO UNINSTALL")
		elseif mode == "artillery" then
			enable_artillery()
			game.print({"", "READY TO DISABLE SETTING: ", {"Shortcuts-ick.artillery-toggle"}})
		elseif mode == "active-defense-equipment" or mode == "belt-immunity-equipment" or mode == "night-vision-equipment" then
			enable_equipment(mode)
		else
			game.print("There went something wrong. Please make sure you entered the right word. (ERROR X)")
		end
		settings.global["ick-prepare-uninstall"] = {value = ""}
	end
end)


---------------------------------------------------------------------------------------------------
-- BASIC
---------------------------------------------------------------------------------------------------
-- CHARACTER LAMP
local function toggle_light(player)
	if player.character then
		if global.shortcuts_light[player.index] == nil then
			global.shortcuts_light[player.index] = true
		end
		if global.shortcuts_light[player.index] then
			player.character.disable_flashlight()
			global.shortcuts_light[player.index] = false
			player.set_shortcut_toggled("flashlight-toggle", false)
		elseif global.shortcuts_light[player.index] == false then
			player.character.enable_flashlight()
			global.shortcuts_light[player.index] = true
			player.set_shortcut_toggled("flashlight-toggle", true)
		end
	else
		player.print({"", {"error.error-message-box-title"}, ": ", {"player-doesnt-exist", {"gui.character"}}, " (", {"controller.god"}, "): ", {"entity-name.small-lamp"}, " ", {"gui-mod-info.status-disabled"}})
	end
end

-- EMERGENCY LOCATOR BEACON
local function signal_flare(player)
	if settings.global["disable-flare"].value then
		player.force.print({"", "[img=utility.danger_icon] [color=1,0.1,0.1]", {"entity-name.character"}, " " ..  player.name .. " [gps=" .. math.floor(player.position.x+0.5) .. "," .. math.floor(player.position.y+0.5) ..  "][/color] [img=utility.danger_icon]"})
	else
		player.print({"", {"error.error-message-box-title"}, ": ", {"technology-name.military"}, " ", {"entity-name.beacon"}, " ", {"gui-mod-info.status-disabled"}})
	end
end

-- GRID
local function draw_grid(player_index)
	local player = game.players[player_index]
	if global.shortcuts_grid[player_index] == nil then
		global.shortcuts_grid[player_index] = {}
	end
	-- game.print(#global.shortcuts_grid[player_index])
	if #global.shortcuts_grid[player_index] == 0 then
		player.set_shortcut_toggled("draw-grid", true)
		-- Opts
		local settings = settings.get_player_settings(player)
		local radius = settings["grid-radius"].value
		local chunk_size = settings["grid-chunk-size"].value
		local step = settings["grid-step"].value
		local thinn_width = settings["grid-line-width"].value
		local thicc_width = settings["grid-chunk-line-width"].value

		local ground_grid = false
		if settings["grid-ground"].value == "ground" then
			ground_grid = true
		end

		local center_x = math.floor(player.position.x)
		local center_y = math.floor(player.position.y)
		if settings["grid-chunk-align"].value == "chunk" then
			center_x = math.floor(player.position.x/chunk_size)*chunk_size
			center_y = math.floor(player.position.y/chunk_size)*chunk_size
		end
		for i = -radius, radius, step do
			local width = thinn_width
			if i % chunk_size == 0 then
				width = thicc_width
			end
			if width > 0 then
				local line = rendering.draw_line{
					color = {r = 0, g = 0, b = 0, a = 1},
					width = width,
					from = {center_x+i,center_y+radius},
					to = {center_x+i,center_y-radius},
					surface = player.surface,
					players = {player},
					draw_on_ground = ground_grid
				}
				global.shortcuts_grid[player_index][#global.shortcuts_grid[player_index]+1] = line
			end

			local width = thinn_width
			if i % chunk_size == 0 then
				width = thicc_width
			end
			if width > 0 then
				local line = rendering.draw_line{
					color = {r = 0, g = 0, b = 0, a = 1},
					width = width,
					from = {center_x+radius,center_y+i},
					to = {center_x-radius,center_y+i},
					surface = player.surface,
					players = {player},
					draw_on_ground = ground_grid
				}
				global.shortcuts_grid[player_index][#global.shortcuts_grid[player_index]+1] = line
			end
		end
	else
		player.set_shortcut_toggled("draw-grid", false)
		local grid = global.shortcuts_grid[player_index]
		for i=1,(#grid) do
			rendering.destroy(grid[i])
			grid[i] = nil
		end
	end
end

-- RAIL BLOCK VISUALISATION
local function toggle_rail(player)
	if global.toggle_rail[player.index] == nil then
		global.toggle_rail[player.index] = false
	end
	if global.toggle_rail[player.index] then
		player.game_view_settings.show_rail_block_visualisation = false
		global.toggle_rail[player.index] = false
		player.set_shortcut_toggled("rail-block-visualization-toggle", false)
	elseif global.toggle_rail[player.index] == false then
		player.game_view_settings.show_rail_block_visualisation = true
		global.toggle_rail[player.index] = true
		player.set_shortcut_toggled("rail-block-visualization-toggle", true)
	end
end

-- BIG ZOOM
local function big_zoom(player)
	if settings.global["disable-zoom"].value then
		player.zoom = settings.get_player_settings(player)["zoom-level"].value
	else
		player.print({"", {"error.error-message-box-title"}, ": ", {"controls.alt-zoom-out"}, " ", {"gui-mod-info.status-disabled"}})
	end
end

-- MINIMAP
local function toggle_minimap(player)
	if player.minimap_enabled then
		player.minimap_enabled = false
		player.set_shortcut_toggled("minimap", false)
	else
		player.minimap_enabled = true
		player.set_shortcut_toggled("minimap", true)
	end
end


---------------------------------------------------------------------------------------------------
-- GIVE ITEM
---------------------------------------------------------------------------------------------------
local allowed_items = {
	"artillery-cluster-remote-artillery-shell",
	"artillery-discovery-remote",
	"artillery-jammer-tool",
	"artillery-targeting-remote",
	"artillery-bombardment-remote",
	"smart-artillery-bombardment-remote",
	"smart-artillery-exploration-remote",
	"atomic-artillery-targeting-remote",
	"discharge-defense-remote",
	"ion-cannon-targeter",
	"landmine-thrower-remote",
	"mirv-targeting-remote",
	"path-remote-control",
	"unit-remote-control",
	"spidertron-remote",
	"squad-spidertron-remote",
	"tree-killer",
	"well-planner",
	"winch"}

local function remove_duplicate_tools(player, prototype_name)
	for i=1, #player.get_main_inventory() do
		if player.get_main_inventory()[i].valid_for_read and player.get_main_inventory()[i].name == prototype_name then
			player.get_main_inventory()[i].clear()
		end
	end
end


local function tree_killer_setup(player)
	local settings = settings.get_player_settings(player)
	local entity_types = {}
	if settings["environment-killer-item"].value then
		table.insert(entity_types, "item-entity")
	end
	if settings["environment-killer-cliff"].value then
		table.insert(entity_types, "cliff")
	end
	if settings["environment-killer-fish"].value then
		table.insert(entity_types, "fish")
	end
	if settings["environment-killer-rocks"].value then
		table.insert(entity_types, "simple-entity")
	end
	if settings["environment-killer-trees"].value then
		table.insert(entity_types, "tree")
	end
	if #entity_types == 2 and (entity_types[1] == "tree" or entity_types[2] == "tree") and (entity_types[1] == "simple-entity" or entity_types[2] == "simple-entity") then
		player.cursor_stack.trees_and_rocks_only = true
	else
		local filters = {}
		for _, type in pairs(entity_types) do
			for _, entity in pairs(game.get_filtered_entity_prototypes({{filter = "type", type = type}})) do
				if entity.has_flag("not-deconstructable") == false and (type == "cliff" or entity.mineable_properties.minable) then
					if #filters < 255 then
						if type == "simple-entity" then
							if game.entity_prototypes[entity.name].count_as_rock_for_filtered_deconstruction then
								table.insert(filters, entity.name)
							end
						else
							table.insert(filters, entity.name)
						end
					else
						player.print({"", {"Shortcuts-ick.error-environment", type}, " (ERROR 3)"})
						break
					end
				end
			end
		end
		player.cursor_stack.entity_filters = filters
	end
end


local function give_shortcut_item(player, prototype_name)
	if game.item_prototypes[prototype_name] and player.clear_cursor() then
		player.cursor_stack.set_stack({name = prototype_name})
		if prototype_name == "well-planner" then
			remove_duplicate_tools(player, "well-planner")
		elseif prototype_name == "rail-signal-planner" then
			remove_duplicate_tools(player, "rail-signal-planner")
		elseif prototype_name == "spidertron-remote" then
			if settings.startup["spidertron-remote"].value == "enabled" then
				for i=1, #player.get_main_inventory() do
					if player.get_main_inventory()[i].valid_for_read and player.get_main_inventory()[i].name == "spidertron-remote" and player.get_main_inventory()[i].connected_entity == nil then
						player.get_main_inventory()[i].clear()
					end
				end
			end
		elseif prototype_name == "tree-killer" then
			tree_killer_setup(player)
		end
	end
end


-- CLEAR DUPLICATE SPIDERTRON REMOTES
if settings.startup["spidertron-remote"].value == "enabled" then
	script.on_event(defines.events.on_player_configured_spider_remote, function(event)
		local player = game.players[event.player_index]
		local inventory = player.get_main_inventory()
		for i=1, #inventory do
			if inventory[i].valid_for_read and inventory[i].name == "spidertron-remote" and (inventory[i].connected_entity == event.vehicle or inventory[i].connected_entity == nil) then
				inventory[i].clear()
			end
		end
	end)
end


---------------------------------------------------------------------------------------------------
-- VEHICLE UPDATES
---------------------------------------------------------------------------------------------------
-- FUNCTIONS
local spidertron_setting = settings.startup["spidertron-remote"].value

local function update_shortcuts(driver, vehicle_setting, prototype_name)
	if driver.is_player() then --If driver is a player without character
		driver.set_shortcut_available(prototype_name, true)
		driver.set_shortcut_toggled(prototype_name, vehicle_setting)
	elseif driver.player then --If driver is a character with player
		driver.player.set_shortcut_available(prototype_name, true)
		driver.player.set_shortcut_toggled(prototype_name, vehicle_setting)
	end
end

local function vehicle_shortcuts(player, name, vehicle_types, parameter)
	if player.driving then
		local continue = false
		for _, type in pairs(vehicle_types) do
			if player.vehicle.type == type then
				continue = true
				break
			end
		end
		if continue then
			local vehicle = player.vehicle
			if parameter == "auto_target_with_gunner" then
				local params = player.vehicle.vehicle_automatic_targeting_parameters
				if player.vehicle.vehicle_automatic_targeting_parameters.auto_target_with_gunner then
					params.auto_target_with_gunner = false
					player.vehicle.vehicle_automatic_targeting_parameters = params
				else
					params.auto_target_with_gunner = true
					player.vehicle.vehicle_automatic_targeting_parameters = params
				end
				vehicle = player.vehicle.vehicle_automatic_targeting_parameters
			else
				if parameter == "manual_mode" then
					vehicle = player.vehicle.train
				end
				if vehicle[parameter] then
					vehicle[parameter] = false
				else
					vehicle[parameter] = true
				end
			end
			if parameter == "manual_mode" then
				for _, driver in pairs(vehicle.passengers) do
					update_shortcuts(driver, vehicle[parameter], name)
				end
			else
				for _, driver in pairs({player.vehicle.get_driver(), player.vehicle.get_passenger()}) do
					update_shortcuts(driver, vehicle[parameter], name)
				end
			end
		end
	end
end


-- ON_PLAYER_DRIVING_CHANGED_STATE
script.on_event(defines.events.on_player_driving_changed_state, function(event)
	local player = game.players[event.player_index]
	local mods = game.active_mods
	local setting = settings.startup

	if player.driving then
		local type = player.vehicle.type
		local function enable_shortcuts(player, parameter, name)
			if setting[name].value then
				update_shortcuts(player, parameter, name)
			end
		end
		if type == "car" or type == "spider-vehicle" then
			enable_shortcuts(player, player.vehicle.driver_is_gunner, "driver-is-gunner")
		end
		if type == "spider-vehicle" then
			if spidertron_setting == "enabled" or spidertron_setting == "enabled-hidden" then
				player.set_shortcut_available("spidertron-remote", true)
			end
			if mods["Spider_Control"] then
				player.set_shortcut_available("squad-spidertron-follow", true)
				player.set_shortcut_available("squad-spidertron-remote", true)
				player.set_shortcut_available("squad-spidertron-list", true)
				player.set_shortcut_available("squad-spidertron-link-tool", true)
			end
			if mods["SpidertronWaypoints"] then
				player.set_shortcut_available("spidertron-remote-waypoint", true)
				player.set_shortcut_available("spidertron-remote-patrol", true)
			end
			enable_shortcuts(player, player.vehicle.enable_logistics_while_moving, "spidertron-logistics")
			enable_shortcuts(player, player.vehicle.vehicle_logistic_requests_enabled, "spidertron-logistic-requests")
			enable_shortcuts(player, player.vehicle.vehicle_automatic_targeting_parameters.auto_target_with_gunner, "targeting-with-gunner")
			enable_shortcuts(player, player.vehicle.vehicle_automatic_targeting_parameters.auto_target_with_gunner, "targeting-without-gunner")
		end
		if type == "locomotive" or type == "cargo-wagon"  or type == "fluid-wagon" or type == "artillery-wagon" then
			enable_shortcuts(player, player.vehicle.train.manual_mode, "train-mode-toggle")
		end
	elseif player.driving == false then
		local function disable_shortcuts(name)
			if setting[name].value then
				player.set_shortcut_available(name, false)
			end
		end
		disable_shortcuts("driver-is-gunner")
		disable_shortcuts("spidertron-logistics")
		disable_shortcuts("spidertron-logistic-requests")
		disable_shortcuts("targeting-with-gunner")
		disable_shortcuts("targeting-without-gunner")
		disable_shortcuts("train-mode-toggle")
	end
end)


-- ON_GUI_CLOSED
script.on_event(defines.events.on_gui_closed, function(event)
	if event.gui_type == 1 then
		local entity = event.entity
		local type = entity.type
		local setting = settings.startup
		local function search_vehicle(name, parameter)
			if setting[name].value then
				for _, driver in pairs({entity.get_driver(), entity.get_passenger()}) do
					update_shortcuts(driver, parameter, name)
				end
			end
		end
		if type == "car" or type == "spider-vehicle" then
			search_vehicle("driver-is-gunner", entity.driver_is_gunner)
		end
		if type == "spider-vehicle" then
			search_vehicle("spidertron-logistics", entity.enable_logistics_while_moving)
			search_vehicle("spidertron-logistic-requests", entity.vehicle_logistic_requests_enabled)
			search_vehicle("targeting-with-gunner", entity.vehicle_automatic_targeting_parameters.auto_target_with_gunner)
			search_vehicle("targeting-without-gunner", entity.vehicle_automatic_targeting_parameters.auto_target_without_gunner)
		end
		if setting["train-mode-toggle"].value and type == "locomotive" and entity.train.passengers then
			for _, driver in pairs(entity.train.passengers) do
				update_shortcuts(driver, entity.train.manual_mode, "train-mode-toggle")
			end
		end
	end
end)


---------------------------------------------------------------------------------------------------
-- ON LUA SHORTCUT
---------------------------------------------------------------------------------------------------
script.on_event(defines.events.on_lua_shortcut, function(event)
	local prototype_name = event.prototype_name
	local player = game.players[event.player_index]

	-- BASIC
	if prototype_name == "flashlight-toggle" then
		toggle_light(player)
	elseif prototype_name == "signal-flare" then
		signal_flare(player)
	elseif prototype_name == "draw-grid" then
		draw_grid(event.player_index)
	elseif prototype_name == "rail-block-visualization-toggle" then
		toggle_rail(player)
	elseif prototype_name == "big-zoom" then
		big_zoom(player)
	elseif prototype_name == "minimap" then
		toggle_minimap(player)

	-- EQUIPMENT
	elseif prototype_name == "night-vision-equipment" then
		update_state(event, "night-vision-equipment")
		return
	elseif prototype_name == "belt-immunity-equipment" then
		update_state(event, "belt-immunity-equipment")
		return
	elseif prototype_name == "active-defense-equipment" then
		update_state(event, "active-defense-equipment")
		return
	-- elseif prototype_name == "jetpack" then

	-- VEHICLE
	elseif prototype_name == "driver-is-gunner" then
		vehicle_shortcuts(player, "driver-is-gunner", {"car", "spider-vehicle"}, "driver_is_gunner")
	elseif prototype_name == "spidertron-logistics" then
		vehicle_shortcuts(player, "spidertron-logistics", {"spider-vehicle"}, "enable_logistics_while_moving")
	elseif prototype_name == "spidertron-logistic-requests" then
		vehicle_shortcuts(player, "spidertron-logistic-requests", {"spider-vehicle"}, "vehicle_logistic_requests_enabled")
	elseif prototype_name == "targeting-with-gunner" then
		vehicle_shortcuts(player, "targeting-with-gunner", {"spider-vehicle"}, "auto_target_with_gunner")
	elseif prototype_name == "targeting-without-gunner" then
		vehicle_shortcuts(player, "targeting-without-gunner", {"spider-vehicle"}, "auto_target_without_gunner")
	elseif prototype_name == "train-mode-toggle" then
		vehicle_shortcuts(player, "train-mode-toggle", {"locomotive", "cargo-wagon", "fluid-wagon", "artillery-wagon"}, "manual_mode")

	-- GIVE ITEM
	elseif prototype_name == "check-circuit" then
		give_shortcut_item(player, "circuit-checker")
	elseif prototype_name == "pump-shortcut" then
		give_shortcut_item(player, "pump-selection-tool")
	elseif prototype_name == "give-rail-signal-planner" then
		give_shortcut_item(player, "rail-signal-planner")
	elseif game.shortcut_prototypes[prototype_name] then
		for _, item_name in pairs(allowed_items) do
			if item_name == prototype_name then
				give_shortcut_item(player, prototype_name)
			end
		end
	end
end)


---------------------------------------------------------------------------------------------------
-- CUSTOM INPUTS
---------------------------------------------------------------------------------------------------
-- FUNCTIONS
local function custom_input_equipment(name)
	if settings.startup[name].value then
		script.on_event(name, function(event)
			update_state(event, name)
			return
		end)
	end
end

local function custom_input_vehicle(name, vehicle_types, parameter)
	if settings.startup[name].value then
		script.on_event(name, function(event)
			vehicle_shortcuts(game.players[event.player_index], name, vehicle_types, parameter)
		end)
	end
end

local function custom_input_give_item_2(item)
	script.on_event(item, function(event)
		local player = game.players[event.player_index]
		if player.is_shortcut_available(item) then
			give_shortcut_item(player, item)
		end
	end)
end

local function custom_input_give_item_1(item)
	if settings.startup[item] and settings.startup[item].value then
		custom_input_give_item_2(item)
	end
end


-- BASIC
if settings.startup["flashlight-toggle"].value then
	script.on_event("flashlight-toggle", function(event)
	  toggle_light(game.players[event.player_index])
	end)
end
if settings.startup["signal-flare"].value then
	script.on_event("signal-flare", function(event)
	  signal_flare(game.players[event.player_index])
	end)
end
if settings.startup["draw-grid"].value then
	script.on_event("draw-grid", function(event)
		draw_grid(event.player_index)
	end)
end
if settings.startup["rail-block-visualization-toggle"].value then
	script.on_event("rail-block-visualization-toggle", function(event)
		local player = game.players[event.player_index]
		if player.is_shortcut_available("rail-block-visualization-toggle") then
	  	toggle_rail(player)
		end
	end)
end
if settings.startup["big-zoom"].value then
	script.on_event("big-zoom", function(event)
	  big_zoom(game.players[event.player_index])
	end)
end
if settings.startup["minimap"].value then
	script.on_event("minimap", function(event)
	  toggle_minimap(game.players[event.player_index])
	end)
end


-- EQUIPMENT
custom_input_equipment("belt-immunity-equipment")
custom_input_equipment("night-vision-equipment")
custom_input_equipment("active-defense-equipment")


-- VEHICLE
custom_input_vehicle("driver-is-gunner", {"car", "spider-vehicle"}, "driver_is_gunner")
custom_input_vehicle("spidertron-logistics", {"spider-vehicle"}, "enable_logistics_while_moving")
custom_input_vehicle("spidertron-logistic-requests", {"spider-vehicle"}, "vehicle_logistic_requests_enabled")
custom_input_vehicle("targeting-with-gunner", {"spider-vehicle"}, "auto_target_with_gunner")
custom_input_vehicle("targeting-without-gunner", {"spider-vehicle"}, "auto_target_without_gunner")
custom_input_vehicle("train-mode-toggle", {"locomotive", "cargo-wagon", "fluid-wagon", "artillery-wagon"}, "manual_mode")


-- GIVE ITEM
custom_input_give_item_1("tree-killer")

if settings.startup["artillery-targeting-remote"].value then
	if settings.startup["advanced-artillery-remote"] and settings.startup["advanced-artillery-remote"].value then
		custom_input_give_item_2("artillery-cluster-remote-artillery-shell")
		custom_input_give_item_2("artillery-discovery-remote")
	end
	if settings.startup["artillery-bombardment-remote"] and settings.startup["artillery-bombardment-remote"].value then
		custom_input_give_item_2("artillery-bombardment-remote")
		custom_input_give_item_2("smart-artillery-bombardment-remote")
		custom_input_give_item_2("smart-artillery-exploration-remote")
	end
end

if artillery_setting == "both" or artillery_setting == "artillery-wagon" or artillery_setting == "artillery-turret" then
	custom_input_give_item_2("artillery-jammer-tool")
end

custom_input_give_item_1("artillery-targeting-remote")
custom_input_give_item_1("atomic-artillery-targeting-remote")
custom_input_give_item_1("discharge-defense-remote")
custom_input_give_item_1("ion-cannon-targeter")
custom_input_give_item_1("landmine-thrower-remote")
custom_input_give_item_1("mirv-targeting-remote")

custom_input_give_item_1("well-planner")
custom_input_give_item_1("winch")

if spidertron_setting == "enabled" or spidertron_setting == "enabled-hidden" then
	custom_input_give_item_2("spidertron-remote")
end
