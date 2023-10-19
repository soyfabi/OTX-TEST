function onSay(cid, words, param)
    if words == "!buyvip" then
		-- Check player with VIP
		if getPlayerStorageValue(cid, 13545) - os.time() > 0 then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você já tem vip, espere seu tempo acabar, para verificar com !vipdays.")
			return true
		end
		
		local itemid = 6535
		local count = 1
		
        if doPlayerRemoveItem(cid, itemid, count) then
            local days = 31
            local daysvalue = days * 24 * 60 * 60
            local storageplayer = getPlayerStorageValue(cid, 13545)
            local timenow = os.time()
            
            local time
            if getPlayerStorageValue(cid, 13545) - os.time() <= 0 then
                time = timenow + daysvalue
            else
                time = storageplayer + daysvalue
            end
            
            if string.find(tostring(getCreatureName(cid)), "[[VIP]]") then
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Foram adicionados " .. days .. " dias de VIP no seu character.")
                setPlayerStorageValue(cid, 13545, time)
                local quantity = math.floor((getPlayerStorageValue(cid, 13545) - timenow) / (24 * 60 * 60))
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você tem " .. (quantity < 0 and 0 or quantity) .. " dias de VIP restantes.")
            else
                doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Foram adicionados " .. days .. " dias de VIP no seu character.")
                setPlayerStorageValue(cid, 13545, time)
                local name = getCreatureName(cid)
                db.executeQuery("UPDATE `players` SET `name` = '[VIP] " .. name .. "' WHERE `id` = " .. getPlayerGUID(cid) .. ";")
                doRemoveCreature(cid)
            end
        else
           doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você precisa de [" .. count .. " " .. getItemNameById(itemid) .. "] para colocar VIP.")
        end
    elseif words == "!vipdays" then
        local timenow = os.time()
        local quantity = math.floor((getPlayerStorageValue(cid, 13545) - timenow) / (24 * 60 * 60))
		if quantity > 0 then
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Voce tem " .. quantity .. " dias de VIP no seu character.")
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Nao tem dias vip.")
		end
 elseif words == "/checkvip" then
        if getPlayerAccess(cid) == 5 then
            if not param then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Invalid param specified.")
            else
                local player = getPlayerByName(param)
                if not isPlayer(player) then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player " .. param .. " not found.")
                else
                    local timenow = os.time()
                    local quantity = math.floor((getPlayerStorageValue(player, 13545) - timenow) / (24 * 60 * 60))
                    if quantity > 0 then
						doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Voce tem " .. quantity .. " dias de VIP no seu character.")
					else
						doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Nao tem dias vip.")
					end
                end
            end
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você não tem acesso a este comando.")
        end
    elseif words == "/addvip" then
        if getPlayerAccess(cid) == 5 then
            local t = string.explode(param, ",")
            if not t[2] then
                doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Invalid param specified.")
            else
                local playerName = t[1]
                local player = getPlayerByName(playerName)
                local name = getCreatureName(player)
                local days = tonumber(t[2])
                local pid = getPlayerByNameWildcard(playerName)
                
                if not pid or (isPlayerGhost(pid) and getPlayerGhostAccess(pid) > getPlayerGhostAccess(cid)) then
                    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Player with this name doesn't exist or is offline.")
                    return TRUE
                end
                
                local daysvalue = days * 3600 * 24
                local storageplayer = getPlayerStorageValue(player, 13545)
                local timenow = os.time()
                local time = storageplayer <= 0 and (timenow + daysvalue) or (storageplayer + daysvalue)
                
                if string.find(tostring(getCreatureName(pid)), "[[VIP]]") then
                    doPlayerSendTextMessage(player, MESSAGE_INFO_DESCR, "Foram adicionados " .. days .. " dias de VIP no seu character.")
                    setPlayerStorageValue(player, 13545, time)
                    local quantity = math.floor((getPlayerStorageValue(player, 13545) - timenow) / (3600 * 24))
                    doPlayerSendTextMessage(player, MESSAGE_INFO_DESCR, "Você tem " .. quantity .. " dias de VIP restantes.")
                else
                    setPlayerStorageValue(player, 13545, time)
                    db.executeQuery("UPDATE `players` SET `name` = '[VIP] " .. name .. "' WHERE `id` = " .. getPlayerGUID(player) .. ";")
                    doRemoveCreature(player)
                end
            end
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você não tem acesso a este comando.")
        end
    elseif words == "/delvip" then
		if getPlayerAccess(cid) == 5 then
            local dec = MESSAGE_INFO_DESCR
            if param == "" then
                return TRUE, doPlayerSendTextMessage(cid, 18, "Command param required.")
            end
            local C, t = {}, string.explode(param, ",")
            C.pos = getPlayerPosition(cid)
            C.uid = getCreatureByName(t[1])
            C.time = ((tonumber(t[2]) == nil) and 1 or tonumber(t[2])) * 3600 * 24 -- Tempo da VIP por dia.
            C.days = (tonumber(t[2]) == nil) and 1 or tonumber(t[2]) -- Dias de VIP.
            
            if getPlayerStorageValue(C.uid, 13545) < C.time then
                doPlayerSendTextMessage(cid, dec, 'O jogador ' .. t[1] .. ' não possui ' .. C.days .. ' dias de VIP.')
            else
                doPlayerSendTextMessage(cid, dec, 'Você removeu ' .. C.days .. ' dias de VIP do player ' .. t[1] .. '.')
                setPlayerStorageValue(C.uid, 13545, getPlayerStorageValue(C.uid, 13545) - C.time)
            end
            doSendMagicEffect(C.pos, math.random(28, 30))
		else
			doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Você não tem acesso a este comando.")
		end
    end
    return true
end