
AddCSLuaFile( "shared.lua" )

SWEP.Author			= "Hoff"
SWEP.Instructions	= ""

SWEP.Category = "CoD Multiplayer"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/hoff/weapons/tac_insert/v_insert_seal6.mdl"
SWEP.WorldModel			= "models/hoff/weapons/tac_insert/w_tac_insert.mdl"
SWEP.ViewModelFOV = 65

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= ""
SWEP.Primary.Delay = 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Tactical Insertion"			
SWEP.Slot				= 3
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.Next = CurTime()
SWEP.Primed = 0

SWEP.Offset = {
Pos = {
Up = 0.2,
Right = 2,
Forward = 2,
},
Ang = {
Up = 240,
Right = 0,
Forward = 0,
}
}

function SWEP:DrawWorldModel( )
local hand, offset, rotate

if not IsValid( self.Owner ) then
self:DrawModel( )
return
end

if not self.Hand then
self.Hand = self.Owner:LookupAttachment( "anim_attachment_rh" )
end

hand = self.Owner:GetAttachment( self.Hand )

if not hand then
self:DrawModel( )
return
end

offset = hand.Ang:Right( ) * self.Offset.Pos.Right + hand.Ang:Forward( ) * self.Offset.Pos.Forward + hand.Ang:Up( ) * self.Offset.Pos.Up

hand.Ang:RotateAroundAxis( hand.Ang:Right( ), self.Offset.Ang.Right )
hand.Ang:RotateAroundAxis( hand.Ang:Forward( ), self.Offset.Ang.Forward )
hand.Ang:RotateAroundAxis( hand.Ang:Up( ), self.Offset.Ang.Up )

self:SetRenderOrigin( hand.Pos + offset )
self:SetRenderAngles( hand.Ang )

self:DrawModel( )
end

function SWEP:Deploy()
self:SetNWString("CanMelee",true)
self.Next = CurTime()
self.Primed = 0
self:SetNWString("HasUsed","false")
self.Owner.Tacs = self.Owner.Tacs or {}
end

function SWEP:Initialize()
self:SetWeaponHoldType("fist")
end

function SWEP:Equip(NewOwner)
end

function SWEP:Holster()
	self.Next = CurTime()
	self.Primed = 0
	return true
end

function SWEP:PrimaryAttack()
if self:GetNWString("clickclick") == "true" then return end
self:SetNWString("clickclick","true")

	if self.Next < CurTime() and self.Primed == 0 then
		self.Next = CurTime() + self.Primary.Delay
		
		if self.Owner:IsValid() and self.Owner:Alive() then
		timer.Simple(0.6,function() if self:IsValid() then self:EmitSound("hoff/mpl/seal_tac_insert/clip.wav") end end)
		
		timer.Simple(1.1,function() if self:IsValid() then self:EmitSound("hoff/mpl/seal_tac_insert/beep.wav") end end)
		timer.Simple(1.4,function() if self:IsValid() then self:EmitSound("hoff/mpl/seal_tac_insert/beep.wav") end end)
		
		
		timer.Simple(1.7,function() if self:IsValid() then self:EmitSound("hoff/mpl/seal_tac_insert/flick_1.wav") end end)
		timer.Simple(1.8,function() if self:IsValid() then self:EmitSound("hoff/mpl/seal_tac_insert/flick_2.wav") end end)
		
		self.Weapon:SendWeaponAnim(ACT_VM_PULLPIN)
		self.Primed = 1
		end
	end
end


function SWEP:SecondaryAttack()
end

function SWEP:DeployShield()
timer.Simple(0.4,function()
if self.Owner:Alive() and self.Owner:IsValid() then
-- thanks chief tiger
	local Owner = self.Owner
	if SERVER then
	for k, v in pairs( Owner.Tacs ) do
			timer.Simple( 0.1 * k, function()
			if IsValid( v ) then
				v:Remove()
			end				
			table.remove( Owner.Tacs, k )
		end )
	end	
end
end
if SERVER then
local ent = ents.Create("cod-tac-insert")
ent:SetPos(self.Owner:GetPos())
ent:Spawn()
ent.TacOwner = self.Owner
ent.Owner = self.Owner
ent:SetNWString("TacOwner",self.Owner:Nick())
ent:SetAngles(Angle(self.Owner:GetAngles().x,self.Owner:GetAngles().y,self.Owner:GetAngles().z) + Angle(0,-90,0))
table.insert( self.Owner.Tacs, ent )
end



end)

hook.Add("PlayerSpawn","TacSpawner",function( ply )
	if SERVER then
	if ply.Tacs == nil then ply.Tacs = {} end
	for k, v in pairs( ply.Tacs ) do
			timer.Simple( 0 * k, function()
			if IsValid( v ) then
				ply:SetPos(v:GetPos())
				ply:SetAngles(v:GetAngles())
			end				
		end )
	end
end

end)

timer.Simple(1,function() if IsValid(self.Weapon) then self.Weapon:Remove() end end)

end

function SWEP:SetNext()
if self.Next < CurTime() + 0.5 then return end 
self:SetNWString("HasUsed","true")
self.Next = CurTime()
end

function SWEP:Think()
	if self.Next < CurTime() then
		if self.Primed == 1 and not self.Owner:KeyDown(IN_ATTACK) then
			self.Primed = 2
			self:SetNext()			
		elseif self.Primed == 2 and CurTime() > self.Next + 2 then
			self.Primed = 0
			self:DeployShield()
			self.Weapon:SendWeaponAnim(ACT_VM_THROW)	
		end
	end
end

function SWEP:SecondaryAttack()
self:SetNextPrimaryFire(CurTime() + 1.1)
self:SetNextSecondaryFire(CurTime() + 1.2)
end

function SWEP:ShouldDropOnDie()
	return false
end
