function removeVipName(cid)
    local newName = string.gsub(getCreatureName(cid), "%[VIP%]", "")
    newName = newName:trim()
    db.executeQuery("UPDATE `players` SET `name` = '" .. newName .. "' WHERE `id` = " .. getPlayerGUID(cid) .. ";")
    doRemoveCreature(cid)
end

function onLogin(cid)
    local vipStorage = getPlayerStorageValue(cid, 13545)
    
    if vipStorage > 0 then
        local currentTime = os.time()
        if vipStorage <= currentTime then
            setPlayerStorageValue(cid, 13545, -1)
            doPlayerPopupFYI(cid, "Sua [VIP] Acabou.")
			
			if string.find(tostring(getCreatureName(cid)), "%[VIP%]") then
				addEvent(removeVipName, 3 * 1000, cid)
			end
        else
            local daysLeft = math.ceil((vipStorage - currentTime) / (24 * 60 * 60))
			--local pos = {x = 146, y = 389, z = 7}
            --doTeleportThing(cid, pos)
            doPlayerPopupFYI(cid, "Voce Ainda Tem " .. daysLeft .. " Dias de [VIP] Restantes.")
        end
    end
    return true
end