--[[ Copyright (c) 2019 npc_strider
 * For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
 * This mod may contain modified code sourced from base/core Factorio
 *
 * shortcuts.lua
 * Shortcuts and mod compatibility
--]]

-- This code has been modified by ickputzdirwech.

-- BASIC

--[[
if mods["EditorExtensions"] and data.raw.shortcut["ee-toggle-map-editor"] then
	data.raw.shortcut["ee-toggle-map-editor"].order = "a[alt-mode]-a[ee-toggle-map-editor]"
end

if mods["factoryplanner"] and data.raw.shortcut["fp_open_interface"] then
	data.raw.shortcut["fp_open_interface"].order = "a[alt-mode]-b[fp_open_interface]"
end
]]

if settings.startup["flashlight-toggle"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "flashlight-toggle",
			order = "a[basic]-b[flashlight-toggle]",
			action = "lua",
			localised_name = {"", {"entity-name.character"}, " ", {"entity-name.small-lamp"}},
			toggleable = true,
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/flashlight-toggle-x32.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/flashlight-toggle-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/flashlight-toggle-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
	})
end

if settings.startup["signal-flare"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "signal-flare",
			order = "a[basic]-c[signal-flare]",
			action = "lua",
			localised_name = "Emergency locator beacon",
			toggleable = true,
			style = "red",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/signal-flare-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/signal-flare-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/signal-flare-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
	})
end

if settings.startup["draw-grid"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "draw-grid",
			order = "a[basic]-d[draw-grid]",
			action = "lua",
			localised_name = {"gui.grid"},
			style = "blue",
			toggleable = true,
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/grid-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/grid-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/grid-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
	})
end

if settings.startup["rail-block-visualization-toggle"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "rail-block-visualization-toggle",
			order = "a[basic]-e[rail-block-visualization-toggle]",
			action = "lua",
			localised_name = {"gui-interface-settings.show-rail-block-visualization"},
			style = "default",
			toggleable = true,
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/rail-block-visualization-toggle-x32.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/rail-block-visualization-toggle-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/rail-block-visualization-toggle-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
	})
end

if settings.startup["big-zoom"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "big-zoom",
			order = "a[basic]-f[big-zoom]",
			action = "lua",
			localised_name = {"controls.alt-zoom-out"},
			toggleable = true,
			style = "blue",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/big-zoom-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/big-zoom-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/big-zoom-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
	})
end


-- BLUEPRINT

if settings.startup["tree-killer"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "tree-killer",
			order = "b[blueprint]-g[tree-killer]",
			action = "lua",
			localised_name = {"", {"item-name.deconstruction-planner"}, " (", {"gui-deconstruction.whitelist-trees-and-rocks"}, ")"},
			technology_to_unlock = "construction-robotics",
			style = "red",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/tree-killer-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/tree-killer-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/tree-killer-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
	})
end


-- TOGGLES

if not mods["Nanobots"] then
	if settings.startup["belt-immunity-equipment"].value == true then
		data:extend(
		{
			{
				type = "shortcut",
				name = "belt-immunity-equipment",
				order = "c[toggles]-c[belt-immunity-equipment]",
				action = "lua",
				localised_name = {"item-name.belt-immunity-equipment"},
				technology_to_unlock = "belt-immunity-equipment",
				toggleable = true,
				icon =
				{
					filename = "__Shortcuts-ick__/graphics/belt-immunity-toggle-x32.png",
					priority = "extra-high-no-scale",
					size = 32,
					scale = 1,
					flags = {"icon"}
				},
				small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/belt-immunity-toggle-x24.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
				disabled_small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/belt-immunity-toggle-x24-white.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
			}
		})
	end

	if settings.startup["night-vision-equipment"].value == true then
		data:extend(
		{
			{
				type = "shortcut",
				name = "night-vision-equipment",
				order = "c[toggles]-d[night-vision-equipment]",
				action = "lua",
				localised_name = {"equipment-name.night-vision-equipment"},
				technology_to_unlock = "night-vision-equipment",
				toggleable = true,
				icon =
				{
					filename = "__Shortcuts-ick__/graphics/night-vision-toggle-x32.png",
					priority = "extra-high-no-scale",
					size = 32,
					scale = 1,
					flags = {"icon"}
				},
				small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/night-vision-toggle-x24.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
				disabled_small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/night-vision-toggle-x24-white.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
			},
		})
	end

	if settings.startup["active-defense-equipment"].value == true then
		data:extend(
		{
			{
				type = "shortcut",
				name = "active-defense-equipment",
				order = "c[toggles]-f[active-defense-equipment]",
				action = "lua",
				localised_name = {"equipment-name.personal-laser-defense-equipment"},
				technology_to_unlock = "personal-laser-defense-equipment",
				toggleable = true,
				icon =
				{
					filename = "__Shortcuts-ick__/graphics/active-defense-equipment-x32.png",
					priority = "extra-high-no-scale",
					size = 32,
					scale = 1,
					flags = {"icon"}
				},
				small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/active-defense-equipment-x24.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
				disabled_small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/active-defense-equipment-x24-white.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
			},
		})
	end
