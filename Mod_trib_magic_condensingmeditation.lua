local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Mod_trib_magic_class_2");

local baseDingLuLevel = 0;
local addedPenalty = 0;


function tbMagic:Init()
	--self.data = self.data or {};
end


function tbMagic:TargetCheck(k, t)
	return true;
end


function tbMagic:MagicEnter(IDs, IsThing)
	local npcLua = self.bind.LuaHelper;

	-- suspend qi regen and practice
	self.bind:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_NOLING, 1)
	self.bind:AddSpecialFlag(g_emNpcSpecailFlag.FLAG_PRACTICEDIE, 1)

	-- init condemnation
	baseDingLuLevel = self.bind.PropertyMgr.Practice:GetDingLuLevel();
	addedPenalty = baseDingLuLevel + 1;

	--print("MOD_MAGIC: magic enter :");
	--print("MOD_MAGIC: added penalty =", addedPenalty);
	--print("MOD_MAGIC: FLAG_NOLING exists =", self.bind:CheckSpecialFlag(g_emNpcSpecailFlag.FLAG_NOLING));
	--print("MOD_MAGIC: FLAG_NOLING value =", self.bind:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_NOLING));
	--print("MOD_MAGIC: FLAG_PRACTICEDIE exists =", self.bind:CheckSpecialFlag(g_emNpcSpecailFlag.FLAG_PRACTICEDIE));
	--print("MOD_MAGIC: FLAG_PRACTICEDIE value =", self.bind:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_PRACTICEDIE));

end


--ret : 0 continue ; 1 stop OK ; -1  stop ERR
function tbMagic:MagicStep(dt, duration)
	-- consume qi to fill the inner cauldron
	-- the rate is around 1/(10*(inner cauldron level + 1))
	self:SetProgress(1);
	local npcLua = self.bind.LuaHelper;
	local maxQi = npcLua:GetProperty("NpcLingMaxValue");
	local consumedLing = maxQi / self.magic.Param2;
	local maxInnerQi = self.bind.PropertyMgr.Practice:GetMaxAccumulativeLing();
	local usedQiCoeff =  self.magic.Param3 - (baseDingLuLevel / 100);

	if npcLua:GetGLevel() > 6 then
		maxInnerQi = (self.bind.PropertyMgr.Practice.AccumulativeLing + (consumedLing * usedQiCoeff)) + 1;
		usedQiCoeff = (self.magic.Param3 - ((npcLua:GetGLevel() / 100) - (2 * npcLua:GetGLevel() / 1000))) / 10;
		addedPenalty =  npcLua:GetGLevel();
		consumedLing = maxQi / (self.magic.Param2 * (npcLua:GetGLevel() / 2));
	end

	--print("MOD_MAGIC: magic step :");
	--print("MOD_MAGIC: dt =", dt);
	--print("MOD_MAGIC: Param1 =", self.magic.Param1);
	--print("MOD_MAGIC: Param2 =", self.magic.Param2);
	--print("MOD_MAGIC: Param3 =", self.magic.Param3);
	--print("MOD_MAGIC: curr Qi =", self.bind.LingV);
	--print("MOD_MAGIC: consummed Qi =", consumedLing);
	--print("MOD_MAGIC: Qi coeff =", usedQiCoeff);
	--print("MOD_MAGIC: added Qi (cauldron and max) =", (consumedLing * usedQiCoeff));
	--print("MOD_MAGIC: max Qi =", npcLua:GetProperty("NpcLingMaxValue"));
	--print("MOD_MAGIC: cauldron Qi =", self.bind.PropertyMgr.Practice.AccumulativeLing);

	if self.bind.LingV < consumedLing then
		return -1;	
	end

	self.bind:AddLing(-consumedLing);

	if (self.bind.PropertyMgr.Practice.AccumulativeLing + (consumedLing * usedQiCoeff)) < maxInnerQi then 
		self.bind.PropertyMgr.Practice.AccumulativeLing = self.bind.PropertyMgr.Practice.AccumulativeLing + (consumedLing * usedQiCoeff);
		npcLua:ModifierProperty("NpcLingMaxValue", (consumedLing *usedQiCoeff), 0.0);
	else
		self.bind.PropertyMgr.Practice.AccumulativeLing = maxInnerQi;
		npcLua:ModifierProperty("NpcLingMaxValue", (maxInnerQi - self.bind.PropertyMgr.Practice.AccumulativeLing), 0.0);
		addedPenalty = 5;
		--print("MOD_MAGIC: filled cauldron !");
		return 1;
	end

	if self.bind.PropertyMgr.Practice:GetDingLuLevel() ~= baseDingLuLevel then
		baseDingLuLevel = self.bind.PropertyMgr.Practice:GetDingLuLevel()
		addedPenalty = baseDingLuLevel + 1;
	end

	--print("MOD_MAGIC: new max Qi =", npcLua:GetProperty("NpcLingMaxValue"));
	--print("MOD_MAGIC: new cauldron Qi =", self.bind.PropertyMgr.Practice.AccumulativeLing);
	--print("MOD_MAGIC: added penalty =", addedPenalty);

	if self.bind.LingV <= 0 then
		return 1;	
	end

	return 0;
end

function tbMagic:MagicLeave(success)
	local npcLua = self.bind.LuaHelper;

	-- restore qi regen and practice
	self.bind:SubSpecialFlag(g_emNpcSpecailFlag.FLAG_NOLING, 1)
	self.bind:SubSpecialFlag(g_emNpcSpecailFlag.FLAG_PRACTICEDIE, 1)

	-- add condemnation
	npcLua:AddPenalty(addedPenalty);
	
	--print("MOD_MAGIC: magic exit :");
	--print("MOD_MAGIC: ", self.bind);
	--print("MOD_MAGIC: inner cauldron level =", self.bind.PropertyMgr.Practice:GetDingLuLevel());
	--print("MOD_MAGIC: added penalty =", addedPenalty);
	--print("MOD_MAGIC: FLAG_NOLING exists =", self.bind:CheckSpecialFlag(g_emNpcSpecailFlag.FLAG_NOLING));
	--print("MOD_MAGIC: FLAG_NOLING value =", self.bind:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_NOLING));
	--print("MOD_MAGIC: FLAG_PRACTICEDIE exists =", self.bind:CheckSpecialFlag(g_emNpcSpecailFlag.FLAG_PRACTICEDIE));
	--print("MOD_MAGIC: FLAG_PRACTICEDIE value =", self.bind:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_PRACTICEDIE));

end

function tbMagic:OnGetSaveData()
	return nil;	
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)	
	
end
