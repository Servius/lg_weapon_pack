
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "cod-tac-insert" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:GetOwner(self.TacOwner)
	return ent
	
end

function ENT:Initialize()
	
	self.Entity:SetModel( "models/hoff/weapons/tac_insert/w_tac_insert.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:DrawShadow(false)
	self.Entity:SetMaxHealth(5)
	self.Entity:SetHealth(5)
	local phys = self.Entity:GetPhysicsObject()
	
		  if (phys:IsValid()) then
			phys:Wake()
		  end
		self.Hit = false
		
	self:SetDTFloat( 0, math.Rand( 0.5, 1.3 ) )
	self:SetDTFloat( 1, math.Rand( 0.3, 1.2 ) )
	
end

function ENT:SetupDataTables()

	self:DTVar( "Float", 0, "RotationSeed1" )
	self:DTVar( "Float", 1, "RotationSeed2" )

end

ENT.HealthAmnt = 75
-- from ttt
local zapsound = Sound("npc/assassin/ball_zap1.wav")

 function ENT:OnTakeDamage(dmg)
 
	self:TakePhysicsDamage(dmg)
 
	if(self.HealthAmnt <= 0) then return end
 
	self.HealthAmnt = self.HealthAmnt - dmg:GetDamage()
 
	if(self.HealthAmnt <= 0) then
	
	  local effect = EffectData()
      effect:SetStart(self:GetPos())
      effect:SetOrigin(self:GetPos())
      util.Effect("cball_explode", effect, true, true)

	
	
      sound.Play(zapsound, self:GetPos(), 100, 100)
		self:Remove()
	end
 end

function ENT:Use( activator, caller )
end

function ENT:Think()

end


