--[[ Copyright (c) 2022 npc_strider, ickputzdirwech
	* Original mod by npc_strider.
	* For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
	* This mod may contain modified code sourced from base/core Factorio.
	* This mod has been modified by ickputzdirwech.
]]

--[[ Overview of on-player-created.lua:
	* Functions
	* Special cases
	* Equipment and vehicle
	* Mod
	* Mod with own shortcut
]]

function ick_reset_available_shortcuts(player)

	-- FUNCTIONS
	local tech = player.force.technologies
	local mods = script.active_mods
	local setting = settings.startup

	local function disable_shortcuts(name) -- checks if the setting is active
		if setting[name].value then
			player.set_shortcut_available(name, false)
		end
	end


	local function disable_shortcuts_1(mod_name, tech_name, name) -- checks if mod and setting is active an tech is researched
		if mods[mod_name] and setting[name].value and tech[tech_name].researched == false then
			player.set_shortcut_available(name, false)
		end
	end

	local function disable_shortcuts_2(mod_name, tech_name, name) -- checks if mod is active an tech is researched
		if mods[mod_name] and tech[tech_name].researched == false then
			player.set_shortcut_available(name, false)
		end
	end


	-- EQUIPMENT and VEHICLE
	local function disable_shortcuts_equipment(type) -- checks if the setting is active and if the player has the equipment equiped
		if setting[type].value then
			local equiped = false
			local power_armor = player.get_inventory(defines.inventory.character_armor)
			if power_armor and power_armor.valid then
				if power_armor[1].valid_for_read then
					if power_armor[1].grid and power_armor[1].grid.valid and power_armor[1].grid.width > 0 then
						for _, equipment in pairs(power_armor[1].grid.equipment) do
							if equipment.type == type then
								equiped = true
								break
							end
						end
						if equiped == false then
							player.set_shortcut_available(type, false)
						end
					end
				end
			end
		end
	end

	disable_shortcuts_equipment("active-defense-equipment")
	disable_shortcuts_equipment("belt-immunity-equipment")
	disable_shortcuts_equipment("night-vision-equipment")
	disable_shortcuts_equipment("discharge-defense-remote")


	-- VEHICLE
	if player.vehicle then
		local type = player.vehicle.type
		if type ~= "car" and type ~= "spider-vehicle" then
			disable_shortcuts("driver-is-gunner")
		end
		if type ~= "spider-vehicle" then
			disable_shortcuts("spidertron-logistics")
			disable_shortcuts("spidertron-logistic-requests")
			disable_shortcuts("targeting-with-gunner")
			disable_shortcuts("targeting-without-gunner")
		end
		if type ~= "locomotive" and type ~= "cargo-wagon" and type ~= "fluid-wagon" and type ~= "artillery-wagon" then
			disable_shortcuts("train-mode-toggle")
		end
	end


	-- SPECIAL CASES
	if setting["flashlight-toggle"].value then
		player.set_shortcut_toggled("flashlight-toggle", true)
	end

	if tech["railway"].researched == false then
		disable_shortcuts("rail-block-visualization-toggle")
	end

	local artillery_toggle = setting["artillery-toggle"].value
	if tech["artillery"].researched == false and (artillery_toggle == "both" or artillery_toggle == "artillery-wagon" or artillery_toggle == "artillery-turret") then
		player.set_shortcut_available("artillery-jammer-tool", false)
	end


	-- MOD
	if tech["spidertron"].researched == false then
		disable_shortcuts_2("aai-programmable-vehicles", "automobilism", "path-remote-control")
		disable_shortcuts_2("aai-programmable-vehicles", "automobilism", "unit-remote-control")
	end

	if mods["AdvancedArtilleryRemotesContinued"] and setting["artillery-targeting-remotes"].value and tech["artillery"].researched == false then
		player.set_shortcut_available("artillery-cluster-remote-artillery-shell", false)
		player.set_shortcut_available("artillery-discovery-remote", false)
	end

	if (mods["artillery-bombardment-remote"] or mods["artillery-bombardment-remote-reloaded"] or mods["dbots-artillery-bombardment-remote"]) and setting["artillery-targeting-remotes"].value then
		if tech["artillery-bombardment-remote"].researched == false then
			player.set_shortcut_available("artillery-bombardment-remote", false)
		end
		if tech["smart-artillery-bombardment-remote"].researched == false then
			player.set_shortcut_available("smart-artillery-bombardment-remote", false)
		end
		if tech["smart-artillery-exploration-remote"].researched == false then
			player.set_shortcut_available("smart-artillery-exploration-remote", false)
		end
	end

	disable_shortcuts_1("AtomicArtilleryRemote", "atomic-artillery", "atomic-artillery-targeting-remote")
	-- disable_shortcuts_1("jetpack", "jetpack-1", "jetpack")
	disable_shortcuts_1("landmine-thrower", "landmine-thrower", "landmine-thrower-remote")
	disable_shortcuts_1("MIRV", "mirv-technology", "mirv-targeting-remote")
	disable_shortcuts_1("VehicleWagon2", "vehicle-wagons", "winch")
	disable_shortcuts_1("WellPlanner", "oil-processing", "well-planner")


	-- MOD WITH OWN SHORTCUT
	if tech["automobilism"].researched == false then
		disable_shortcuts_2("car-finder", "spidertron", "car-finder-button")
	end

	disable_shortcuts_2("circuit-checker", "circuit-network", "check-circuit")
	disable_shortcuts_2("Kux-OrbitalIonCannon", "orbital-ion-cannon", "ion-cannon-targeter")
	disable_shortcuts_2("ModuleInserter", "modules", "module-inserter")
	disable_shortcuts_2("ModuleInserterER", "modules", "module-inserter")

	if mods["Nanobots"] then
		disable_shortcuts_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-feeder")
		disable_shortcuts_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-items")
		disable_shortcuts_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-launcher")
		disable_shortcuts_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-nanointerface")
		disable_shortcuts_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-trees")
	end

	disable_shortcuts_2("pump", "oil-processing", "pump-shortcut")
	disable_shortcuts_2("RailSignalPlanner", "rail-signals", "give-rail-signal-planner")
	disable_shortcuts_2("RailSignalPlannerNeo", "rail-signals", "give-rail-signal-planner")
	disable_shortcuts_2("Spider_Control", "spidertron", "squad-spidertron-follow")
	disable_shortcuts_2("Spider_Control", "spidertron", "squad-spidertron-remote")
	disable_shortcuts_2("Spider_Control", "spidertron", "squad-spidertron-list")
	disable_shortcuts_2("Spider_Control", "spidertron", "squad-spidertron-link-tool")
	disable_shortcuts_2("SpidertronWaypoints", "spidertron", "spidertron-remote-waypoint")
	disable_shortcuts_2("SpidertronWaypoints", "spidertron", "spidertron-remote-patrol")
	disable_shortcuts_2("VehicleSnap", "automobilism", "VehicleSnap-shortcut")
end

if settings.startup["ick-compatibility-mode"].value == false then
	script.on_event(defines.events.on_player_created, function(event)
		ick_reset_available_shortcuts(game.players[event.player_index])
	end)
end
