function onUse(cid, item, frompos, item2, topos)
   local config = {
      pz = false, -- false = não precisa estar em protect zone
      battle = true, -- true = não pode ter battle
      remover = false, -- true = remove o item
   }
   local cidade = getTownTemplePosition(getPlayerTown(cid))
   local posicao = getCreaturePosition(cid)
   
   if config.pz == true and getTilePzInfo(posicao) == FALSE then
      doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT,"You need to be in a protection zone to use Magic Fish.")
   elseif config.battle == true and getCreatureCondition(cid, CONDITION_INFIGHT) == TRUE then
      doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "You need to have not battle to use it.")
   else
      if config.remover == true then
         doRemoveItem(item.uid)
      end
      --doSendMagicEffect(getThingPos(cid), 30)
      doTeleportThing(cid, cidade)
      doSendMagicEffect(cidade, CONST_ME_SMOKE)
      doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Welcome back Rich Guy !!!! :)")
   end
   return true
end