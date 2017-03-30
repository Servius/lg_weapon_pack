

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "DC-15 Side Arm"			
	SWEP.Author				= "Syntax_Error752"
	SWEP.ViewModelFOV      	= 70
	SWEP.Slot				= 1
	SWEP.SlotPos			= 5
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/killicons/DC15SA")
	
	killicon.Add( "weapon_752_dc15sa", "HUD/killicons/DC15SA", Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType				= "pistol"
SWEP.Base					= "tfa_swsft_base"

SWEP.Category = "TFA Star Wars"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/weapons/v_DC15SA.mdl"
SWEP.WorldModel				= "models/weapons/w_DC15SA.mdl"

SWEP.Primary.Sound = Sound ("weapons/DC15SA_fire.wav");

local MaxTimer				=64
local CurrentTimer			=0
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.Recoil			= 0.5SWEP.Primary.PenetrationMultiplier = 0 --Change the amount of something this gun can penetrate through
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Spread			= 0.0125
SWEP.Primary.ClipSize		= 8
SWEP.Primary.RPM = 60/0.2
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "battery"
SWEP.TracerName = "effect_sw_laser_blue"

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 			= Vector (-3.9, -6, 2.5)
SWEP.IronSightsAng 			= Vector (-0.3, -0.05, 0)

function SWEP:Think()
	if (self.Weapon:Clip1() < self.Primary.ClipSize) and SERVER then
		if (CurrentTimer <= 0) then 
			CurrentTimer = MaxTimer
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		else
			CurrentTimer = CurrentTimer-1
		end
	end
end

function SWEP:Reload()

end