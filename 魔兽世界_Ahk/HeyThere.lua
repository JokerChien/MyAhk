SLASH_HEYTHERE1 = "/hey" ;
SLASH_HEYTHERE2 = "/ht" ;
SlashCmdList["HEYTHERE"] = function()
   if(UnitExists("target")) then
      SendChatMessage("hello" .. UnitName("target"),"SAY");
   else
      MyFunction();
   end
end
--DEFAULT_CHAT_FRAME:AddMessage("我们全是大傻逼"); 
--print(GetBillingTimeRested());

function MyFunction()
   -- body
   --print(GetActionText(1));

   --print(GetActionCooldown(1));
   -- a,b,c,d,e=GetActionCooldown(1);
   -- print(GetTime()-a);
end

function HelloWorldCommand() 
   myFrame = getglobal("HelloWorldTestFrame"); 
   if(not myFrame:IsShown()) then 
      myFrame:Show();
      print("1.打开界面。2.打印技能。3.重置技能库。");
      InitializationSkillName();
   else 
      myFrame:Hide(); 
      print("关闭界面。");
   end
end

function HelloWorldLoad() 
   getglobal("HelloWorldTestFrame"):Hide(); 
   -- DEFAULT_CHAT_FRAME:AddMessage("HelloWorld is Loaded!"); 
   SLASH_HELLOWORLD1 = "/helloworld"; 
   SLASH_HELLOWORLD2 = "/hw"; 
   SlashCmdList["HELLOWORLD"] = HelloWorldCommand;
   print("欢迎来到无脑打怪的世界");
   setTimer={};--声明一些计时器
   attackMode=1;--申明攻击模式为0;1为单体攻击;2为AOE。
   party_Recover=0;
   skl_Can_Fire={};--声明一些计时器
   -- Test_Skill="冰霜之路";

   ----------------注册PLAYER_ENTERING_WORLD事件。因为不能初始化加载技能名称。----------------
   Init=getglobal("CoolDownMainFrame");
   Init:RegisterEvent("PLAYER_ENTERING_WORLD");
   Init:SetScript("OnEvent",function() InitializationSkillName();end);--定义事件加载函数。
   -- Init:UnregisterEvent("PLAYER_ENTERING_WORLD");--注销事件。
end 

function InitializationSkillName()
   SkNm={};
   for i=1,120 do
      skl_Can_Fire[i]=0;

      local _,getSpellID=GetActionInfo(i);
      if(getSpellID~=nil)then
         local name=GetSpellInfo(getSpellID);
         if(name~=nil) then
            SkNm[name]=i;
            print(i .. name);
         else
            name=GetActionText(i);
            SkNm[name]=i;
            print(i .. name);
         end
      end
   end
end

