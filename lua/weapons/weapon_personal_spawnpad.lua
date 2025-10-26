AddCSLuaFile()

SWEP.PrintName = "Personal Spawnpad"
SWEP.Spawnable = true

SWEP.Slot = 3
SWEP.SlotPos = 4
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModelFOV = 70
SWEP.ViewModel = "models/maxofs2d/hover_plate.mdl"
SWEP.WorldModel = "models/maxofs2d/hover_plate.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType("slam")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 1)

	if CLIENT then return end
	timer.Simple(0.0, function() if self:IsValid() then self:EmitSound("npc/turret_floor/click1.wav", 55, math.random(100, 105)) end end)
	timer.Simple(0.2, function() if self:IsValid() then self:EmitSound("garrysmod/ui_click.wav", 100, math.random(120, 150)) end end)
	timer.Simple(0.4, function() if self:IsValid() then self:EmitSound("garrysmod/ui_click.wav", 100, math.random(120, 150)) end end)
	timer.Simple(0.6, function() if self:IsValid() then self:EmitSound("garrysmod/ui_click.wav", 100, math.random(120, 150)) end end)
	timer.Simple(0.8, function() if self:IsValid() then self:EmitSound("buttons/lever7.wav", 55, math.random(100, 105)) end end)
	timer.Simple(1.0, function()
		if not self:IsValid() then return end

		local owner = self:GetOwner()
		if not owner:IsValid() or not owner:IsPlayer() then return end
		if IsValid(owner.Spawnpad) then owner.Spawnpad:Remove() owner.Spawnpad = nil end

		local spawnpad = ents.Create("personal_spawnpad")
		owner:AddCleanup("sents", spawnpad)
		owner.Spawnpad = spawnpad

		spawnpad:SetPos(owner:GetPos())
		spawnpad:SetCreator(owner)
		spawnpad:Spawn()

		self:Remove()
	end)
end

function SWEP:SecondaryAttack()

end

hook.Add("PlayerSelectSpawn", "PersonalSpawnpads", function(ply)
	if IsValid(ply.Spawnpad) then
		return ply.Spawnpad
	end
end)

if CLIENT then
	function SWEP:GetViewModelPosition(pos, ang)
		pos:Add(14 * ang:Right())
		pos:Add(24 * ang:Forward())
		pos:Add(-8 * ang:Up())

		ang:RotateAroundAxis(ang:Up(), 160)
		ang:RotateAroundAxis(ang:Right(), -70)
		ang:RotateAroundAxis(ang:Forward(), 10)

		return pos, ang
	end

	function SWEP:DrawWorldModel(flags)
		local owner = self:GetOwner()

		if owner:IsValid() then
			local bone = owner:LookupBone("ValveBiped.Bip01_R_Hand")

			if bone then
				local pos, ang = owner:GetBonePosition(bone)
				pos:Add(ang:Forward() * 9)
				pos:Add(ang:Right() * 2.5)
				pos:Add(ang:Up() * -6)

				ang:RotateAroundAxis(ang:Up(), -37)
				ang:RotateAroundAxis(ang:Right(), 145)
				ang:RotateAroundAxis(ang:Forward(), 28)

				self:SetPos(pos)
				self:SetAngles(ang)
				self:SetupBones()
			end
		end

		self:DrawModel(flags)
	end
end
