--[[ Copyright (c) 2022 npc_strider, ickputzdirwech
	* Original mod by npc_strider.
	* For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
	* This mod may contain modified code sourced from base/core Factorio.
	* This mod has been modified by ickputzdirwech.
]]

--[[ Overview of shortcuts-vehicle.lua:
	* Driver is gunner shortcut.
	* Spidertron remote shortcut.
	* Spidertron Enable/disable logistics while moving shortcut.
	* Spidertron logistic request shortcut.
	* Spidertron Auto targeting with gunner shortcut.
	* Spidertron Auto targeting without gunner shortcut.
	* Train mode toggle shortcut.
	* AAI remote control shortcuts.
	* VehicleWagon2 winch shortcut.
]]

-- TAGS
local driver_is_gunner
local spidertron_remote
local spidertron
local train
local unit_remote_control
local path_remote_control
local winch
if settings.startup["ick-tags"].value == "tags" then
	local tag = {"", "[color=orange]", {"tooltip-category.vehicle"}, ": [/color]"}
	driver_is_gunner = tag
	spidertron_remote = tag
	spidertron = tag
	train = tag
	unit_remote_control = tag
	path_remote_control = tag
	winch = tag
elseif settings.startup["ick-tags"].value == "icons" then
	driver_is_gunner = "[img=item/submachine-gun] "
	spidertron_remote = "[img=item/spidertron-remote] "
	spidertron = "[img=item/spidertron] "
	train = "[img=item/locomotive] "
	unit_remote_control = "[img=item/unit-remote-control] "
	path_remote_control = "[img=item/path-remote-control] "
	winch = "[img=item/winch] "
else
	driver_is_gunner = ""
	spidertron_remote = ""
	spidertron = ""
	train = ""
	unit_remote_control = ""
	path_remote_control = ""
	winch = ""
end

-- DRIVER IS GUNNER
if settings.startup["driver-is-gunner"].value then
	data:extend({{
		type = "shortcut",
		name = "driver-is-gunner",
		localised_name = {"", driver_is_gunner, {"Shortcuts-ick.driver-is-gunner"}},
		order = "e[vehicle]-a[driver-is-gunner]",
		action = "lua",
		toggleable = true,
		style = "red",
		icon = "__Shortcuts-ick__/graphics/driver-is-gunner-x32-2-white.png",
		icon_size = 32
	}})
end

-- SPIDERTRON REMOTE
if settings.startup["spidertron-remote"].value == "enabled" or settings.startup["spidertron-remote"].value == "enabled-hidden" then
	data:extend({{
		type = "shortcut",
		name = "spidertron-remote",
		localised_name = {"", spidertron_remote, {"item-name.spidertron-remote"}},
		order = "e[vehicle]-b[spidertron-remote]",
		action = "lua",
		style = "green",
		icon = "__Shortcuts-ick__/graphics/path-remote-control-x32-white.png",
		icon_size = 32,
		small_icon = "__Shortcuts-ick__/graphics/path-remote-control-x24-white.png",
		small_icon_size = 24
	}})
end

-- SPIDERTRON LOGISTICS WHILE MOVING
if settings.startup["spidertron-logistics"].value then
	data:extend({{
		type = "shortcut",
		name = "spidertron-logistics",
		localised_name = {"", spidertron, {"entity-name.spidertron"}, " ", {"gui.enable-logistics-while-moving"}},
		order = "e[vehicle]-c[spidertron-logistics]",
		action = "lua",
		toggleable = true,
		style = "green",
		icon = "__base__/graphics/icons/shortcut-toolbar/mip/toggle-personal-roboport-x32-white.png",
		icon_size = 32,
		small_icon = "__base__/graphics/icons/shortcut-toolbar/mip/toggle-personal-roboport-x24-white.png",
		small_icon_size = 24
	}})
end