function HelloWorldFrameUpdate() 
   -- 10月16日 暴雪把所有距离判断的API都封掉了CheckInteractDistance() UnitInRange() IsActionInRange()，同时还把技能可用性判断、魔法消耗判断给封掉了。真是无语。
   text1 = getglobal("HelloWorldTestFrameSkillOneCD"); 
   text2 = getglobal("HelloWorldTestFrameTextDelay"); 
   text3 = getglobal("HelloWorldTestFrameTextMoney"); 

   -- text1:SetText(CheckInteractDistance("target", 2)==1 and "Yessss" or "Nooooooo");
   -- text4=getglobal("ActionButton1"); 
   -- local r, g, b, a = text4:GetTextColor();
   -- text1:SetText(r==nil and "Nooooooo" or "Yessss");
   -- local test={};
   -- test={["生命"]=100,["魔法"]=200};
   -- -- test={"生命","魔法"};
   -- for i,v in ipairs(test) do
   --    print(v);
   -- end
   -- text3:SetTextColor(|cFF00FF00|r);
   -- local isUsable, notEnoughMana = IsUsableAction(11);
   -- text1:SetText(isUsable==1 and "isUsable" or "notUsable");
   -- text2:SetText(notEnoughMana==1 and "notEnoughMana" or "EnoughMana");
   -- local _,getSpellID=GetActionInfo(11)
   -- text3:SetText(GetSpellInfo(getSpellID));
   -- local start, duration, enable = GetActionCooldown(1);
   -- local skillType, spellId = GetSpellBookItemInfo("冰冷触摸");
   -- local name, rank, icon, cost, isFunnel, spellRange, spellId = GetSpellInfo("暗影打击");
   -- text1:SetText(name .. ">>"..rank.. ">>"..icon.. ">>"..cost..">>"..isFunnel..">>"..spellRange..">>"..spellId);
   -- local usable, nomana = IsUsableSpell("凋零缠绕");
   -- if(usable==1) then text1:SetText("Yessss") else text1:SetText("Nooooooo") end;
   ------------------------------------打印区------------------------------------
   -- text1:SetText("SkillOneCD "..(start==0 and 0 or (duration - now + start)));
   -- text2:SetText(UnitCanAttack("player","target") and "Yessss" or "Nooooooo");
   -- text2:SetText(SkNm["凋零缠绕"] .. ";".. SkNm["冰冷触摸"] ..";".. SkNm["符文分流"]);
   -- local _,getSpellID=GetActionInfo(11);
   -- text2:SetText(GetSpellInfo(getSpellID)~=nil and GetSpellInfo(getSpellID) or GetActionText(11));
   -- local _,s_name=GetspecializationInfo(Getspecialization())
   -- text3:SetText(CheckInteractDistance("target",2) and "ok" or "no");
   -- local name, rank, icon, count, debuffType, duration, expirationTime = UnitDebuff("target",1, "PLAYER");

   ------------------------------------技能CD区------------------------------------
   actionButton_CDText={};
   skill_CD={};
   now=GetTime();
   for _,i in pairs(SkNm) do
      if(i>72 and i%12~=0)then
         actionButton_CDText[i]=getglobal("ActionButton" .. i%12 .. "CooldownTextCD"); --声明框架
      elseif(i>72 and i%12==0)then
         actionButton_CDText[i]=getglobal("ActionButton" .. 12 .. "CooldownTextCD"); --声明框架
      else
         actionButton_CDText[i]=getglobal("ActionButton" .. i .. "CooldownTextCD"); --声明框架
      end
      
      start, duration, enable = GetActionCooldown(i);
      skill_CD[i]=(start==0 and 0 or (duration - now + start)); --计算技能CD。如果START是0则技能无CD。
   end



   -- text2:SetText(GetUnitPitch("player"));
   -- text3:SetText(GetUnitPitch("target"));
   -- text2:SetText(playerAuraString);
   -- 获得当前天赋的信息。
   -- local id, name_tt, description, icon, background, role = GetspecializationInfo(Getspecialization());
   -- textDelay:SetText(name_tt);
   --计算玩家身上的所有BUFF和DEBUFF
   --TESTING
   -- if(IsCurrentAction(64)==1) then cout=now end;
   -- textMoney:SetText(cout==nil and "no" or floor(now-cout));
   -- textDelay:SetText((GetUnitSpeed("PLAYER") / 7) * 100);--可以判断在不在移动中。
   -- textMoney:SetText(GetUnitPitch("PLAYER")/7*100);
   -- textMoney:SetText(StringFindAnd("abcdefg","aaa","bbb") and "true" or "false");
   -- textDelay:SetText(n_RuneIsCD);
   -- local pet= UnitHealth("PLAYERPET");

   local _, specialization = GetSpecializationInfo(GetSpecialization());--获得玩家专精。
   -- local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura("target", 1,"HARMFUL");
   local debuffString=TargetDebuff(specialization);
   local playerAuraString=PlayerAura(specialization);
   local n_RuneIsCD=N_RuneIsCD();
   local playerHealth=UnitHealth("PLAYER")/UnitHealthMax("PLAYER");
   local ttIsPlayer=UnitIsUnit("targettarget", "player");
   local imChansting=WhoIsChansting("player");
   -- local imChansting=false;
   

   for _,i in pairs(SkNm) do  --这块主要负责技能刷颜色。
      actionButton_CDText[i]:SetTextColor(0,1,0);--先把所有技能刷成绿的。再看哪些要刷红。
      skl_Can_Fire[i]=1;   --先把所有技能的表置为1。

      AutoActionBar(i,specialization,playerAuraString,debuffString,n_RuneIsCD,setTimer,playerHealth,ttIsPlayer,now)

      local isUsable, notEnoughMana = IsUsableAction(i);
      if(imChansting and skill_CD[i]>0 or not imChansting and skill_CD[i]>0.3 or not isUsable or imChansting and i~=SkNm["目标"]) then 
         actionButton_CDText[i]:SetTextColor(1,0,0)
      end   --如果在技能范围之外则刷红。--如果技能CD刷红。--如果不可用刷红。--如果没有魔法刷红。--如果我在读施法条但不包括目标。
   end

   party_Recover=0;
   if(SkNm["队伍"]~=nil) then PaintPartyButton(SkNm["队伍"]) end;
   -- if(SkNm["冰霜新星"]~=nil) then actionButton_CDText[SkNm["冰霜新星"]]:SetTextColor(19/255,205/255,171/255) end;   十六进制和10进制切换 -- 13 CD AB
   -- party_Recover=0;
   -- if(specialization=="冰霜" or specialization=="鲜血") then    --死亡骑士的内置计时器。
   --    if(IsCurrentAction(SkNm["传染"])==1) then setTimer["传染"]=now end;--如果用了传染，则记录时间。注：已在HelloWorldLoad声明setTimer={}计时器。
   --    if(IsCurrentAction(SkNm["亡者复生"])==1) then setTimer["天灾契约"]=now end;--如果用了亡者复生，则记录时间。注：已在HelloWorldLoad声明setTimer={}计时器。
   --    if(IsCurrentAction(SkNm["天灾契约"]  )==1) then setTimer["天灾契约"]=nil end;--如果用了天灾契约，则消灭计时器。注：已在HelloWorldLoad声明setTimer={}计时器。
   -- else

   if(specialization=="戒律") then
      if(IsCurrentAction(SkNm["愈合祷言"])) then setTimer["愈合祷言"]=now end;--如果用了愈合祷言，则记录时间。注：已在HelloWorldLoad声明setTimer={}计时器。
   end

   local skl_Sequence_G=0;
   for i=1,4 do
      skl_Sequence_G=skl_Sequence_G + 2^(4-i)*skl_Can_Fire[i];
   end

   local skl_Sequence_B=0;
   -- local skl_Sequence_BS="";
   for i=5,12 do
      skl_Sequence_B=skl_Sequence_B + 2^(12-i)*skl_Can_Fire[i];
      -- skl_Sequence_BS=skl_Sequence_BS .. skl_Can_Fire[i];
   end
   if(SkNm["急救"]~=nil) then actionButton_CDText[SkNm["急救"]]:SetTextColor(0/255,skl_Sequence_G/255,skl_Sequence_B/255) end; --用急救技能来输出颜色。01-12

   local skl_Btn_Seq_R=0;
   for i=49,56 do
      skl_Btn_Seq_R=skl_Btn_Seq_R + 2^(56-i)*skl_Can_Fire[i];
   end

   local skl_Btn_Seq_G=0;
   for i=57,64 do
      skl_Btn_Seq_G=skl_Btn_Seq_G + 2^(64-i)*skl_Can_Fire[i];
   end

   local skl_Btn_Seq_B=0;
   for i=65,72 do
      skl_Btn_Seq_B=skl_Btn_Seq_B + 2^(72-i)*skl_Can_Fire[i];
   end

   if(SkNm["自动攻击"]~=nil) then actionButton_CDText[SkNm["自动攻击"]]:SetTextColor(skl_Btn_Seq_R/255,skl_Btn_Seq_G/255,skl_Btn_Seq_B/255) end; --用急救技能来输出颜色。01-12
   -- text1:SetText(skl_Sequence_B .. "   " .. skl_Sequence_BS);
   -- text1:SetText(skl_Sequence)

   -- text1:SetText(IsCurrentAction(SkNm["快速治疗"]) and "ok" or "no")
   -- if(IsCurrentAction(SkNm["开锁"])==1) then
   --    text2:SetText("单体攻击");
   -- elseif(IsCurrentAction(SkNm["队伍"])==1) then
   --    text2:SetText("群体攻击");
   -- end
end

