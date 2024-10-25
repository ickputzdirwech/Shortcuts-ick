--[[ Copyright (c) 2022 npc_strider, ickputzdirwech
	* Original mod by npc_strider.
	* For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
	* This mod may contain modified code sourced from base/core Factorio.
	* This mod has been modified by ickputzdirwech.
]]

--[[ Overview of shortcuts-artillery.lua:
	* AdvancedArtilleryRemotesContinued artillery-discovery-remote shortcut.
	* Artillery Bombardment Remote shortcuts
	* Toggle artillery cannon fire
		- configuration
		- shortcut
		- selection tool
	* MIRV targeting remote shortcut.
	* AtomicArtilleryRemote shortcut.
	* Landmine thrower shortcut.
]]

-- TAGS
local artillery_discovery_remote
local artillery_bombardment_remote
local smart_artillery_bombardment_remote
local smart_artillery_exploration_remote
local artillery_turret
local mirv_targeting_remote
local atomic_artillery_targeting_remote
local landmine_thrower_remote
if settings.startup["ick-tags"].value == "tags" then
	local tag = {"", "[color=red]", {"technology-name.artillery"}, ": [/color]"}
	artillery_discovery_remote = tag
	artillery_bombardment_remote = tag
	smart_artillery_bombardment_remote = tag
	smart_artillery_exploration_remote = tag
	artillery_turret = tag
	mirv_targeting_remote = tag
	atomic_artillery_targeting_remote = tag
	landmine_thrower_remote = tag
elseif settings.startup["ick-tags"].value == "icons" then
	artillery_discovery_remote = "[img=item/artillery-discovery-remote] "
	artillery_bombardment_remote = "[img=item/artillery-bombardment-remote] "
	smart_artillery_bombardment_remote = "[img=item/smart-artillery-bombardment-remote] "
	smart_artillery_exploration_remote = "[img=item/smart-artillery-exploration-remote] "
	artillery_turret = "[img=item/artillery-turret] "
	mirv_targeting_remote = "[img=item/mirv-targeting-remote] "
	atomic_artillery_targeting_remote = "[img=item/artillery-targeting-remote] "
	landmine_thrower_remote = "[img=item/landmine-thrower-remote] "
else
	artillery_discovery_remote = ""
	artillery_bombardment_remote = ""
	smart_artillery_bombardment_remote = ""
	smart_artillery_exploration_remote = ""
	artillery_turret = ""
	mirv_targeting_remote = ""
	atomic_artillery_targeting_remote = ""
	landmine_thrower_remote = ""
end

-- ADVANCED ARTILLERY REMOTES CONTINUED
if settings.startup["artillery-targeting-remotes"] and settings.startup["artillery-targeting-remotes"].value and data.raw.capsule["artillery-discovery-remote"] then
	data:extend({
		{
			type = "shortcut",
			name = "artillery-discovery-remote",
			localised_name = {"", artillery_discovery_remote, {"item-name.artillery-discovery-remote"}},
			order = "d[artillery]-c[artillery-discovery-remote]",
			action = "lua",
			style = "red",
			icon = "__Shortcuts-ick__/graphics/artillery-discovery-remote-x32-white.png",
			icon_size = 32,
			small_icon = "__Shortcuts-ick__/graphics/artillery-discovery-remote-x32-white.png",
			small_icon_size = 32
		}
	})
end

-- ARTILLERY BOMBARDMENT REMOTES
if settings.startup["artillery-targeting-remotes"] and settings.startup["artillery-targeting-remotes"].value and data.raw["selection-tool"]["artillery-bombardment-remote"] and data.raw["selection-tool"]["smart-artillery-bombardment-remote"] and data.raw["selection-tool"]["smart-artillery-exploration-remote"] then
	data:extend({
		{
			type = "shortcut",
			name = "artillery-bombardment-remote",
			localised_name = {"", artillery_bombardment_remote, {"item-name.artillery-bombardment-remote"}},
			order = "d[artillery]-e[artillery-bombardment-remote]",
			action = "lua",
			icon = data.raw["selection-tool"]["artillery-bombardment-remote"].icons[1].icon,
			icon_size = 32,
			small_icon = data.raw["selection-tool"]["artillery-bombardment-remote"].icons[1].icon,
			small_icon_size = 32
		},
		{
			type = "shortcut",
			name = "smart-artillery-bombardment-remote",
			localised_name = {"", smart_artillery_bombardment_remote, {"item-name.smart-artillery-bombardment-remote"}},
			order = "d[artillery]-e[smart-artillery-bombardment-remote]",
			action = "lua",
			icon = data.raw["selection-tool"]["smart-artillery-bombardment-remote"].icons[1].icon,
			icon_size = 32,
			small_icon = data.raw["selection-tool"]["smart-artillery-bombardment-remote"].icons[1].icon,
			small_icon_size = 32
		},
		{
			type = "shortcut",
			name = "smart-artillery-exploration-remote",
			localised_name = {"", smart_artillery_exploration_remote, {"item-name.smart-artillery-exploration-remote"}},
			order = "d[artillery]-f[smart-artillery-exploration-remote]",
			action = "lua",
			icon = data.raw["selection-tool"]["smart-artillery-exploration-remote"].icons[1].icon,
			icon_size = 32,
			small_icon = data.raw["selection-tool"]["smart-artillery-exploration-remote"].icons[1].icon,
			small_icon_size = 32
		}
	})
