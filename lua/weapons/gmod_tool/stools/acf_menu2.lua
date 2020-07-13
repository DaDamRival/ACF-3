TOOL.Name	  = "ACF Menu Test"
TOOL.Category = "Construction"

ACF.LoadToolFunctions(TOOL)

cleanup.Register("acfmenu")

if CLIENT then
	local DrawBoxes = GetConVar("acf_drawboxes")

	language.Add("Tool.acf_menu2.name", "Armored Combat Framework")
	language.Add("Tool.acf_menu2.desc", "Testing the new menu tool")

	function TOOL:DrawHUD()
		if not DrawBoxes:GetBool() then return end

		local Ent = LocalPlayer():GetEyeTrace().Entity

		if not IsValid(Ent) then return end
		if not Ent.HitBoxes then return end

		cam.Start3D()
		render.SetColorMaterial()

		for _, Tab in pairs(Ent.HitBoxes) do
			local BoxColor = Tab.Sensitive and Color(214, 160, 190, 50) or Color(160, 190, 215, 50)

			render.DrawBox(Ent:LocalToWorld(Tab.Pos), Ent:LocalToWorldAngles(Tab.Angle), Tab.Scale * -0.5, Tab.Scale * 0.5, BoxColor)
		end

		cam.End3D()
	end

	TOOL.BuildCPanel = ACF.BuildContextPanel

	concommand.Add("acf_reload_menu", function()
		if not IsValid(ACF.Menu) then return end

		ACF.BuildContextPanel(ACF.Menu.Panel)
	end)
end