function StringFindOr(stringSearched,...)
   local arg={...};
   local result=false;
   for i,v in ipairs(arg) do
      result=result or string.find(stringSearched,v)~=nil
   end
   return result
end

function StringFindAnd(stringSearched,...)
   local arg={...};
   local result=true;
   for i,v in ipairs(arg) do
      result=result and string.find(stringSearched,v)~=nil
   end
   return result
end

-- function HelloWorldEvent()
--    -- getglobal("CoolDownMainFrame"):SetScript("PLAYER_ENTERING_WORLD", print("钱老师加载了事件模块"));
--    -- getglobal("CoolDownMainFrame"):SetScript("PLAYER_ENTERING_WORLD", InitializationSkillName());
--    -- getglobal("CoolDownMainFrame"):SetScript("OnEvent",InitializationSkillName());
--    -- getglobal("CoolDownMainFrame"):UnregisterEvent("PLAYER_ENTERING_WORLD");
--    Init:SetScript("OnEvent",Init.);
--    Init:UnregisterEvent("PLAYER_ENTERING_WORLD");
-- end

function TargetDebuff(specialization)
   local TargetDebuffList={};
   if(specialization=="冰霜" or specialization=="鲜血") then
      TargetDebuffList={"冰霜疫病","血之疫病","寒冰锁链","冻疮","物理易伤"};
   elseif(specialization=="战斗") then
      TargetDebuffList={"要害打击"};
   elseif(specialization=="野兽控制") then
      TargetDebuffList={"要害打击"};
   else
      TargetDebuffList={"暗言术：痛","虚弱灵魂"};
   end
   
   local targetDebuffString="";  --初始返回值targetDebuffString为空。

   for i=1,40 do
      local name, _, _, count, debuffType, duration, expirationTime = UnitDebuff("target",i,"PLAYER");
      if(name==nil)then break end;

      for i,v in ipairs(TargetDebuffList) do --遍历所有TargetDebuff列表
         if name==v then targetDebuffString=targetDebuffString..name end; --如果发现Aura存在于之前定义的列表中，则保存在临时变量中。
      end
   end

   return targetDebuffString
end

function Unit_Aura(specialization,unit,filter)--注意，这个FILTER单单PLAYER是不行的。
   local unitAuraList={};    --声明UnitAura清单为空。
   local unitAuraString="";  --初始返回值targetDebuffString为空。

   if(specialization=="戒律" and unit=="target" and filter=="PLAYER|HELPFUL") then --注：玩家戒律牧对目标施放的BUFF。
      unitAuraList={"恢复","愈合祷言","真言术：韧"};
   elseif(specialization=="恢复" and unit=="target" and filter=="PLAYER|HELPFUL") then --注：玩家戒律牧对目标施放的BUFF。
      unitAuraList={"愈合","回春术","生命绽放","野性印记"};
   elseif(specialization=="野兽控制" and unit=="pet" and filter=="PLAYER|HELPFUL") then
      unitAuraList={"治疗宠物"};
   end
   
   for i=1,40 do
      local name, _, _, count, auraType, duration, expirationTime = UnitAura(unit,i,filter);
      if(name==nil)then break end;
      
      for i,v in ipairs(unitAuraList) do --遍历所有TargetDebuff列表
         if(string.find(name,v)~=nil) then unitAuraString=unitAuraString..name end; --如果发现Aura存在于之前定义的列表中，则保存在临时变量中。
      end
   end

   return unitAuraString
end

function PlayerAura(specialization)
   local playerAuraList={};
   local playerAuraString=""; --初始返回值playerAuraString为空。

   if(specialization=="鲜血" or specialization=="冰霜") then
      playerAuraList={"冰霜灵气","鲜血灵气","邪恶灵气","杀戮机器","符能转换","冰霜之柱","鲜血充能","冰冻之雾","巫妖之躯","白骨之盾","符文分流","寒冬号角"};
   elseif(specialization=="战斗") then
      playerAuraList={"切割","剑刃乱舞","复原"};
   elseif(specialization=="野兽控制") then
      playerAuraList={"集中火力"};
   elseif(specialization=="恢复") then
      playerAuraList={"自然迅捷","化身","清晰预兆"};
   elseif(specialization=="防护") then
      playerAuraList={"猝死","乘胜追击","盾牌格挡","命令怒吼","战斗怒吼","恐惧","闷棍","瘫痪","胜利","最后通牒"};
   else
      playerAuraList={"心灵之火","福音传播","圣光涌动","光明涌动","心灵意志","瘫痪","变形","昏迷","恐惧"};
   end
   
   for i=1,40 do
      local name, _, _, count, debuffType, duration, expirationTime = UnitAura("PLAYER",i);
      if(name==nil)then break end;

      for i,v in ipairs(playerAuraList) do --遍历所有Aura
         if name==v then playerAuraString=playerAuraString..name end; --如果发现Aura存在于之前定义的列表中，则保存在临时变量中。
      end
   end

   return playerAuraString
end

function N_RuneIsCD()
   local n_RuneIsCD=0;  --计算冷却中符文的数量。!!!最奇葩的一点；ID和符文位置的对应关系是1,2,5,6,3,4。
   for i=1,6 do
      _, _, runeReady = GetRuneCooldown(i)
      if not runeReady then n_RuneIsCD=n_RuneIsCD+1 end;
   end
   return n_RuneIsCD
end

