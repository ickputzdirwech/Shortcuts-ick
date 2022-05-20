--[[ Copyright (c) 2022 npc_strider, ickputzdirwech
	* Original mod by npc_strider.
	* For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
	* This mod may contain modified code sourced from base/core Factorio.
	* This mod has been modified by ickputzdirwech.
]]

--[[ Overview of shortcuts-blueprint.lua:
	* Tree killer
		- Tree killer deconstruction planner.
		- Environment shortcut.
		- Trees/rocks shortcut.
		- Cliff/Fish/Item on ground shortcut.
	* WellPlanner shortcut.
]]


-- TAGS
local deconstruction_planner = ""
local well_planner = ""
if settings.startup["ick-tags"].value == "tags" then
	local tag = {"", "[color=blue]", {"item-name.blueprint"}, ": [/color]"}
	deconstruction_planner = tag
	well_planner = tag
elseif settings.startup["ick-tags"].value == "icons" then
	deconstruction_planner = "[img=entity/tree-01] "
	well_planner = "[img=item/well-planner] "
end


-- TREE KILLER
local tree_killer = settings.startup["tree-killer"].value

if  settings.startup["tree-killer"].value then

	local tree_killer_item = util.table.deepcopy(data.raw["deconstruction-item"]["deconstruction-planner"])
		tree_killer_item.name = "tree-killer"
		tree_killer_item.localised_name = {"", {"item-group-name.environment"}, " ", {"item-name.deconstruction-planner"}}
		tree_killer_item.flags = {"only-in-cursor", "hidden"}
		tree_killer_item.entity_filter_count = 255

	local tree_killer_shortcut = {
		type = "shortcut",
		name = "tree-killer",
		localised_name = {"", deconstruction_planner, {"item-group-name.environment"}, " ", {"item-name.deconstruction-planner"}},
		order = "b[blueprint]-g[tree-killer]",
		--associated_control_input = "tree-killer",
		action = "lua",
		technology_to_unlock = "construction-robotics",
		style = "red",
		icon =
		{
			filename = "__Shortcuts-ick__/graphics/tree-killer-x32-white.png",
			priority = "extra-high-no-scale",
			size = 32,
			scale = 0.5,
			flags = {"gui-icon"}
		},
		small_icon =
		{
			filename = "__Shortcuts-ick__/graphics/tree-killer-x24-white.png",
			priority = "extra-high-no-scale",
			size = 24,
			scale = 0.5,
			flags = {"gui-icon"}
		}
	}

	data:extend({tree_killer_item, tree_killer_shortcut})
end


-- WELL PLANNER
if settings.startup["well-planner"] and settings.startup["well-planner"].value and data.raw["selection-tool"]["well-planner"] then
	data:extend(
	{
		{
			type = "shortcut",
			name = "well-planner",
			localised_name = {"", well_planner, {"item-name.well-planner"}},
			order = "b[blueprint]-j[well-planner]",
			--associated_control_input = "well-planner",
			action = "lua",
			icon =
			{
				filename = "__WellPlanner__/graphics/well-planner.png",
				priority = "extra-high-no-scale",
				size = 64,
				scale = 0.5,
				flags = {"gui-icon"}
			}
		}
	})
end
