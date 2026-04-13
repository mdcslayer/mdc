local tbTable = GameMain:GetMod("_FabaoHelper");

function tbTable:OnEnter()

end

function tbTable:OnLeave()

end

function tbTable:FabaoActivePenalty()

	--print("MOD_ACTIVATEFABAO: func entry :");
	--print("MOD_ACTIVATEFABAO: condemnation =",  me:GetGodPenalty());

	local itName = it:GetName();
	--print("MOD_ACTIVATEFABAO: artifact name =", itName);
	local cultName = me.npcObj:GetName();
	--print("MOD_ACTIVATEFABAO: cultivator name =", cultName);

	if me:GetGodPenalty() >= 100 then
		--print("MOD_ACTIVATEFABAO: activation condition OK");
		CS.XiaWorld.FabaoEventMgr.SetFabaoActive(it, CS.XiaWorld.FabaoEvenType.Other, 1);
		WorldLua:ShowMsgBox(string.format(XT("%s sensed enough Condemnation in %s."), tostring(itName), tostring(cultName)), XT("Sense Condemnation"));
	else
		--print("MOD_ACTIVATEFABAO: activation condition KO");
		WorldLua:ShowMsgBox(string.format(XT("%s did not sense enough Condemnation in %s."), tostring(itName), tostring(cultName)), XT("Sense Condemnation"));
	end

	--print("MOD_ACTIVATEFABAO: func exit :");

	return false;
end
