AddCSLuaFile()

ENT.Base = "base_anim"
ENT.DisableDuplicator = true
ENT.PhysgunDisabled = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/maxofs2d/hover_plate.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetMaxHealth(75)
		self:SetHealth(75)
		self:DropToFloor()
	end

	function ENT:OnTakeDamage(dmg)
		self:SetHealth(self:Health() - dmg:GetDamage())

		if self:Health() <= 0 then
			local effect = EffectData()
			effect:SetOrigin(self:GetPos())

			util.Effect("cball_explode", effect)
			self:EmitSound("npc/assassin/ball_zap1.wav")

			self:Remove()
		end
	end

	function ENT:Use(activator)
		if activator == self:GetCreator() then
			activator:Give("weapon_personal_spawnpad")
			self:EmitSound("buttons/lever7.wav")
			self:Remove()
		end
	end
else
	local beam = Material("models/props_combine/portalball001_sheet")
	local vector_offset = Vector(0, 0, 30)

	function ENT:Draw()
		self:DrawModel()

		local pos = self:GetPos()

		render.SetMaterial(beam)
		render.DrawBeam(pos, pos + vector_offset, 9, 0, 0.9, color_white)
	end
end