function AutoActionBar(i,specialization,playerAuraString,debuffString,n_RuneIsCD,setTimer,playerHealth,ttIsPlayer,now)
   local targetIsChansting=WhoIsChansting("target");
   if(SkNm["目标"]~=nil) then ActBtnTurnRed(i,SkNm["目标"],UnitCanAttack("player","target") or UnitIsFriend("player","target")) end; --目标
   if(specialization=="冰霜") then

      ActBtnTurnRed(i,1,StringFindOr(playerAuraString,"杀戮机器") and n_RuneIsCD<2);--该技能被凛风冲击完全覆盖，因此作用就是杀戮机器BUFF出来后湮没不能用的情况下用用。
      ActBtnTurnRed(i,2,not StringFindOr(debuffString,"血之疫病")); --技能2如果检测到血之疫病则刷红技能2CD。
      ActBtnTurnRed(i,12,StringFindAnd(debuffString,"血之疫病","冰霜疫病") and n_RuneIsCD>=2);--吸血瘟疫。目标身上有2个疾病，且自身有2个符文处于CD。
      ActBtnTurnRed(i,70,GetActionCount(70)>=5 and n_RuneIsCD>=1);--活力分流。5个充能，且至少有一枚符文在CD。
      ActBtnTurnRed(i,62,n_RuneIsCD>=6 and UnitPower("PLAYER")<75);--符文武器增效。6个符文CD且能量小于75。
      ActBtnTurnRed(i,6,targetIsChansting);--心灵冰冻。对方在吟唱法术。后续改进建议：对于PVP玩家，吟唱可以还没念到一半的时候打断。施法要念到一半后打断。
      ActBtnTurnRed(i,72,targetIsChansting);--绞袭。对方在吟唱法术。
      ActBtnTurnRed(i,66,targetIsChansting and ttIsPlayer);--反魔法护罩。对方在对本玩家唱法术。
      ActBtnTurnRed(i,5,not StringFindOr(debuffString,"寒冰锁链","冻疮") and UnitIsPlayer("target"));--冰冻锁链。目标无减速，目标非玩家。
      ActBtnTurnRed(i,61,setTimer["传染"]~=nil and (now-setTimer["传染"])<30);--血液沸腾。一定要在感染放完的30秒内放这招。
      ActBtnTurnRed(i,64,(setTimer["传染"]==nil or (now-setTimer["传染"])>=30) and StringFindAnd(debuffString,"血之疫病","冰霜疫病"));--传染。放过30秒内就不要再放了。
      ActBtnTurnRed(i,3,not StringFindOr(debuffString,"冰冻之雾") or n_RuneIsCD==0);--冰霜打击。出冰冻之雾的时候给凛风冲击让路；没有符文的时候就不要让了。
      ActBtnTurnRed(i,4,not StringFindOr(debuffString,"冰霜疫病") or StringFindOr(playerAuraString,"冰冻之雾"));--没有冰霜疫病或免费冰冻之雾的时候用凛风打击。
      ActBtnTurnRed(i,11,false); --灵界打击先不用。以后留着给雕文。
      ActBtnTurnRed(i,10,false); --凋零缠绕先不用。以后留着给雕文。
      ActBtnTurnRed(i,9,StringFindOr(debuffString,"物理易伤") and StringFindOr(playerAuraString,"杀戮机器") and IsActionInRange(8,"target")==1); --冰霜之柱。湮灭可用+易伤+杀戮机器
      ActBtnTurnRed(i,71,StringFindOr(playerAuraString,"符能转换") and playerHealth>=0.9 or not StringFindOr(playerAuraString,"符能转换") and playerHealth<0.9); --符能转换。
      ActBtnTurnRed(i,65,playerHealth<0.6); --冰封之韧。

   elseif(specialization=="鲜血") then--鲜血天赋。
      -- local double_Disease=StringFindOr(debuffString,"血之疫病","冰霜疫病");
      -----------------------AOE技能先刷成紫色，地图炮刷成蓝色-----------------------
      -- ActBtnTurnPink(i,SkNm["血液沸腾"]);--血液沸腾。一定要在感染放完的30秒内放这招。
      -- ActBtnTurnPink(i,SkNm["传染"]);--传染。
      ActBtnTurnBlue(i,SkNm["枯萎凋零"]); --枯萎凋零。
      -----------------------根据情况决定刷成啥颜色-----------------------      
      ActBtnTurnRed(i,SkNm["冰冷触摸"],not StringFindOr(debuffString,"冰霜疫病") and IsActionInRange(i));--冰冷触摸。如果无冰霜疫病则触发。
      ActBtnTurnRed(i,SkNm["暗影打击"],not StringFindOr(debuffString,"血之疫病") and IsActionInRange(i));--技能2如果检测到血之疫病则刷红技能2CD。
      ActBtnTurnRed(i,SkNm["吸血瘟疫"],double_Disease and n_RuneIsCD>=2 and IsActionInRange(i));--吸血瘟疫。目标身上有2个疾病，且自身有2个符文处于CD。
      ActBtnTurnRed(i,SkNm["活力分流"],GetActionCount(SkNm["活力分流"])>=5 and n_RuneIsCD>=1);--活力分流。5个充能，且至少有一枚符文在CD。
      ActBtnTurnRed(i,SkNm["符文武器增效"],n_RuneIsCD>=6 and UnitPower("PLAYER")<75);--符文武器增效。6个符文CD且能量小于75。
      ActBtnTurnRed(i,SkNm["心灵冰冻"],targetIsChansting and IsActionInRange(i));--心灵冰冻。对方在吟唱法术。后续改进建议：对于PVP玩家，吟唱可以还没念到一半的时候打断。施法要念到一半后打断。
      ActBtnTurnRed(i,SkNm["绞袭"],targetIsChansting and IsActionInRange(i));--绞袭。对方在吟唱法术。
      ActBtnTurnRed(i,SkNm["反魔法护罩"],targetIsChansting and ttIsPlayer);--反魔法护罩。对方在对本玩家唱法术。
      ActBtnTurnRed(i,SkNm["寒冰锁链"],not StringFindOr(debuffString,"寒冰锁链","冻疮") and UnitIsPlayer("target") and IsActionInRange(i));--冰冻锁链。目标无减速，目标非玩家。
      ActBtnTurnRed(i,SkNm["血液沸腾"],attackMode==2 and StringFindAnd(debuffString,"血之疫病","冰霜疫病"));--血液沸腾。
      -- ActBtnTurnRed(i,SkNm["传染"],(setTimer["传染"]==nil or (now-setTimer["传染"])>=30) and StringFindAnd(debuffString,"血之疫病","冰霜疫病"));--传染。放过30秒内就不要再放了。
      -- ActBtnTurnRed(i,SkNm["符文打击"],not StringFindOr(playerAuraString,"巫妖之躯") or playerHealth>0.85);--符文打击。血少让路给变身吃大便。
      -- ActBtnTurnRed(i,SkNm["心脏打击"],UnitPower("PLAYER")<80 and StringFindAnd(debuffString,"血之疫病","冰霜疫病"));--心脏打击。无限制。
      ActBtnTurnRed(i,SkNm["灵界打击"],true and IsActionInRange(i)); --灵界打击。
      -- ActBtnTurnRed(i,SkNm["凋零缠绕"],UnitPower("PLAYER")>=30); --凋零缠绕先不用。
      ActBtnTurnRed(i,SkNm["冰封之韧"],playerHealth<0.7); --冰封之韧。
      ActBtnTurnRed(i,SkNm["符文分流"],not StringFindOr("符文分流") and playerHealth<0.85); --符文分流。
      -- ActBtnTurnRed(i,SkNm["亡者复生"],playerHealth<0.5); --亡者复生。
      ActBtnTurnRed(i,SkNm["黑暗命令"],not ttIsPlayer and IsActionInRange(i)); --黑暗命令。
      ActBtnTurnRed(i,SkNm["天灾契约"],playerHealth<0.5); --天灾契约。亡者复生45秒内吃。
      ActBtnTurnRed(i,SkNm["巫妖之躯"],playerHealth<0.6); --巫妖之躯。
      ActBtnTurnRed(i,SkNm["符文刃舞"],playerHealth<0.7); --符文刃舞。
      ActBtnTurnRed(i,SkNm["死亡之握"],not CheckInteractDistance("target",1) or not CheckInteractDistance("target",2) and (targetIsChansting or not ttIsPlayer) and IsActionInRange(i)); --死亡之握。
      ActBtnTurnRed(i,SkNm["吸血鬼之血"],playerHealth<0.3); --吸血鬼之血
      ActBtnTurnRed(i,SkNm["饰品1"],playerHealth<0.2); --饰品1
      ActBtnTurnRed(i,SkNm["自利"],not HasFullControl()); --自利。
      ActBtnTurnRed(i,SkNm["白骨之盾"],not StringFindOr(playerAuraString,"白骨之盾")); --白骨之盾。
      ActBtnTurnRed(i,SkNm["灵魂收割"],attackMode==1); --灵魂收割。
      ActBtnTurnRed(i,SkNm["爆发"],not StringFindOr(debuffString,"血之疫病","冰霜疫病")); --爆发。
      ActBtnTurnRed(i,SkNm["寒冬号角"],not StringFindOr(playerAuraString,"寒冬号角")); --寒冬号角
      ActBtnTurnRed(i,SkNm["血魔之握"],attackMode==2 and IsActionInRange(i)); --寒冬号角

   elseif(specialization=="戒律") then--牧师戒律天赋。
      -- local imChansting=WhoIsChansting("player");
      local imMoving=GetUnitSpeed("player")>0;
      local isEnemy=UnitCanAttack("player","target");
      local the2not = not imMoving and not isEnemy
      local targetHealth=UnitHealth("target")/UnitHealthMax("target");
      local playerMana=UnitPower("player",0)/UnitPowerMax("player",0);--SPELL_POWER_MANA = 0 SPELL_POWER_RAGE = 1 SPELL_POWER_ENERGY = 3 
      local targetBuff=Unit_Aura("戒律","target","PLAYER|HELPFUL");
      local threatStatus = UnitThreatSituation("target");
      local plrThrStatus = UnitThreatSituation("player");
      local targetIsTanking = threatStatus~=nil and threatStatus>1
      local playerIsTanking = plrThrStatus~=nil and plrThrStatus>1
      local debuffCleaning = UnitCleaning(specialization,"target","HARMFUL");
      
      ActBtnTurnBlue(i,SkNm["真言术：障"]);

      ActBtnTurnRed(i,SkNm["苦修"],the2not and targetHealth<0.75 and IsActionInRange(i));--苦修。
      ActBtnTurnRed(i,SkNm["真言术：盾"],not isEnemy and targetIsTanking and IsActionInRange(i));--真言术：盾。
      -- ActBtnTurnRed(i,SkNm["恢复"],not isEnemy and not StringFindOr(targetBuff,"恢复") and targetHealth<0.95);--恢复。
      ActBtnTurnRed(i,SkNm["愈合祷言"],the2not and not StringFindOr(targetBuff,"愈合祷言") and targetIsTanking and (setTimer["愈合祷言"]==nil or (now-setTimer["愈合祷言"])>35) and IsActionInRange(i));--愈合祷言。注意：内置计时器为空或大于35秒。
      -- ActBtnTurnRed(i,SkNm["希望圣歌"],not imMoving and playerMana<0.3);--希望圣歌。
      ActBtnTurnRed(i,SkNm["治疗祷言"],party_Recover>2);--治疗祷言
      ActBtnTurnRed(i,SkNm["快速治疗"],not isEnemy and (not imMoving and targetHealth<0.75 or GetActionCount(i)>0 and targetHealth<0.95)  and IsActionInRange(i));--快速治疗。圣光涌动会瞬发。
      -- ActBtnTurnRed(i,SkNm["联结治疗"],the2not and targetHealth<0.75 and playerHealth<0.75 and not UnitIsUnit("target","player"));--联结治疗。
      ActBtnTurnRed(i,SkNm["治疗术"],the2not and targetHealth<0.9 and IsActionInRange(i));--治疗术。
      ActBtnTurnRed(i,SkNm["纯净术"],not isEnemy and StringFindOr(debuffCleaning,"Magic","Disease") and IsActionInRange(i));--纯净术。
      ActBtnTurnRed(i,SkNm["暗言术：痛"],isEnemy and not StringFindOr(debuffString,"暗言术：痛") and IsActionInRange(i));--暗言术：痛。
      -- ActBtnTurnRed(i,SkNm["神圣之火"],true);--神圣之火。
      -- ActBtnTurnRed(i,SkNm["灵魂护壳"],false);--灵魂护壳
      ActBtnTurnRed(i,SkNm["痛苦压制"],not isEnemy and targetHealth<0.55 and targetIsTanking and IsActionInRange(i));--痛苦压制
      ActBtnTurnRed(i,SkNm["真言术：障"],party_Recover>2);--真言术：障
      ActBtnTurnRed(i,SkNm["驱散魔法"],false);--驱散魔法
      ActBtnTurnRed(i,SkNm["精神灼烧"],false);--精神灼烧
      ActBtnTurnRed(i,SkNm["虚空触须"],false);--虚空触须
      ActBtnTurnRed(i,SkNm["束缚亡灵"],false);--束缚亡灵
      ActBtnTurnRed(i,SkNm["渐隐术"],playerIsTanking);--渐隐术
      ActBtnTurnRed(i,SkNm["绝望祷言"],playerHealth<0.6);--绝望祷言
      -- ActBtnTurnRed(i,SkNm["防护恐惧结界"],true);--防护恐惧结界
      ActBtnTurnRed(i,SkNm["群体驱散"],false);--群体驱散
      ActBtnTurnRed(i,SkNm["惩击"],false);--惩击
      -- ActBtnTurnRed(i,SkNm["天使长"],StringFindOr(playerAuraString,"福音传播"));--天使长
      ActBtnTurnRed(i,SkNm["真言术：韧"],not isEnemy and not StringFindOr(targetBuff,"真言术：韧") and IsActionInRange(i));--真言术：韧
      ActBtnTurnRed(i,SkNm["自利"],not HasFullControl()); --自利。
      -- ActBtnTurnRed(i,SkNm["射击"],not imMoving and IsAutoRepeatAction(i)==nil);--射击
      -- ActBtnTurnRed(i,SkNm["神火"],assist_Attack);--神圣之火
      -- ActBtnTurnRed(i,SkNm["暗灭"],assist_Attack);--暗言术：灭
      ActBtnTurnRed(i,SkNm["暗影"],playerMana<0.55);--暗影魔。目标是不是ENEMY由宏控制。有个BUG，只能把暗影魔叫成暗影。
      ActBtnTurnRed(i,SkNm["能量灌注"],party_Recover>2);--射击

   elseif(specialization=="战斗") then --盗贼战斗天赋。
      local combo_Points=GetComboPoints("player", "target");
      local plrThrStatus = UnitThreatSituation("player");
      local playerIsTanking = plrThrStatus~=nil and plrThrStatus>1
      local targetHealth=UnitHealth("target")/UnitHealthMax("target");

      ActBtnTurnRed(i,SkNm["脚踢"],targetIsChansting); --脚踢。
      ActBtnTurnRed(i,SkNm["凿击"],targetIsChansting); --凿击。
      ActBtnTurnRed(i,SkNm["切割"],not StringFindOr(playerAuraString,"切割")); --切割
      ActBtnTurnRed(i,SkNm["刺骨"],combo_Points==5 or combo_Points>=4 and StringFindAnd(debuffString,"要害打击") or targetHealth*10<=combo_Points); --刺骨
      ActBtnTurnRed(i,SkNm["影袭"],combo_Points<5 and StringFindAnd(debuffString,"要害打击")); --影袭
      ActBtnTurnRed(i,SkNm["要害打击"],combo_Points<5 and not StringFindAnd(debuffString,"要害打击")); --要害打击
      ActBtnTurnRed(i,SkNm["剑刃乱舞"],attackMode==1 and StringFindOr(playerAuraString,"剑刃乱舞") or attackMode==2 and not StringFindOr(playerAuraString,"剑刃乱舞")); --剑刃乱舞
      ActBtnTurnRed(i,SkNm["闪避"],playerIsTanking and playerHealth<0.5);--闪避。
      ActBtnTurnRed(i,SkNm["备战就绪"],playerIsTanking and playerHealth<0.65);--备战就绪。
      ActBtnTurnRed(i,SkNm["复原"],0.08*combo_Points<(1-playerHealth) and StringFindOr(playerAuraString,"复原")); --复原。
      ActBtnTurnRed(i,SkNm["消失"],playerIsTanking);--备战就绪。

   elseif(specialization=="野兽控制") then --猎人。
      local combo_Points=GetComboPoints("player", "target");
      local plrThrStatus = UnitThreatSituation("player");
      -- local TT_ThrStatus = UnitThreatSituation("targettarget");
      local playerIsTanking = plrThrStatus~=nil and plrThrStatus>1
      -- local TT_IsTanking = TT_ThrStatus~=nil and TT_ThrStatus==3

      local targetHealth=UnitHealth("target")/UnitHealthMax("target");
      local petHealth=UnitHealth("pet")/UnitHealthMax("pet");
      local Pet_Buff_String=Unit_Aura("野兽控制","pet","PLAYER|HELPFUL");
      local ply_Power=UnitPower("player" , "FOCUS");
      local pet_Power=UnitPower("pet" , "FOCUS");
      local BuffCleaning = UnitCleaning("野兽控制","target","HELPFUL");
      -- local TT_is_MT=UnitHealth("targettarget")>UnitHealth("PLAYER")
      -- local _,_, TT_Armor, _,_ = UnitArmor("targettarget");
      -- local _,_, Plyr_Armor, _,_ = UnitArmor("targettarget");
      -- local _,_, target_Armor, _,_ = UnitArmor("target");

      ActBtnTurnRed(i,SkNm["反制射击"],targetIsChansting and IsActionInRange(i)); --反制射击
      ActBtnTurnRed(i,SkNm["震荡射击"],ttIsPlayer and IsActionInRange(i)); --反制射击
      ActBtnTurnRed(i,SkNm["夺命射击"],IsActionInRange(i)); --反制射击
      ActBtnTurnRed(i,SkNm["冰霜陷阱"],playerIsTanking); --反制射击
      ActBtnTurnRed(i,SkNm["治疗宠物"],not StringFindAnd(Pet_Buff_String,"治疗宠物") and petHealth<1 and IsActionInRange(i)); --反制射击
      ActBtnTurnRed(i,SkNm["奥术射击"],attackMode==1 and skill_CD[SkNm["夺命黑鸦"]]>0 and skill_CD[SkNm["杀戮命令"]]>0 and IsActionInRange(i)); --反制射击
      ActBtnTurnRed(i,SkNm["夺命黑鸦"],attackMode==1); --反制射击
      ActBtnTurnRed(i,SkNm["稳固射击"],attackMode==1 and ply_Power<30 or attackMode==2 and ply_Power<40); --反制射击
      ActBtnTurnRed(i,SkNm["杀戮命令"],attackMode==1); --反制射击
      ActBtnTurnRed(i,SkNm["爪击"],pet_Power>=45); --反制射击
      ActBtnTurnRed(i,SkNm["多重射击"],attackMode==2 and IsActionInRange(i)); --反制射击
      ActBtnTurnRed(i,SkNm["雷霆践踏"],pet_Power>=20 and attackMode==2); ----雷霆践踏。宏名字改成了雷霆
      ActBtnTurnRed(i,SkNm["宁神射击"],StringFindOr(BuffCleaning,"Magic") and IsActionInRange(i)); --反制射击
      ActBtnTurnRed(i,SkNm["假死"],playerIsTanking); --反制射击
      ActBtnTurnRed(i,SkNm["狂野怒火"],playerIsTanking); --反制射击
      ActBtnTurnRed(i,SkNm["意气风发"],playerHealth<0.4 or petHealth<0.4); --反制射击
      ActBtnTurnRed(i,SkNm["破釜沉舟"],petHealth<0.3); --破釜沉舟。宏名字改成了破釜。
      ActBtnTurnRed(i,SkNm["主人的召唤"],petHealth<0.2); --破釜沉舟。宏名字改成了破釜。
      ActBtnTurnRed(i,SkNm["胁迫"],targetIsChansting and IsActionInRange(i)); --反制射击
      ActBtnTurnRed(i,SkNm["纳鲁的赐福"],playerHealth<0.7); --反制射击
      ActBtnTurnRed(i,SkNm["基尔罗格之眼"],UnitIsFriend("player","targettarget") and IsActionInRange(i)); --误导。暴雪的BUG，不知道为什么宏是这个名字.
      ActBtnTurnRed(i,SkNm["冰霜新星"],targetHealth<0.3 and UnitIsFriend("player","targettarget") or ttIsPlayer); --低吼。暴雪的BUG，一定要把低吼搞成冰霜新星。
      ActBtnTurnRed(i,SkNm["扰乱射击"],false); --反制射击.
      ActBtnTurnRed(i,SkNm["集中火力"],GetActionCount(SkNm["集中火力"])>0 and not StringFindOr(playerAuraString,"集中火力"));--活力分流。5个充能，且至少有一枚符文在CD。
      -- local inRange = IsActionInRange(SkNm["奥术射击"],"TARGET");
      -- text1:SetText(inRange);
   elseif(specialization=="防护") then --战士。
      local targetHealth=UnitHealth("target")/UnitHealthMax("target");
      local ply_Rage=UnitPower("player" , "RAGE");
      local BuffCleaning = UnitCleaning("防护","PLAYER","HARMFUL");
      -- local plr_should_attract = not ttIsPlayer and UnitIsFriend("player","targettarget")==1

      ActBtnTurnRed(i,SkNm["斩杀"],IsActionInRange(i)); --斩杀
      ActBtnTurnRed(i,SkNm["胜利在望"],(playerHealth<0.85 or StringFindOr(playerAuraString,"胜利")) and IsActionInRange(i)); --乘胜追击
      ActBtnTurnRed(i,SkNm["震荡波"],attackMode==2 or targetIsChansting); --震荡波
      ActBtnTurnRed(i,SkNm["雷霆一击"],attackMode==2); --震荡波
      ActBtnTurnRed(i,SkNm["破胆怒吼"],false); --破胆怒吼
      ActBtnTurnRed(i,SkNm["命令怒吼"],not StringFindOr(playerAuraString,"命令怒吼","战斗怒吼")); --命令怒吼
      ActBtnTurnRed(i,SkNm["战斗怒吼"],not StringFindOr(playerAuraString,"命令怒吼","战斗怒吼")); --命令怒吼
      ActBtnTurnRed(i,SkNm["拳击"],targetIsChansting and IsActionInRange(i)); --拳击
      ActBtnTurnRed(i,SkNm["群体反射"],targetIsChansting); --拳击
      ActBtnTurnRed(i,SkNm["破釜沉舟"],playerHealth<0.35); --拳击
      ActBtnTurnRed(i,SkNm["盾墙"],playerHealth<0.5); --盾墙。
      ActBtnTurnRed(i,SkNm["盾牌格挡"],not StringFindOr(playerAuraString,"盾牌格挡")); --盾牌格挡"恐惧","闷棍","瘫痪"
      ActBtnTurnRed(i,SkNm["狂暴之怒"],StringFindOr(playerAuraString,"恐惧","闷棍","瘫痪")); --反制射击
      ActBtnTurnRed(i,SkNm["石像形态"],StringFindOr(BuffCleaning,"Magic","Disease","Poison","Curse","Blood")); --石像形态
      ActBtnTurnRed(i,SkNm["嘲讽"],not ttIsPlayer and IsActionInRange(i)); --嘲讽
      ActBtnTurnRed(i,SkNm["挫志怒吼"],attackMode==2); --嘲讽
      ActBtnTurnRed(i,SkNm["狂怒回复"],playerHealth<0.4); --嘲讽
      ActBtnTurnRed(i,SkNm["英勇打击"],(ply_Rage>=90 or StringFindOr(playerAuraString,"最后通牒")) and IsActionInRange(i)); --嘲讽 最后通牒
      ActBtnTurnRed(i,SkNm["断筋"],false); --嘲讽
      ActBtnTurnRed(i,SkNm["英勇投掷"],IsActionInRange(i)); --英勇投掷
      ActBtnTurnRed(i,SkNm["援护"],IsActionInRange(i)); --援护
      ActBtnTurnRed(i,SkNm["冲锋"],IsActionInRange(i)); --冲锋
      -- ActBtnTurnRed(i,SkNm["援护"],plr_should_attract); --嘲讽
      -- ActBtnTurnRed(i,SkNm["冲锋"],GetActionCount(SkNm["冲锋"])>0); --嘲讽 
      -- text1:SetText(attackMode);

   elseif(specialization=="恢复") then --德鲁伊。
      local imMoving=GetUnitSpeed("player")>0;
      local isEnemy=UnitCanAttack("player","target");
      local the2not = not imMoving and not isEnemy
      local targetHealth=UnitHealth("target")/UnitHealthMax("target");
      -- local playerMana=UnitPower("player",0)/UnitPowerMax("player",0);--SPELL_POWER_MANA = 0 SPELL_POWER_RAGE = 1 SPELL_POWER_ENERGY = 3 
      local targetBuff=Unit_Aura("恢复","target","PLAYER|HELPFUL");
      local threatStatus = UnitThreatSituation("target");
      local plrThrStatus = UnitThreatSituation("player");
      local targetIsTanking = threatStatus~=nil and threatStatus>1
      local playerIsTanking = plrThrStatus~=nil and plrThrStatus>1
      local debuffCleaning = UnitCleaning("恢复","target","HARMFUL");
      local plr_In_Combat=UnitAffectingCombat("PLAYER");
   
      ActBtnTurnRed(i,SkNm["愈合"],not isEnemy and targetHealth<0.9 and not StringFindOr(targetBuff,"愈合") and IsActionInRange(i) and (not imMoving or StringFindOr(playerAuraString,"化身"))); --愈合
      ActBtnTurnRed(i,SkNm["野性成长"],the2not and party_Recover>2 and IsActionInRange(i)); --野性成长
      ActBtnTurnRed(i,SkNm["治疗之触"],not isEnemy and targetHealth<0.85 and IsActionInRange(i) and (not imMoving or StringFindOr(targetBuff,"自然迅捷"))); --治疗之触
      ActBtnTurnRed(i,SkNm["宁静"],not imMoving and party_Recover>3); --宁静
      ActBtnTurnRed(i,SkNm["自然之愈"],not isEnemy and StringFindOr(debuffCleaning,"Magic","Curse","Poison") and IsActionInRange(i));--自然之愈
      ActBtnTurnRed(i,SkNm["回春术"],not isEnemy and targetHealth<1 and not StringFindOr(targetBuff,"回春术") and IsActionInRange(i)); --回春术
      ActBtnTurnRed(i,SkNm["生命绽放"],not isEnemy and (targetHealth<0.95 or targetIsTanking) and not StringFindOr(targetBuff,"生命绽放") and IsActionInRange(i)); --生命绽放
      ActBtnTurnRed(i,SkNm["树皮术"],playerIsTanking); --树皮术
      ActBtnTurnRed(i,SkNm["铁木树皮"],not isEnemy and targetHealth<0.65 and IsActionInRange(i) and plr_In_Combat); --铁木树皮
      ActBtnTurnRed(i,SkNm["化身：生命之树"],party_Recover>3 and not StringFindOr(playerAuraString,"化身") and plr_In_Combat); --生命之树
      ActBtnTurnRed(i,SkNm["新生"],playerHealth<0.65); --生命之树
      ActBtnTurnRed(i,SkNm["自然迅捷"],not isEnemy and targetHealth<0.5 and plr_In_Combat); --自然迅捷
      ActBtnTurnRed(i,SkNm["野性印记"],not isEnemy and IsActionInRange(i) and not StringFindOr(targetBuff,"野性印记")); --野性印记
      ActBtnTurnRed(i,SkNm["迅捷治愈"],not isEnemy and IsActionInRange(i) and targetHealth<0.75 and plr_In_Combat); --迅捷治愈

      -- text1:SetText(UnitAffectingCombat("target") and "Yessss" or "Nooooooo");
   end
