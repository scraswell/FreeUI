local F, C, L = unpack(select(2, ...))

local function InitStyleWA()
	local function Skin_WeakAuras(f, fType)
		if fType == "icon" then
			if not f.styled then
				f.icon:SetTexCoord(.08, .92, .08, .92)
				f.icon.SetTexCoord = F.dummy
				F.CreateBD(f, 0)
				F.CreateSD(f)
				f.styled = true
			end
		elseif fType == "aurabar" then
			if not f.styled then
				f.icon:SetTexCoord(.08, .92, .08, .92)
				f.icon.SetTexCoord = F.dummy
				F.CreateSD(f.bar)
				f.iconFrame:SetAllPoints(f.icon)
				F.CreateSD(f.iconFrame)
				f.styled = true
			end
		end
	end

	local regionTypes = WeakAuras.regionTypes
	local Create_Icon, Modify_Icon = regionTypes.icon.create, regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = regionTypes.aurabar.create, regionTypes.aurabar.modify

	regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, "icon")
		return region
	end

	regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, "aurabar")
		return region
	end

	regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, "icon")
	end

	regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, "aurabar")
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		local regions = WeakAuras.regions[weakAura]
		if regions.regionType == "icon" then
			Skin_WeakAuras(regions.region, regions.regionType)
		end
	end
end

if IsAddOnLoaded("WeakAuras") then
	InitStyleWA()
else
	local load = CreateFrame("Frame")
	load:RegisterEvent("ADDON_LOADED")
	load:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "WeakAuras" then return end
		self:UnregisterEvent("ADDON_LOADED")

		InitStyleWA()

		load = nil
	end)
end
