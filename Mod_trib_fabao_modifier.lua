local tbTable = GameMain:GetMod("_ModifierScript");
local tbModifier = tbTable:GetModifier("Mod_trib_fabao_class_2");

local baseCondemn = 0;
local baseSpellPowerAddP = 0;
local baseSpellLingCostAddP = 0;
local baseSpellCastTimeAddP = 0;
local baseSpellCoolDownAddP = 0;
local baseFightSkillSoul = 0;

function tbModifier:Enter(modifier, npc)
	--print("MOD_MODIF: modifier enter :");

	self.data = self.data or {};

	if npc == nil or npc.IsDeath then
		return;
	end

	baseCondemn = npc.PropertyMgr.Practice:GetPenalty();
	baseSpellPowerAddP = npc:GetProperty("NpcFight_SpellPowerAddP");
	baseSpellLingCostAddP = npc:GetProperty("NpcFight_SpellLingCostAddP");
	baseSpellCastTimeAddP = npc:GetProperty("NpcFight_SpellCastTimeAddP");
	baseSpellCoolDownAddP = npc:GetProperty("NpcFight_SpellCoolDownAddP");
	baseFightSkillSoul = npc:GetProperty("NpcFight_FightSkillSoul");

	--print("MOD_MODIF: base condemnation =", baseCondemn);
	--print("MOD_MODIF: base SpellPowerAddP =", baseSpellPowerAddP);
	--print("MOD_MODIF: base SpellLingCostAddP =", baseSpellLingCostAddP);
	--print("MOD_MODIF: base SpellCastTimeAddP =", baseSpellCastTimeAddP);
	--print("MOD_MODIF: base SpellCoolDownAddP =", baseSpellCoolDownAddP);
	--print("MOD_MODIF: base FightSkillSoul =", baseFightSkillSoul);

	npc.PropertyMgr:ModifierProperty("NpcFight_SpellPowerAddP", 0.0, (baseCondemn * 7));
	npc.PropertyMgr:ModifierProperty("NpcFight_SpellLingCostAddP", 0.0, (baseCondemn * (-0.07)));
	npc.PropertyMgr:ModifierProperty("NpcFight_SpellCastTimeAddP", 0.0, (baseCondemn * (-0.07)));
	npc.PropertyMgr:ModifierProperty("NpcFight_SpellCoolDownAddP", 0.0, -(baseCondemn * (-0.07)));
	npc.PropertyMgr:ModifierProperty("NpcFight_FightSkillSoul", 1, 0);
	
	--print("MOD_MODIF: new SpellPowerAddP =", npc:GetProperty("NpcFight_SpellPowerAddP"));
	--print("MOD_MODIF: new SpellLingCostAddP =", npc:GetProperty("NpcFight_SpellLingCostAddP"));
	--print("MOD_MODIF: new SpellCastTimeAddP =", npc:GetProperty("NpcFight_SpellCastTimeAddP"));
	--print("MOD_MODIF: new SpellCoolDownAddP =", npc:GetProperty("NpcFight_SpellCoolDownAddP"));
	--print("MOD_MODIF: new FightSkillSoul =", npc:GetProperty("NpcFight_FightSkillSoul"));

end


function tbModifier:Step(modifier, npc, dt)
	----print("MOD_MODIF: modifier step :");

	if npc == nil or npc.IsDeath then
		return;
	end
	
	if self.data.kill == true then
		modifier.Duration = 0.01;
		--print("MOD_MODIF: kill", self)
	end

	if baseCondemn ~= npc.PropertyMgr.Practice:GetPenalty() then
		--print("MOD_MODIF: base condemnation =", baseCondemn);
		--print("MOD_MODIF: new condemnation =", npc.PropertyMgr.Practice:GetPenalty());
		self:Leave(modifier, npc)
		self:Enter(modifier, npc)
	end

end

function tbModifier:OnGetSaveData()
	--print("MOD_MODIF: modifier save data :");

	return self.data;
end

function tbModifier:OnLoadData(modifier, npc, tbData)
	--print("MOD_MODIF: modifier load data :");

	self.data = tbData;
	
	baseCondemn = npc.PropertyMgr.Practice:GetPenalty();
	
	self:Leave(modifier, npc)
	self:Enter(modifier, npc)
end

function tbModifier:Leave(modifier, npc)
	--print("MOD_MODIF: modifier exit :");

	if npc == nil or npc.IsDeath then
		return;
	end

	--print("MOD_MODIF: new SpellPowerAddP =", npc:GetProperty("NpcFight_SpellPowerAddP"));
	--print("MOD_MODIF: new SpellLingCostAddP =", npc:GetProperty("NpcFight_SpellLingCostAddP"));
	--print("MOD_MODIF: new SpellCastTimeAddP =", npc:GetProperty("NpcFight_SpellCastTimeAddP"));
	--print("MOD_MODIF: new SpellCoolDownAddP =", npc:GetProperty("NpcFight_SpellCoolDownAddP"));
	--print("MOD_MODIF: new FightSkillSoul =", npc:GetProperty("NpcFight_FightSkillSoul"));

	npc.PropertyMgr:ModifierProperty("NpcFight_SpellPowerAddP", 0.0, -(baseCondemn * 7));
	npc.PropertyMgr:ModifierProperty("NpcFight_SpellLingCostAddP", 0.0, -(baseCondemn * (-0.07)));
	npc.PropertyMgr:ModifierProperty("NpcFight_SpellCastTimeAddP", 0.0, -(baseCondemn * (-0.07)));
	npc.PropertyMgr:ModifierProperty("NpcFight_SpellCoolDownAddP", 0.0, (baseCondemn * (-0.07)));
	npc.PropertyMgr:ModifierProperty("NpcFight_FightSkillSoul", -1, 0);

	--print("MOD_MODIF: base SpellPowerAddP =", npc:GetProperty("NpcFight_SpellPowerAddP"));
	--print("MOD_MODIF: base SpellLingCostAddP =", npc:GetProperty("NpcFight_SpellLingCostAddP"));
	--print("MOD_MODIF: base SpellCastTimeAddP =", npc:GetProperty("NpcFight_SpellCastTimeAddP"));
	--print("MOD_MODIF: base SpellCoolDownAddP =", npc:GetProperty("NpcFight_SpellCoolDownAddP"));
	--print("MOD_MODIF: base FightSkillSoul =", npc:GetProperty("NpcFight_FightSkillSoul"));

end
