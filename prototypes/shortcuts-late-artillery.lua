-- TAGS

-- ADVANCED ARTILLERY REMOTES CONTINUED
local artillery_cluster_remote = ""
local artillery_discovery_remote = ""

if settings.startup["ick-tags"].value == "tags" then
	local tag = {"", "[color=red]", {"technology-name.artillery"}, ": [/color]"}

	-- ADVANCED ARTILLERY REMOTES CONTINUED
	artillery_cluster_remote = tag
	artillery_discovery_remote = tag

elseif settings.startup["ick-tags"].value == "icons" then

	-- ADVANCED ARTILLERY REMOTES CONTINUED
	artillery_cluster_remote = "[img=item/artillery-cluster-remote-artillery-shell] "
	artillery_discovery_remote = "[img=item/artillery-discovery-remote] "

end

-- ADVANCED ARTILLERY REMOTES CONTINUED
-- Mod initialises cluster remotes during data-updates phase, which requires initialising the shortcut during the same phase and use of hidden dependency to ensure load order.
if settings.startup["artillery-targeting-remote"].value and data.raw.capsule["artillery-cluster-remote-artillery-shell"] and data.raw.capsule["artillery-discovery-remote"] then
	data:extend({
		{
			type = "shortcut",
			name = "artillery-cluster-remote-artillery-shell",
			localised_name = {"", artillery_cluster_remote, data.raw.capsule["artillery-cluster-remote-artillery-shell"].localised_name },
			order = "d[artillery]-b[artillery-cluster-remote-artillery-shell]",
			action = "lua",
			style = "red",
			icon = {
				filename = "__Shortcuts-ick__/graphics/artillery-cluster-remote-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 0.5,
				flags = {"gui-icon"}
			}
		},
		{
			type = "shortcut",
			name = "artillery-discovery-remote",
			localised_name = {"", artillery_discovery_remote, {"item-name.artillery-discovery-remote"}},
			order = "d[artillery]-c[artillery-discovery-remote]",
			action = "lua",
			style = "red",
			icon = {
				filename = "__Shortcuts-ick__/graphics/artillery-discovery-remote-x32-white.png",
				priority = "extra-high-no-scale",
				size = 32,
				scale = 0.5,
				flags = {"gui-icon"}
			}
		}
	})
end