end


-- EQUIPMENT

if settings.startup["artillery-targeting-remote"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "artillery-targeting-remote",
			order = "d[remotes]-a[artillery-targeting-remote]",
			action = "lua",
			localised_name = {"item-name.artillery-targeting-remote"},
			style = "red",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/artillery-targeting-remote-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/artillery-targeting-remote-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/artillery-targeting-remote-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
	})
end

if settings.startup["artillery-toggle"].value == "both" or settings.startup["artillery-toggle"].value == "Artillery wagon" or settings.startup["artillery-toggle"].value == "Artillery turret" then

	local disable_turret_list = {}

	if settings.startup["artillery-toggle"].value == "both" then
		disable_turret_list = {"artillery-wagon", "artillery-turret"}
	elseif settings.startup["artillery-toggle"].value == "artillery-wagon" then
		disable_turret_list = {"artillery-wagon"}
	elseif settings.startup["artillery-toggle"].value == "artillery-turret" then
		disable_turret_list = {"artillery-turret"}
	end

	data:extend(
	{
		{
			type = "shortcut",
			name = "artillery-jammer-remote",
			order = "d[remotes]-b[artillery-jammer-remote]",
			action = "lua",
			localised_name = {"", {"gui-mod-info.toggle"}, " ", {"entity-name.artillery-wagon"}, " ", {"damage-type-name.fire"}},
			style = "red",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/artillery-jammer-remote-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/artillery-jammer-remote-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/artillery-jammer-remote-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
		{
			type = "selection-tool",
			name = "artillery-jammer-tool",
			icon = "__Shortcuts-ick__/graphics/artillery-jammer-remote.png",
			icon_size = 32,
			flags = {"hidden", "only-in-cursor"},
			subgroup = "other",
			order = "c[automated-construction]-a[artillery-jammer-tool]",
			stack_size = 1,
			stackable = false,
			selection_color = { r = 1, g = 0, b = 0 },
			alt_selection_color = { r = 1, g = 0, b = 0 },
			selection_mode = {"blueprint"},
			alt_selection_mode = {"blueprint"},
			selection_cursor_box_type = "copy",
			alt_selection_cursor_box_type = "copy",
			entity_type_filters = disable_turret_list,
			tile_filters = {"lab-dark-1"},
			entity_filter_mode = "whitelist",
			tile_filter_mode = "whitelist",
			alt_entity_type_filters = disable_turret_list,
			alt_tile_filters = {"lab-dark-1"},
			alt_entity_filter_mode = "whitelist",
			alt_tile_filter_mode = "whitelist",
			show_in_library = false,
			always_include_tiles = false
		},
	})
end

if settings.startup["discharge-defense-remote"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "discharge-defense-remote",
			order = "d[remotes]-c[discharge-defense-remote]",
			action = "lua",
			localised_name = {"item-name.discharge-defense-remote"},
			style = "red",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/discharge-defense-remote-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/discharge-defense-remote-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/discharge-defense-remote-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		},
	})
end

if settings.startup["spidertron-remote"].value == "enabled" or "enabled (hide remote from inventory)" then
	data:extend(
	{
		{
			type = "shortcut",
			name = "spidertron-remote",
			order = "d[remotes]-d[spidertron-remote]",
			action = "lua",
			localised_name = {"item-name.spidertron-remote"},
			style = "red",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-remote-x40-white.png",
				priority = "extra-high-no-scale",
				size = 40,
				scale = 1,
				flags = {"icon"},
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-remote-x40-white.png",
				priority = "extra-high-no-scale",
				size = 40,
				scale = 1,
				flags = {"icon"},
				tint = {},
			},
		},
	})