end 

function ActBtnTurnRed(i,j,condition)
   if(i==j and not condition) then 
      actionButton_CDText[j]:SetTextColor(1,0,0) 
      skl_Can_Fire[i]=0;   --如果技能不可用则将技能的可用性置为0。
   end;
end

function ActBtnTurnBlue(i,j)
   if(i==j) then actionButton_CDText[j]:SetTextColor(0,0,1) end;
end

function ActBtnTurnPink(i,j)
   if(i==j) then actionButton_CDText[j]:SetTextColor(1,0,1) end;
end

function WhoIsChansting(who)
   local spellName_Casting= UnitCastingInfo(who);
   local spellName_Channel= UnitChannelInfo(who);
   return spellName_Channel~=nil or spellName_Casting~=nil
end

function PartySelection()
   local partyMemberList={"player","party1","party2","party3","party4"};
   -- local partyMemberList={"player"};
   local MemberSelected="";  --声明最需要帮助的成员姓名。
   local trgNeedOfhelp=0;
   local mostInNeedOfHelp=0;

   for i,v in ipairs(partyMemberList) do --遍历所有Aura
      if(UnitIsDeadOrGhost(v) or UnitHealthMax(v)==0 or not UnitInRange(v))then

      else
         local unitInjuried = 1-UnitHealth(v)/UnitHealthMax(v);
         local status = UnitThreatSituation(v);

         if(unitInjuried>0.1) then party_Recover=party_Recover+1 end;  --判断是否需要群体大加血。
         if(status==3 or status==2) then trgNeedOfhelp=unitInjuried*3 else trgNeedOfhelp=unitInjuried end;
         if(StringFindOr(UnitCleaning("戒律",v,"HARMFUL"),"Magic","Disease")) then trgNeedOfhelp=trgNeedOfhelp+0.15 end;

         if(trgNeedOfhelp>=mostInNeedOfHelp) then
            mostInNeedOfHelp=trgNeedOfhelp;
            MemberSelected=v;
         end
      end
   end

   return MemberSelected