end


-- TOGGLE ARTILLERY CANNON FIRE
local artillery_toggle = settings.startup["artillery-toggle"].value
if artillery_toggle == "both" or artillery_toggle == "artillery-wagon" or artillery_toggle == "artillery-turret" then

	local disable_turret_list = {}
	if artillery_toggle == "both" then
		disable_turret_list = {"artillery-wagon", "artillery-turret"}
	else
		disable_turret_list = {artillery_toggle}
	end

	data:extend({
		{
			type = "shortcut",
			name = "artillery-jammer-tool",
			localised_name = {"", artillery_turret, {"item-name.artillery-jammer-tool"}},
			order = "d[artillery]-g[artillery-jammer-tool]",
			action = "lua",
			style = "red",
			icon = "__Shortcuts-ick__/graphics/artillery-jammer-tool-x32-white.png",
			icon_size = 32,
			small_icon = "__Shortcuts-ick__/graphics/artillery-jammer-tool-x24-white.png",
			small_icon_size = 24
		},
		{
			type = "selection-tool",
			name = "artillery-jammer-tool",
			subgroup = "tool",
			order = "c[automated-construction]-a[artillery-jammer-tool]",
			icon = "__Shortcuts-ick__/graphics/artillery-jammer-tool-red.png",
			icon_size = 32,
			flags = {"only-in-cursor", "not-stackable"},
			hidden = true,
			stack_size = 1,
			select = {
				mode = "blueprint",
				entity_type_filters = disable_turret_list,
				tile_filters = {"tile-unknown"},
				cursor_box_type = "not-allowed",
				border_color = {r = 1, g = 0, b = 0}
			},
			alt_select = {
				mode = "blueprint",
				entity_type_filters = disable_turret_list,
				tile_filters = {"tile-unknown"},
				cursor_box_type = "not-allowed",
				border_color = {r = 1, g = 0, b = 0}
			}
		}
	})
end

-- MIRV
if mods["MIRV"] and data.raw.capsule["mirv-targeting-remote"] and settings.startup["mirv-targeting-remote"].value then
	data:extend({{
		type = "shortcut",
		name = "mirv-targeting-remote",
		localised_name = {"", mirv_targeting_remote, ": [/color]", {"item-name.mirv-targeting-remote"}},
		order = "d[artillery]-h[mirv-targeting-remote]",
		action = "lua",
		style = "red",
		icon = "__Shortcuts-ick__/graphics/mirv-targeting-remote-x32-white.png",
		icon_size = 32,
		small_icon = "__Shortcuts-ick__/graphics/mirv-targeting-remote-x24-white.png",
		small_icon_size = 24
	}})
end

-- ATOMIC ARTILLERY
if mods["AtomicArtilleryRemote"] and settings.startup["atomic-artillery-targeting-remote"].value then
	data:extend({{
		type = "shortcut",
		name = "atomic-artillery-targeting-remote",
		localised_name = {"", atomic_artillery_targeting_remote, {"item-name.atomic-artillery-targeting-remote"}},
		order = "d[artillery]-i[atomic-artillery-targeting-remote]",
		action = "lua",
		style = "red",
		icon = "__Shortcuts-ick__/graphics/mirv-targeting-remote-x32-white.png",
		icon_size = 32,
		small_icon = "__Shortcuts-ick__/graphics/mirv-targeting-remote-x24-white.png",
		small_icon_size = 24
	}})
end

-- LAND MINE THROWER
if mods["landmine-thrower"] and data.raw.capsule["landmine-thrower-remote"] and settings.startup["landmine-thrower-remote"].value then
	data:extend({{
		type = "shortcut",
		name = "landmine-thrower-remote",
		localised_name = {"", landmine_thrower_remote, {"item-name.landmine-thrower-remote"}},
		order = "d[artillery]-j[landmine-thrower-remote]",
		action = "lua",
		style = "red",
		icon = "__Shortcuts-ick__/graphics/landmine-thrower-remote-x24-white.png",
		icon_size = 24
	}})
end
