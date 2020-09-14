local Ammo = ACF.RegisterAmmoType("APDS", "AP")

function Ammo:OnLoaded()
	Ammo.BaseClass.OnLoaded(self)

	self.Name		 = "Armor Piercing Discarging Sabot"
	self.Description = "A subcaliber munition designed to trade damage for penetration. Loses energy quickly over distance."
	self.Blacklist = ACF.GetWeaponBlacklist({
		AL = true,
		AC = true,
		SA = true,
		C = true,
	})
end

function Ammo:UpdateRoundData(ToolData, Data, GUIData)
	GUIData = GUIData or Data

	ACF.UpdateRoundSpecs(ToolData, Data, GUIData)

	local Cylinder  = (3.1416 * (Data.Caliber * 0.05) ^ 2) * Data.ProjLength * 0.5 -- A cylinder 1/2 the length of the projectile
	local Hole		= Data.RoundArea * Data.ProjLength * 0.25 -- Volume removed by the hole the dart passes through
	local SabotMass = (Cylinder - Hole) * 2.7 * 0.65 * 0.001 -- Aluminum sabot

	Data.ProjMass  = (Data.RoundArea * 0.6666) * (Data.ProjLength * 0.0079) -- Volume of the projectile as a cylinder * density of steel
	Data.MuzzleVel = ACF_MuzzleVelocity(Data.PropMass, Data.ProjMass + SabotMass)
	Data.DragCoef  = Data.RoundArea * 0.0001 / Data.ProjMass
	Data.CartMass  = Data.PropMass + Data.ProjMass + SabotMass

	for K, V in pairs(self:GetDisplayData(Data)) do
		GUIData[K] = V
	end
end

function Ammo:BaseConvert(_, ToolData)
	if not ToolData.Projectile then ToolData.Projectile = 0 end
	if not ToolData.Propellant then ToolData.Propellant = 0 end

	local Data, GUIData = ACF.RoundBaseGunpowder(ToolData, {})
	local SubCaliberRatio = 0.375 -- Ratio of projectile to gun caliber
	local Area = 3.1416 * (Data.Caliber * 0.05 * SubCaliberRatio) ^ 2

	Data.RoundArea	 = Area
	Data.ShovePower	 = 0.2
	Data.PenArea	 = Area ^ ACF.PenAreaMod
	Data.LimitVel	 = 950 --Most efficient penetration speed in m/s
	Data.KETransfert = 0.1 --Kinetic energy transfert to the target for movement purposes
	Data.Ricochet	 = 80 --Base ricochet angle

	self:UpdateRoundData(ToolData, Data, GUIData)

	return Data, GUIData
end

function Ammo:Network(Crate, BulletData)
	Ammo.BaseClass.Network(self, Crate, BulletData)

	Crate:SetNW2String("AmmoType", "APDS")
end

ACF.RegisterAmmoDecal("APDS", "damage/apcr_pen", "damage/apcr_rico")