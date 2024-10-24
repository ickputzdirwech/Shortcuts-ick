--[[ Copyright (c) 2022 npc_strider, ickputzdirwech
	* Original mod by npc_strider.
	* For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
	* This mod may contain modified code sourced from base/core Factorio.
	* This mod has been modified by ickputzdirwech.
]]

--[[ Overview of final-fixes-shortcuts-autogeneration.lua:
	* Autogeneration of modded shortcuts
]]

-- Moved here because of mod "northifytool".

local function hide_the_remote(recipe, technology, item)
	if item then
		if item.flags then
			table.insert(item.flags, "only-in-cursor")
			table.insert(item.flags, "spawnable")
		else
			item.flags = {"only-in-cursor", "spawnable"}
		end
	end
	local recipe_prototype = data.raw.recipe[recipe]
	local tech_prototype = data.raw.technology[technology]
	if recipe_prototype then
		recipe_prototype.hidden = true
		recipe_prototype.ingredients = {{type = "item", name = "iron-plate", amount = 1}}
		if technology ~= nil and tech_prototype then
			for i, effect in pairs(tech_prototype.effects) do
				if effect.type == "unlock-recipe" then
					if effect.recipe == recipe then
						table.remove(tech_prototype.effects, i)
						return
					end
				end
			end
		end
	end
end

local autogen_color = settings.startup["autogen-color"].value
if autogen_color == "default" or autogen_color == "red" or autogen_color == "green" or autogen_color == "blue" then

	-- create a post on the discussion page if you want your shortcut to be added to this ignore_list.
	local shortcut_ignore_list = {
		"artillery-bombardment-remote",
		"smart-artillery-bombardment-remote",
		"smart-artillery-exploration-remote",
		"artillery-jammer-tool",
		"autotrash-network-selection",
		"blueprint-align__item__grid-selection-tool", -- "Blueprint aligner" by emlun
		"circuit-checker",
		"fp_beacon_selector",
		"GCKI_car-key", -- "Gizmos Car Keys (improved)" by Pi-C
		"max-rate-calculator",
		"module-inserter",
		"merge-chest-selector",
		"nullius-rock-picker",
		"outpost-builder",
		"path-remote-control",
		"pump-selection-tool",
		"rail-signal-planner",
		"rcalc-all-selection-tool",
		"rcalc-electricity-selection-tool",
		"rcalc-heat-selection-tool",
		"rcalc-materials-selection-tool",
		"rcalc-pollution-selection-tool",
		"selection-tool",
		"se-energy-transmitter-targeter",
		"se-delivery-cannon-targeter",
		"squad-spidertron-remote-sel",
		"squad-spidertron-unlink-tool",
		"tms-switcher",
		"trainbuilder-manual",
		"unit-remote-control",
		"well-planner",
		"winch",
		"wire-cutter-copper",
		"wire-cutter-green",
		"wire-cutter-red",
		"wire-cutter-universal"
	}

	for _, tool in pairs(data.raw["selection-tool"]) do
		local name = tool.name
		local continue = true

		-- Ignore tools from "Blueprint Sandboxes" by somethingtohide and from "Janky quality (BETA)" by Soul-Burn
		if string.sub(name, 1, 9) == "bpsb-sbr-" or string.sub(name, 1, 15) == "quality-module-" then
			continue = false
		else
			-- Ignore tools from the ignore_list
			for _, ignore_list in pairs(shortcut_ignore_list) do
				if name == ignore_list then
					continue = false
					break
				end
			end
		end

		if continue == true then
			local create = true
			for _, shortcut in pairs(data.raw["shortcut"]) do
				if shortcut.action == "spawn-item" and shortcut.item_to_spawn == name then
					create = false
					break
				end
			end

			if create == true then
				local icons
				if tool.icons then
					icons = tool.icons
				elseif tool.icon and tool.icon_size then
					icons = {{
						icon = tool.icon,
						icon_size = tool.icon_size,
						scale = 0.5
					}}
				else
					icons = {{
						icon = "__core__/graphics/questionmark.png",
						icon_size = 64,
						scale = 0.5
					}}
				end

				local shortcut = {
					type = "shortcut",
					name = name,
					order = tool.order,
					action = "spawn-item",
					localised_name = {"item-name." .. name},
					item_to_spawn = name,
					style = settings.startup["autogen-color"].value,
					icons = icons,
					small_icons = icons
				}

				data:extend({shortcut})
				hide_the_remote(name, name, tool) -- only attempts to hide the selection-tool if the recipe/tech name matches the tool name - does not search all recipes for mention of the tool.
			end
		end
	end

end