end

-- MOD

if mods["aai-programmable-vehicles"] and settings.startup["aai-remote-controls"].value == true then
	if data.raw["selection-tool"]["unit-remote-control"] then
		data:extend(
		{
			{
				type = "shortcut",
				name = "unit-remote-control",
				order = "e[mods]-a[unit-remote-control]",
				action = "lua",
				localised_name = {"item-name.unit-remote-control"},
				style = "blue",
				icon =
				{
					filename = "__Shortcuts-ick__/graphics/unit-remote-control-x32-white.png",
					priority = "extra-high-no-scale",
					size = 32,
					scale = 1,
					flags = {"icon"}
				},
				small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/unit-remote-control-x24.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
				disabled_small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/unit-remote-control-x24-white.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
			}
		})
	end

	if data.raw["selection-tool"]["path-remote-control"] then
		data:extend(
		{
			{
				type = "shortcut",
				name = "path-remote-control",
				order = "e[mods]-b[path-remote-control]",
				action = "lua",
				localised_name = {"item-name.path-remote-control"},
				style = "blue",
				icon =
				{
					filename = "__Shortcuts-ick__/graphics/path-remote-control-x32-white.png",
					priority = "extra-high-no-scale",
					size = 32,
					scale = 1,
					flags = {"icon"}
				},
				small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/path-remote-control-x24.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
				disabled_small_icon =
				{
					filename = "__Shortcuts-ick__/graphics/path-remote-control-x24-white.png",
					priority = "extra-high-no-scale",
					size = 24,
					scale = 1,
					flags = {"icon"}
				},
			}
		})
	end
end

if mods["Orbital Ion Cannon"] and data.raw["item"]["ion-cannon-targeter"] and data.raw["technology"]["orbital-ion-cannon"] and settings.startup["ion-cannon-targeter"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "ion-cannon-targeter",
			order = "e[mods]-c[ion-cannon-targeter]",
			action = "lua",
			localised_name = {"item-name.ion-cannon-targeter"},
			style = "red",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/ion-cannon-targeter-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/ion-cannon-targeter-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/ion-cannon-targeter-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		}
	})
end

if mods["MaxRateCalculator"] and data.raw["selection-tool"]["max-rate-calculator"] and settings.startup["max-rate-calculator"].value == true then

	if data.raw["selection-tool"]["max-rate-calculator"] then
		data.raw["selection-tool"]["max-rate-calculator"].icon = "__MaxRateCalculator__/graphics/calculator.png"
		data.raw["selection-tool"]["max-rate-calculator"].icon_size = 64
	end

	data:extend(
	{
		{
			type = "shortcut",
			name = "max-rate-shortcut",
			order = "e[mod]-d[max-rate-calculator]",
			action = "create-blueprint-item",
			localised_name = {"item-name.max-rate-calculator"},
			item_to_create = "max-rate-calculator",
			style = "blue",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/max-rate-calculator-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/max-rate-calculator-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/max-rate-calculator-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		}
	})
end

if mods["OutpostPlanner"] and mods["PlannerCore"] and data.raw["selection-tool"]["outpost-builder"] and settings.startup["outpost-builder"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "outpost-builder",
			order = "e[mod]-e[outpost-builder]",
			action = "create-blueprint-item",
			localised_name = {"item-name.outpost-builder"},
			item_to_create = "outpost-builder",
			style = "green",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/outpost-builder-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/outpost-builder-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/outpost-builder-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
		}
	})
end

if mods["VehicleWagon2"] and settings.startup["vehicle-wagon-2-winch"].value == true then

	data.raw.technology["vehicle-wagons"].localised_description = "Vehicle wagons allow you to carry equipped and loaded vehicles on trains, so they are ready to deploy immediately upon arrival."

	data:extend(
  {
    {
      type = "shortcut",
      name = "vehicle-wagon-2-winch",
      order = "e[mod]-f[vehicle-wagon-2-winch]",
      action = "lua",
      localised_name = {"item-name.winch"},
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/module-inserter-x32.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 1,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/module-inserter-x24.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/module-inserter-x24-white.png",
				priority = "extra-high-no-scale",
				size = 24,
				scale = 1,
				flags = {"icon"}
			},
    }
  })
end
