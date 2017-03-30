include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Draw()

	self:DrawShadow( false )
	
	self.Entity:DrawModel()

end

local Laser = Material( "cable/hydra" )
 
function ENT:Draw()
 
	self:DrawModel() 
 
	local Vector1 = self:GetPos() + self:GetRight() * -4.5
	local Vector2 = self:GetPos() + self:GetRight() * -4.5 + Vector(0,0,40)
 
	render.SetMaterial( Laser )
	render.DrawBeam( Vector1, Vector2, 17, 1, 1, Color( 128, 199, 103, 255 ) ) 
  
end 

surface.CreateFont( "Arialf", { font = "Arial", antialias = true, size = 35 } )


hook.Add("HUDPaint","TacInsertText",function()

		local visible_entity = LocalPlayer():GetEyeTrace().Entity
		if visible_entity:IsValid() then		 
			if LocalPlayer():GetEyeTrace().Entity then
				local entityClass = visible_entity:GetClass()
				local player_to_entity_distance = LocalPlayer():GetPos():Distance(visible_entity:GetPos())
				if (entityClass  == 'cod-tac-insert') then
					draw.DrawText(visible_entity:GetNWString("TacOwner").."'s Tactical Insertion", "Arialf", ScrW()/2, ScrH()/2+150, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)							
				end
			end
		end
end)