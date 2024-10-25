--[[ Copyright (c) 2022 npc_strider, ickputzdirwech
	* Original mod by npc_strider.
	* For direct use of code or graphics, credit is appreciated and encouraged. See LICENSE.txt for more information.
	* This mod may contain modified code sourced from base/core Factorio.
	* This mod has been modified by ickputzdirwech.
]]

--[[ Overview of research-requirements-updates.lua:
	* General compatibility
]]

---------------------------------------------------------------------------------------------------
-- General compatibility
---------------------------------------------------------------------------------------------------
local function change_technology_to_unlock(shortcut, tech)
	if data.raw.shortcut[shortcut] then
		data.raw.shortcut[shortcut].technology_to_unlock = tech
	end
end

if settings.startup["ick-compatibility-mode"].value == false then
	change_technology_to_unlock("toggle-personal-logistic-requests", nil)
	change_technology_to_unlock("tree-killer", nil)
end
