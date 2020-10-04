--[[ Copyright (c) 2019 npc_strider
 * For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
 * This mod may contain modified code sourced from base/core Factorio.
 * This mod has been modified by ickputzdirwech.
]]

--[[ Overview of shortcuts-vehicle.lua:
	* Spidertron remote shortcut and custom input
	* Spidertron Enable/disable logistics while moving shortcut and custom input.
	* Spidertron Auto targeting without gunner shortcut and custom input.
	* Spidertron Auto targeting with gunner shortcut and custom input.
	* AAI remote control shortcuts
	* VehicleWagon2 winch shortcut and custom input
]]

if settings.startup["spidertron-remote"].value == "enabled" or settings.startup["spidertron-remote"].value == "enabled-hidden" then
	data:extend(
	{
		{
			type = "shortcut",
			name = "spidertron-remote",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"item-name.spidertron-remote"}, {"Shortcuts-ick.control-spidertron-remote"}},
			order = "e[vehicle]-a[spidertron-remote]",
			--associated_control_input = "spidertron-remote",
			action = "lua",
			style = "red",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-remote-x40-2-white.png",
				priority = "extra-high-no-scale",
				size = 40,
				scale = 1,
	      mipmap_count = 2,
				flags = {"icon"},
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-remote-x40-2-white.png",
				priority = "extra-high-no-scale",
				size = 40,
				scale = 1,
	      mipmap_count = 2,
				flags = {"icon"},
				tint = {},
			},
			disabled_small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-remote-x40-2-white.png",
				priority = "extra-high-no-scale",
				size = 40,
				scale = 1,
	      mipmap_count = 2,
				flags = {"icon"},
			},
		},
		{
			type = "custom-input",
			name = "spidertron-remote",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"item-name.spidertron-remote"}},
			order = "e[vehicle]-a[spidertron-remote]",
			action = "create-blueprint-item",
			item_to_create = "spidertron-remote",
			key_sequence = "",
		},
	})
end


if settings.startup["spidertron-logistics"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "spidertron-logistics",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"entity-name.spidertron"}, " ", {"gui.enable-logistics-while-moving"}, {"Shortcuts-ick.control-spidertron-logistics"}},
			order = "e[vehicle]-b[spidertron-logistics]",
			--associated_control_input = "spidertron-logistics",
			action = "lua",
			toggleable = true,
			style = "green",
			icon =
	    {
	      filename = "__base__/graphics/icons/shortcut-toolbar/mip/toggle-personal-roboport-x32-white.png",
	      priority = "extra-high-no-scale",
	      size = 32,
	      scale = 0.5,
	      mipmap_count = 2,
	      flags = {"gui-icon"}
	    },
	    small_icon =
	    {
	      filename = "__base__/graphics/icons/shortcut-toolbar/mip/toggle-personal-roboport-x24.png",
	      priority = "extra-high-no-scale",
	      size = 24,
	      scale = 0.5,
	      mipmap_count = 2,
	      flags = {"gui-icon"}
	    },
	    small_disabled_icon =
	    {
	      filename = "__base__/graphics/icons/shortcut-toolbar/mip/toggle-personal-roboport-x24-white.png",
	      priority = "extra-high-no-scale",
	      size = 24,
	      scale = 0.5,
	      mipmap_count = 2,
	      flags = {"gui-icon"}
	    },
		},
	  {
			type = "custom-input",
	    name = "spidertron-logistics",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"entity-name.spidertron"}, " ", {"gui.enable-logistics-while-moving"}},
			order = "e[vehicle]-b[spidertron-logistics]",
			action = "lua",
	    key_sequence = "",
	  },
	})
end