-- SPIDERTRON LOGISTIC REQUESTS
if settings.startup["spidertron-logistic-requests"].value then
	data:extend({{
		type = "shortcut",
		name = "spidertron-logistic-requests",
		localised_name = {"", spidertron, {"entity-name.spidertron"}, " ", {"gui-logistic.title-request"}},
		order = "e[vehicle]-d[spidertron-logistic-requests]",
		action = "lua",
		toggleable = true,
		style = "green",
		icon = "__base__/graphics/icons/shortcut-toolbar/mip/toggle-personal-logistics-x32-white.png",
		icon_size = 32,
		small_icon = "__base__/graphics/icons/shortcut-toolbar/mip/toggle-personal-logistics-x24-white.png",
		small_icon_size = 24
	}})
end

-- SPIDERTRON TARGETING WITH GUNNER
if settings.startup["targeting-with-gunner"].value then
	data:extend({{
		type = "shortcut",
		name = "targeting-with-gunner",
		localised_name = {"", spidertron, {"entity-name.spidertron"}, " ", {"gui-car.automatic-targeting"}, " ", {"gui-car.with-gunner"}},
		order = "e[vehicle]-e[targeting-with-gunner]",
		action = "lua",
		toggleable = true,
		style = "green",
		icon = "__Shortcuts-ick__/graphics/spidertron-targeting-with-gunner-x32-2-white.png",
		icon_size = 32
	}})
end

-- SPIDERTRON TARGETING WITHOUT GUNNER
if settings.startup["targeting-without-gunner"].value then
	data:extend({{
		type = "shortcut",
		name = "targeting-without-gunner",
		localised_name = {"", spidertron, {"entity-name.spidertron"}, " ", {"gui-car.automatic-targeting"}, " ", {"gui-car.without-gunner"}},
		order = "e[vehicle]-f[targeting-with-gunner]",
		action = "lua",
		toggleable = true,
		style = "green",
		icon = "__Shortcuts-ick__/graphics/driver-is-gunner-x32-2-white.png",
		icon_size = 32
	}})
end

-- TRAIN MODE TOGGLE
if settings.startup["train-mode-toggle"].value then
	data:extend({{
		type = "shortcut",
		name = "train-mode-toggle",
		localised_name = {"", train, {"tooltip-category.train"}, " ", {"gui-trains.manual-mode"}},
		order = "e[vehicle]-g[train-mode-toggle]",
		action = "lua",
		toggleable = true,
		icon = "__Shortcuts-ick__/graphics/train-mode-toggle-x32-2.png",
		icon_size = 32
	}})
end

-- AAI PROGRAMMABLE VEHICLES REMOTE CONTROLS
if mods["aai-programmable-vehicles"] and settings.startup["aai-remote-controls"].value then
	data:extend({
		{
			type = "shortcut",
			name = "unit-remote-control",
			localised_name = {"", unit_remote_control, {"item-name.unit-remote-control"}, " ", {"Shortcuts-ick.control", "create-toggle-controller"}},
			order = "e[vehicle]-h[unit-remote-control]",
			action = "lua",
			style = "blue",
			icon = "__Shortcuts-ick__/graphics/unit-remote-control-x32-white.png",
			icon_size = 32,
			small_icon = "__Shortcuts-ick__/graphics/unit-remote-control-x24-white.png",
			small_icon_size = 24
		},
		{
			type = "shortcut",
			name = "path-remote-control",
			localised_name = {"", path_remote_control, {"item-name.path-remote-control"}, " ", {"Shortcuts-ick.control", "create-toggle-controller"}},
			order = "e[vehicle]-i[path-remote-control]",
			action = "lua",
			style = "blue",
			icon = "__Shortcuts-ick__/graphics/path-remote-control-x32-white.png",
			icon_size = 32,
			small_icon = "__Shortcuts-ick__/graphics/path-remote-control-x24-white.png",
			small_icon_size = 24
		}
	})
end

-- VEHICLE WAGON WINCH
if mods["VehicleWagon2"] and settings.startup["winch"].value then
	data:extend({{
		type = "shortcut",
		name = "winch",
		localised_name = {"", winch, {"item-name.winch"}},
		order = "e[vehicle]-j[winch]",
		action = "lua",
		icon = "__Shortcuts-ick__/graphics/module-inserter-x32.png",
		icon_size = 32,
		small_icon = "__Shortcuts-ick__/graphics/module-inserter-x24.png",
		small_icon_size = 24
	}})
end
