--[[ Copyright (c) 2021 npc_strider, ickputzdirwech
    * Original mod by npc_strider.
    * For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
    * This mod may contain modified code sourced from base/core Factorio.
    * This mod has been modified by ickputzdirwech.
]]

--[[ Overview custom-inputs-updates.lua:
    * Generation of custom inputs.
]]

local shortcuts = {
    "artillery-targeting-remote",
    "artillery-jammer-tool",
    "artillery-cluster-remote",
    "artillery-discovery-remote",
    "mirv-targeting-remote",
    "landmine-thrower-remote",
    "ion-cannon-targeter",

    "flashlight-toggle",
    "signal-flare",
    "draw-grid",
    "rail-block-visualization-toggle",
    "big-zoom",

    "environment-killer",
    "tree-killer",
    "cliff-fish-item-on-ground",
    "well-planner",

    "belt-immunity-equipment",
    "discharge-defense-remote",
    "night-vision-equipment",
    "active-defense-equipment",

    "driver-is-gunner",
    "spidertron-remote",
    "spidertron-logistics",
    "spidertron-logistic-requests",
    "targeting-with-gunner",
    "targeting-without-gunner",
    "train-mode-toggle",
    "winch"
}

for _, name in pairs(shortcuts) do
    if data.raw.shortcut[name] then
        data:extend(
        {
            {
            type = "custom-input",
            name = data.raw.shortcut[name].name,
            localised_name = data.raw.shortcut[name].localised_name,
            order = data.raw.shortcut[name].order,
            key_sequence = ""
            }
        })
        table.insert(data.raw.shortcut[name].localised_name, " ")
        table.insert(data.raw.shortcut[name].localised_name, {"Shortcuts-ick.control", name})
    end
end