if settings.startup["spidertron-automatic-targeting"].value == true then
	data:extend(
	{
		{
			type = "shortcut",
			name = "targeting-without-gunner",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"entity-name.spidertron"}, " ", {"gui-car.automatic-targeting"}, " ", {"gui-car.without-gunner"}, {"Shortcuts-ick.control-targeting-without-gunner"}},
			order = "e[vehicle]-c[targeting-without-gunner]",
			--associated_control_input = "targeting-without-gunner",
			action = "lua",
			toggleable = true,
			style = "green",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-targeting-without-gunner-x40-2-white.png",
				priority = "extra-high-no-scale",
				size = 40,
	      mipmap_count = 2,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-targeting-without-gunner-x40-2-white.png",
				priority = "extra-high-no-scale",
				tint = {},
				size = 40,
	      mipmap_count = 2,
				flags = {"icon"}
			},
			small_disabled_icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-targeting-without-gunner-x40-2-white.png",
				priority = "extra-high-no-scale",
				size = 40,
	      mipmap_count = 2,
				flags = {"icon"}
			},
		},
	  {
			type = "custom-input",
	    name = "targeting-without-gunner",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"entity-name.spidertron"}, " ", {"gui-car.automatic-targeting"}, " ", {"gui-car.without-gunner"}},
			order = "e[vehicle]-c[targeting-without-gunner]",
			action = "lua",
	    key_sequence = "",
	  },
		{
			type = "shortcut",
			name = "targeting-with-gunner",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"entity-name.spidertron"}, " ", {"gui-car.automatic-targeting"}, " ", {"gui-car.with-gunner"}, {"Shortcuts-ick.control-targeting-with-gunner"}},
			order = "e[vehicle]-d[targeting-with-gunner]",
			--associated_control_input = "targeting-with-gunner",
			action = "lua",
			toggleable = true,
			style = "green",
			icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-targeting-with-gunner-x40-2-white.png",
				priority = "extra-high-no-scale",
				size = 40,
	      mipmap_count = 2,
				flags = {"icon"}
			},
			small_icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-targeting-with-gunner-x40-2-white.png",
				priority = "extra-high-no-scale",
				tint = {},
				size = 40,
	      mipmap_count = 2,
				flags = {"icon"}
			},
			small_disabled_icon =
			{
				filename = "__Shortcuts-ick__/graphics/spidertron-targeting-with-gunner-x40-2-white.png",
				priority = "extra-high-no-scale",
				size = 40,
	      mipmap_count = 2,
				flags = {"icon"}
			},
		},
	  {
			type = "custom-input",
	    name = "targeting-with-gunner",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"entity-name.spidertron"}, " ", {"gui-car.automatic-targeting"}, " ", {"gui-car.with-gunner"}},
			order = "e[vehicle]-d[targeting-with-gunner]",
			action = "lua",
	    key_sequence = "",
	  },
	})
end


if mods["aai-programmable-vehicles"] and settings.startup["aai-remote-controls"].value == true then
	if data.raw["selection-tool"]["unit-remote-control"] then
		data:extend(
		{
			{
				type = "shortcut",
				name = "unit-remote-control",
				localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"item-name.unit-remote-control"}, {"Shortcuts-ick.control-unit-remote-control"}},
				order = "e[vehicle]-e[unit-remote-control]",
				--associated_control_input = "create-toggle-controller",
				action = "lua",
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
			},
		})
	end

	if data.raw["selection-tool"]["path-remote-control"] then
		data:extend(
		{
			{
				type = "shortcut",
				name = "path-remote-control",
				localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"item-name.path-remote-control"}, {"Shortcuts-ick.control-unit-remote-control"}},
				order = "e[vehicle]-f[path-remote-control]",
				--associated_control_input = "create-toggle-controller",
				action = "lua",
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
			},
		})
	end
end


if mods["VehicleWagon2"] and settings.startup["winch"].value == true then

	data.raw.technology["vehicle-wagons"].localised_description = "Vehicle wagons allow you to carry equipped and loaded vehicles on trains, so they are ready to deploy immediately upon arrival."

	data:extend(
  {
    {
      type = "shortcut",
      name = "winch",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"item-name.winch"}, {"Shortcuts-ick.control-winch"}},
      order = "e[vehicle]-g[winch]",
			--associated_control_input = "winch",
      action = "lua",
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
			disabled_icon =
			{
				filename = "__Shortcuts-ick__/graphics/module-inserter-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
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
    },
		{
			type = "custom-input",
			name = "winch",
			localised_name = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]", {"item-name.winch"}},
      order = "e[vehicle]-g[winch]",
			action = "create-blueprint-item",
			item_to_create = "winch",
			key_sequence = "",
		},
  })
end
