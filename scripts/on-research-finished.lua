--[[ Copyright (c) 2022 npc_strider, ickputzdirwech
	* Original mod by npc_strider.
	* For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
	* This mod may contain modified code sourced from base/core Factorio.
	* This mod has been modified by ickputzdirwech.
]]

--[[ Overview of on-research-finished.lua:
	* Functions
	* Special cases
	* Mod
	* Mod with own shortcut
]]

if settings.startup["ick-compatibility-mode"].value == false then
	script.on_event(defines.events.on_research_finished, function(event)
		for _, player in pairs(event.research.force.players) do

		-- FUNCTIONS
		local research = event.research.name
		local mods = script.active_mods
		local setting = settings.startup

		local function enable_shortcut(setting_name, name)
			if setting[setting_name].value then
				player.set_shortcut_available(name, true)
			end
		end

		local function enable_shortcut_2(mod_name, tech_name, name)
			if mods[mod_name] and research == tech_name then
				player.set_shortcut_available(name, true)
			end
		end


		-- MOD
		if mods["aai-programmable-vehicles"] and (research == "automobilism" or research == "spidertron") then
			enable_shortcut("aai-remote-controls", "path-remote-control")
			enable_shortcut("aai-remote-controls", "unit-remote-control")
		end


		-- MOD WITH OWN SHORTCUT
		if mods["car-finder"] and (research == "automobilism" or research == "spidertron") then
			player.set_shortcut_available("car-finder-button", true)
		end

		enable_shortcut_2("circuit-checker", "circuit-network", "check-circuit")
		enable_shortcut_2("Kux-OrbitalIonCannon", "orbital-ion-cannon", "ion-cannon-targeter")
		enable_shortcut_2("ModuleInserter", "modules", "module-inserter")
		enable_shortcut_2("ModuleInserterER", "modules", "module-inserter")

		if mods["Nanobots"] then
			enable_shortcut_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-feeder")
			enable_shortcut_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-items")
			enable_shortcut_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-launcher")
			enable_shortcut_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-nanointerface")
			enable_shortcut_2("PickerInventoryTools", "personal-roboport-equipment", "toggle-equipment-bot-chip-trees")
		end

		enable_shortcut_2("pump", "oil-processing", "pump-shortcut")
		enable_shortcut_2("RailSignalPlanner", "rail-signals", "give-rail-signal-planner")
		enable_shortcut_2("RailSignalPlannerNeo", "rail-signals", "give-rail-signal-planner")
		enable_shortcut_2("Spider_Control", "spidertron", "squad-spidertron-follow")
		enable_shortcut_2("Spider_Control", "spidertron", "squad-spidertron-remote")
		enable_shortcut_2("Spider_Control", "spidertron", "squad-spidertron-list")
		enable_shortcut_2("Spider_Control", "spidertron", "squad-spidertron-link-tool")
		enable_shortcut_2("SpidertronWaypoints", "spidertron", "spidertron-remote-waypoint")
		enable_shortcut_2("SpidertronWaypoints", "spidertron", "spidertron-remote-patrol")
		enable_shortcut_2("VehicleSnap", "automobilism", "VehicleSnap-shortcut")

		end
	end)
end