end

function PaintPartyButton(slotID)
   local ptySlct=PartySelection();

   if(UnitCanAttack("player","target"))then
      actionButton_CDText[slotID]:SetTextColor(1,1,0);
   elseif(ptySlct=="player")then
      actionButton_CDText[slotID]:SetTextColor(0,0,1);
   elseif(ptySlct=="party1")then
      actionButton_CDText[slotID]:SetTextColor(0,1,0);
   elseif(ptySlct=="party2")then
      actionButton_CDText[slotID]:SetTextColor(0,1,1);
   elseif(ptySlct=="party3")then
      actionButton_CDText[slotID]:SetTextColor(1,0,0);
   elseif(ptySlct=="party4")then
      actionButton_CDText[slotID]:SetTextColor(1,0,1);
   else
      actionButton_CDText[slotID]:SetTextColor(1,1,0);
   end
end

function UnitCleaning(specialization,unit,filter)
   -- local unitAuraList={};    --声明UnitAura清单为空。
   local CleanClearString="";  --初始返回值targetDebuffString为空。
   
   for i=1,40 do
      local name, _, _, _, auraType = UnitAura(unit,i,filter);
      if(name==nil)then break end;
      
      if(auraType~=nil) then CleanClearString=CleanClearString..auraType end;
   end

   return CleanClearString
end

