InventoryService = {}
ItemPickUps = {}
MoneyPickUps = {}
GoldPickUps = {}
Core = {}

Citizen.CreateThread(function()
	TriggerEvent("getCore", function(core)
		Core = core;
	end)
end)


InventoryService.UseItem = function(itemName, itemId, args)
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local userInventory = UsersInventories["default"][identifier]

	if UsableItemsFunctions[itemName] ~= nil and userInventory[itemId] ~= nil then
		local item = userInventory[itemId]
		if item ~= nil then
			if svItems[itemName] ~= nil then
				local itemArgs = json.decode(json.encode(svItems[itemName]))
				itemArgs.metadata = item:getMetadata()
				local arguments = {
					source = _source,
					item = itemArgs,
					args = args
				}
				UsableItemsFunctions[itemName](arguments)
			end
		end
	end
	return false
end

InventoryService.DropMoney = function(amount)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local userCharacter = Core.getUser(_source).getUsedCharacter
		local userMoney = userCharacter.money

		if amount <= 0 then
			TriggerClientEvent("vorp:TipRight", _source, _U("TryExploits"), 3000)
		elseif userMoney < amount then
			TriggerClientEvent("vorp:TipRight", _source, _U("NotEnoughMoney"), 3000)
		else
			userCharacter.removeCurrency(0, amount)

			TriggerClientEvent("vorpInventory:createMoneyPickup", _source, amount)
		end
		SvUtils.Trem(_source)
	end
end

InventoryService.DropAllMoney = function()
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local userCharacter = Core.getUser(_source).getUsedCharacter
		local userMoney = userCharacter.money

		if userMoney > 0 then
			userCharacter.removeCurrency(0, userMoney)

			TriggerClientEvent("vorpInventory:createMoneyPickup", _source, userMoney)
		end
		SvUtils.Trem(_source)
	end
end

InventoryService.DropMoney = function(amount)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local userCharacter = Core.getUser(_source).getUsedCharacter
		local userMoney = userCharacter.money

		if amount <= 0 then
			TriggerClientEvent("vorp:TipRight", _source, _U("TryExploits"), 3000)
		elseif userMoney < amount then
			TriggerClientEvent("vorp:TipRight", _source, _U("NotEnoughMoney"), 3000)
		else
			userCharacter.removeCurrency(0, amount)

			TriggerClientEvent("vorpInventory:createMoneyPickup", _source, amount)
		end
		SvUtils.Trem(_source)
	end
end

InventoryService.DropAllMoney = function()
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local userCharacter = Core.getUser(_source).getUsedCharacter
		local userMoney = userCharacter.money

		if userMoney > 0 then
			userCharacter.removeCurrency(0, userMoney)

			TriggerClientEvent("vorpInventory:createMoneyPickup", _source, userMoney)
		end
		SvUtils.Trem(_source)
	end
end

InventoryService.DropPartMoney = function()
	local _source = source
	local userCharacter = Core.getUser(_source).getUsedCharacter
	local userMoney = userCharacter.money
	local userPartMoney = userMoney - (userMoney * Config.DropOnRespawn.PartPercentage / 100)
	local userMoneyDef = userMoney - userPartMoney

	if userMoney > 0 then
		userCharacter.removeCurrency(0, userMoneyDef)

		TriggerClientEvent("vorpInventory:createMoneyPickup", _source, userMoneyDef)
	end
end

InventoryService.giveMoneyToPlayer = function(target, amount)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local _target = target
		if Core.getUser(_source) == nil or Core.getUser(_target) == nil then
			SvUtils.Trem(_source)
			return
		end
		local sourceCharacter = Core.getUser(_source).getUsedCharacter
		local targetCharacter = Core.getUser(_target).getUsedCharacter
		local sourceMoney = sourceCharacter.money

		if amount <= 0 then
			TriggerClientEvent("vorp:TipRight", _source, _U("TryExploits"), 3000)
			Wait(3000)
			TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		elseif sourceMoney < amount then
			TriggerClientEvent("vorp:TipRight", _source, _U("NotEnoughMoney"), 3000)
			Wait(3000)
			TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		else
			sourceCharacter.removeCurrency(0, amount)
			targetCharacter.addCurrency(0, amount)

			TriggerClientEvent("vorp:TipRight", _source, _U("YouPaidMoney", tostring(amount), targetCharacter.firstname .. " " .. targetCharacter.lastname), 3000)
			TriggerClientEvent("vorp:TipRight", _target, _U("YouReceivedMoney", tostring(amount), sourceCharacter.firstname .. " " .. sourceCharacter.lastname), 3000)
			Wait(3000)
			TriggerClientEvent("vorp_inventory:ProcessingReady", _source)
		end
		SvUtils.Trem(_source)
	end
end

InventoryService.DropGold = function(amount)
	local _source = source
	if SvUtils.InProcessing(_source) then
		return
	end

	SvUtils.ProcessUser(_source)
	local userCharacter = Core.getUser(_source).getUsedCharacter
	local userGold = userCharacter.gold

	if amount <= 0 then
		TriggerClientEvent("vorp:TipRight", _source, _U("TryExploits"), 3000)
	elseif userGold < amount then
		TriggerClientEvent("vorp:TipRight", _source, _U("NotEnoughGold"), 3000)
	else
		userCharacter.removeCurrency(1, amount)

		TriggerClientEvent("vorpInventory:createGoldPickup", _source, amount)
	end
	SvUtils.Trem(_source)
end

InventoryService.DropAllGold = function()
	local _source = source
	if SvUtils.InProcessing(_source) then
		return
	end

	SvUtils.ProcessUser(_source)
	local userCharacter = Core.getUser(_source).getUsedCharacter
	local userGold = userCharacter.gold

	if userGold > 0 then
		userCharacter.removeCurrency(1, userGold)

		TriggerClientEvent("vorpInventory:createGoldPickup", _source, userGold)
	end
	SvUtils.Trem(_source, false)
end

InventoryService.giveGoldToPlayer = function(target, amount)
	local _source = source
	if SvUtils.InProcessing(_source) then
		return
	end

	if Core.getUser(_source) == nil or Core.getUser(_target) == nil then
		return
	end

	SvUtils.ProcessUser(_source)
	local _target = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local targetCharacter = Core.getUser(_target).getUsedCharacter
	local sourceGold = sourceCharacter.gold

	if amount <= 0 then
		TriggerClientEvent("vorp:TipRight", _source, _U("TryExploits"), 3000)
		Wait(3000)
	elseif sourceGold < amount then
		TriggerClientEvent("vorp:TipRight", _source, _U("NotEnoughGold"), 3000)
		Wait(3000)
	else
		sourceCharacter.removeCurrency(1, amount)
		targetCharacter.addCurrency(1, amount)

		TriggerClientEvent("vorp:TipRight", _source, _U("YouPaid", tostring(amount), targetCharacter.firstname .. " " .. targetCharacter.lastname), 3000)
		TriggerClientEvent("vorp:TipRight", _target, _U("YouReceived", tostring(amount), sourceCharacter.firstname .. " " .. sourceCharacter.lastname), 3000)
		Wait(3000)
	end
	SvUtils.Trem(_source)
end

InventoryService.setWeaponBullets = function(weaponId, type, amount)
	local userWeapons = UsersWeapons["default"]

	if userWeapons[weaponId] ~= nil then
		userWeapons[weaponId]:setAmmo(type, amount)
	end
end

InventoryService.usedWeapon = function(id, _used, _used2)
	local used = 0
	local used2 = 0

	if _used then used = 1 end
	if _used2 then used2 = 1 end

	exports.ghmattimysql:execute('UPDATE loadout SET used = @used, used2 = @used2 WHERE id = @id', {
		['used'] = used,
		['used2'] = used2,
		['id'] = id
	}, function()
	end)
end

InventoryService.subItem = function(target, invId, itemId, amount)
	local _source = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local userInventory = nil

	if CustomInventoryInfos[invId].shared then
		userInventory = UsersInventories[invId]
	else
		userInventory = UsersInventories[invId][identifier]
	end

	if userInventory ~= nil then
		if userInventory[itemId] ~= nil then
			local item = userInventory[itemId]
			if item ~= nil then
				if amount <= item:getCount() then
					item:quitCount(amount)
				end
	
				if item:getCount() == 0 then
					userInventory[itemId] = nil
					DbService.DeleteItem(item:getOwner(), itemId)
				else
					DbService.SetItemAmount(item:getOwner(), itemId, item:getCount())
				end
				--InventoryAPI.SaveInventoryItemsSupport(_source)
			end
		end
	end
end

InventoryService.addItem = function(target, invId, name, amount, metadata, cb)
	local _source = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charIdentifier = sourceCharacter.charIdentifier
	metadata = SharedUtils.MergeTables(svItems[name].metadata, metadata or {})
	local userInventory = nil

	if CustomInventoryInfos[invId].shared then
		userInventory = UsersInventories[invId]
	else
		userInventory = UsersInventories[invId][identifier]
	end

	if userInventory ~= nil then
		local item = SvUtils.FindItemByNameAndMetadata(invId, identifier, name, metadata)
		if item ~= nil then
			if amount > 0 then
				item:addCount(amount)
				DbService.SetItemAmount(item:getOwner(), item:getId(), item:getCount())
				cb(item)
				return
			end
			cb(nil)
			return
		else
			if svItems[name] ~= nil then
				DbService.CreateItem(charIdentifier, svItems[name]:getId(), amount, metadata, function (craftedItem)
					item = Item:New({
						id = craftedItem.id,
						count = amount,
						limit = svItems[name]:getLimit(),
						label = svItems[name]:getLabel(),
						metadata = SharedUtils.MergeTables(svItems[name]:getMetadata(), metadata),
						name = name,
						type = "item_standard",
						canUse = svItems[name]:getCanUse(),
						canRemove = svItems[name]:getCanRemove(),
						owner = charIdentifier
					})
					userInventory[craftedItem.id] = item
					cb(item)
				end, invId)
				return
			end
			cb(nil)
			return
		end
	end

	cb(nil)
end

InventoryService.addWeapon = function(target, weaponId)
	local _source = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local userWeapons = UsersWeapons["default"]

	if userWeapons[weaponId] ~= nil then
		userWeapons[weaponId]:setPropietary(identifier)
		exports.ghmattimysql:execute('UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id', {
			['identifier'] = identifier,
			['charid'] = charId,
			['id'] = weaponId
		}, function()
		end)
	end
end

InventoryService.subWeapon = function(target, weaponId)
	local _source = target
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local userWeapons = UsersWeapons["default"]

	if userWeapons[weaponId] ~= nil then
		userWeapons[weaponId]:setPropietary('')

		exports.ghmattimysql:execute('UPDATE loadout SET identifier = @identifier, charidentifier = @charid WHERE id = @id', {
			['identifier'] = identifier,
			['charid'] = charId,
			['id'] = weaponId
		}, function() end)
	end
end

InventoryService.onPickup = function(obj)
	local _source = source

	if SvUtils.InProcessing(_source) then
		return
	end
	
	SvUtils.ProcessUser(_source)
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local identifier = sourceCharacter.identifier
	local charId = sourceCharacter.charIdentifier
	local userInventory = UsersInventories["default"][identifier]
	local userWeapons = UsersWeapons["default"]

	if ItemPickUps[obj] ~= nil then
		local name = ItemPickUps[obj].name
		local amount = ItemPickUps[obj].amount
		local metadata = ItemPickUps[obj].metadata

			if ItemPickUps[obj].weaponid == 1 then

			if userInventory ~= nil then
				if svItems[name]:getLimit() ~= -1 then
					local item = SvUtils.FindItemByNameAndMetadata("default", identifier, name, metadata)

					if item ~= nil then
						--local sourceItemCount = UsersInventories[identifier][name]:GetCount()
						local totalAmount = amount + item:getCount()

						if svItems[name]:getLimit() < totalAmount then
							TriggerClientEvent("vorp:TipRight", _source, _U("fullInventory"), 2000)
							return
						end
					end

					if Config.MaxItemsInInventory.Items ~= 0 then
						local sourceInventoryItemCount = InventoryAPI.getUserTotalCount(identifier)
						sourceInventoryItemCount = sourceInventoryItemCount + amount

						if sourceInventoryItemCount > Config.MaxItemsInInventory.Items then
							TriggerClientEvent("vorp:TipRight", _source, _U("fullInventory"), 2000)
							return
						end
					end
				end

				InventoryService.addItem(_source, "default", name, amount, metadata, function (item)
					if item ~= nil then
						local title = _U('itempickup')
						local description = _U('itempickup2') .. amount .. " " .. name
						Discord(title, _source, description)

						TriggerClientEvent("vorpInventory:sharePickupClient", -1, name, ItemPickUps[obj].obj, amount, metadata, ItemPickUps[obj].coords, 2)
						TriggerClientEvent("vorpInventory:removePickupClient", -1, ItemPickUps[obj].obj)
						TriggerClientEvent("vorpInventory:receiveItem", _source, name, item:getId(), amount, metadata)
						TriggerClientEvent("vorpInventory:playerAnim", _source, obj)
		
						ItemPickUps[obj] = nil
					end
				end)
			end
		else
			if Config.MaxItemsInInventory.Weapons ~= 0 then
				local sourceInventoryWeaponCount = InventoryAPI.getUserTotalCountWeapons(identifier, charId) + 1

				if sourceInventoryWeaponCount <= Config.MaxItemsInInventory.Weapons then
					local weaponId = ItemPickUps[obj].weaponid
					local weaponObj = ItemPickUps[obj].obj
					InventoryService.addWeapon(_source, weaponId)

					TriggerEvent("syn_weapons:onpickup", weaponId)
					TriggerClientEvent("vorpInventory:sharePickupClient", -1, name, weaponObj, 1, metadata, ItemPickUps[obj].coords, 2, weaponId)
					TriggerClientEvent("vorpInventory:removePickupClient", -1, weaponObj)
					TriggerClientEvent("vorpInventory:receiveWeapon", _source, weaponId, userWeapons[weaponId]:getPropietary(), userWeapons[weaponId]:getName(), userWeapons[weaponId]:getAllAmmo())
					TriggerClientEvent("vorpInventory:playerAnim", _source, obj)

					ItemPickUps[obj] = nil
				end
			else
				if Config.MaxItemsInInventory.Weapons ~= 0 then
					local sourceInventoryWeaponCount = InventoryAPI.getUserTotalCountWeapons(identifier, charId) + 1

					if sourceInventoryWeaponCount <= Config.MaxItemsInInventory.Weapons then
						local weaponId = ItemPickUps[obj].weaponid
						local weaponObj = ItemPickUps[obj].obj
						InventoryService.addWeapon(_source, weaponId)
						local title = _U('weppickup')
						local description = _U('itempickup2') .. userWeapons[weaponId]:getName()
						Discord(title, _source, description)
						TriggerEvent("syn_weapons:onpickup", weaponId)
						TriggerClientEvent("vorpInventory:sharePickupClient", -1, name, weaponObj, 1, ItemPickUps[obj].coords, 2, weaponId)
						TriggerClientEvent("vorpInventory:removePickupClient", -1, weaponObj)
						TriggerClientEvent("vorpInventory:receiveWeapon", _source, weaponId, userWeapons[weaponId]:getPropietary(), userWeapons[weaponId]:getName(), userWeapons[weaponId]:getAllAmmo())
						TriggerClientEvent("vorpInventory:playerAnim", _source, obj)
						ItemPickUps[obj] = nil
					else
						TriggerClientEvent("vorp:TipRight", _source, _U("fullInventoryWeapon"), 2000)
					end
				end
			end
		end
	end
	SvUtils.Trem(_source, false)
end

InventoryService.onPickupMoney = function(obj)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		if MoneyPickUps[obj] ~= nil then
			SvUtils.ProcessUser(_source)
			local moneyObj = MoneyPickUps[obj].obj
			local moneyAmount = MoneyPickUps[obj].amount
			local moneyCoords = MoneyPickUps[obj].coords

			TriggerClientEvent("vorpInventory:shareMoneyPickupClient", -1, moneyObj, moneyAmount, moneyCoords, 2)
			TriggerClientEvent("vorpInventory:removePickupClient", -1, moneyObj)
			TriggerClientEvent("vorpInventory:playerAnim", _source, moneyObj)
			TriggerEvent("vorp:addMoney", _source, 0, moneyAmount)
			MoneyPickUps[obj] = nil
			SvUtils.Trem(_source, false)
		end
	end
end

InventoryService.onPickupGold = function(obj)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		if GoldPickUps[obj] ~= nil then
			SvUtils.ProcessUser(_source)
			local goldObj = GoldPickUps[obj].obj
			local goldAmount = GoldPickUps[obj].amount
			local goldCoords = GoldPickUps[obj].coords

			TriggerClientEvent("vorpInventory:shareGoldPickupClient", -1, goldObj, goldAmount, goldCoords, 2)
			TriggerClientEvent("vorpInventory:removePickupClient", -1, goldObj)
			TriggerClientEvent("vorpInventory:playerAnim", _source, goldObj)
			TriggerEvent("vorp:addMoney", _source, 1, goldAmount)
			GoldPickUps[obj] = nil
			SvUtils.Trem(_source, false)
		end
	end
end

InventoryService.sharePickupServer = function(name, obj, amount, metadata, position, weaponId)
	TriggerClientEvent("vorpInventory:sharePickupClient", -1, name, obj, amount, metadata, position, 1, weaponId)

	ItemPickUps[obj] = {
		name = name,
		obj = obj,
		amount = amount,
		metadata = metadata,
		weaponid = weaponId,
		inRange = false,
		coords = position
	}
end

InventoryService.shareMoneyPickupServer = function(obj, amount, position)
	TriggerClientEvent("vorpInventory:shareMoneyPickupClient", -1, obj, amount, position, 1)

	MoneyPickUps[obj] = {
		name = _U("inventorymoneylabel"),
		obj = obj,
		amount = amount,
		inRange = false,
		coords = position
	}
end

InventoryService.shareGoldPickupServer = function(obj, amount, position)
	TriggerClientEvent("vorpInventory:shareGoldPickupClient", -1, obj, amount, position, 1)

	GoldPickUps[obj] = {
		name = _U("inventorygoldlabel"),
		obj = obj,
		amount = amount,
		inRange = false,
		coords = position
	}
end

InventoryService.DropWeapon = function(weaponId)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		InventoryService.subWeapon(_source, weaponId)

		TriggerClientEvent("vorpInventory:createPickup", _source, UsersWeapons["default"][weaponId]:getName(), 1, {}, weaponId)
		SvUtils.Trem(_source)
	end
end

InventoryService.DropItem = function(itemName, itemId, amount, metadata)
	local _source = source

	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		InventoryService.subItem(_source, "default", itemId, amount)

		TriggerClientEvent("vorpInventory:createPickup", _source, itemName, amount, metadata, 1)
		SvUtils.Trem(_source)
	end
end

InventoryService.GiveWeapon = function(weaponId, target)
	local _source = source
	if not SvUtils.InProcessing(_source) then
		SvUtils.ProcessUser(_source)
		local _target = target

		if UsersWeapons["default"][weaponId] ~= nil then
			InventoryAPI.giveWeapon(_target, weaponId, _source)
		end
		SvUtils.Trem(_source)
	end
end


InventoryService.GiveItem = function(itemId, amount, target)
	local _source = source

	if SvUtils.InProcessing(_source) then
		return
	end

	SvUtils.ProcessUser(_source)
	local _target = target
	if Core.getUser(_source) == nil or Core.getUser(_target) == nil then
		SvUtils.Trem(_source)
		return
	end
	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local targetCharacter = Core.getUser(_target).getUsedCharacter

	local sourceIdentifier = sourceCharacter.identifier
	local targetIdentifier = targetCharacter.identifier

	local sourceInventory = UsersInventories["default"][sourceIdentifier]
	local targetInventory = UsersInventories["default"][targetIdentifier]

	local sourceCharIdentifier = sourceCharacter.charIdentifier
	local targetCharIdentifier = targetCharacter.charIdentifier

	if sourceInventory == nil or targetInventory == nil then
		SvUtils.Trem(_source)
		return
	end



	if sourceInventory[itemId] == nil then
		TriggerClientEvent("vorp:TipRight", _source, _U("itemerror"), 2000)

		if Config.Debug then
			Log.error("ServerGiveItem: User " .. sourceCharacter.firstname .. ' ' .. sourceCharacter.lastname .. '#' .. _source .. ' ' .. 'inventory item ' .. itemName .. ' not found')
		end
		SvUtils.Trem(_source)
		return
	end

	local item = sourceInventory[itemId]
	local itemName = item:getName()
	local itemMetadata = item:getMetadata()
	local targetItemAmount = 0
	local targetItemLimit = 0
	local targetInventoryItemCount = InventoryAPI.getUserTotalCount(targetIdentifier)
	local canGiveItemToTarget = true
	local targetItem = SvUtils.FindItemByNameAndMetadata("default", targetIdentifier, itemName, itemMetadata);


	if targetItem ~= nil then
		targetItemAmount = targetItem:getCount()
		targetItemLimit = targetItem:getLimit()

		if targetItemAmount + amount > targetItemLimit then
			canGiveItemToTarget = false
		end
	end

	if targetInventoryItemCount + amount > Config.MaxItemsInInventory.Items then
		canGiveItemToTarget = false
	end

	if not canGiveItemToTarget then
		TriggerClientEvent("vorp:TipRight", _source, _U('fullInventoryGive'), 2000)
		TriggerClientEvent("vorp:TipRight", _target, _U('fullInventory'), 2000)
		SvUtils.Trem(_source)
		return
	end


	local updateClient = function ()
		TriggerClientEvent("vorpInventory:receiveItem", _target, itemName, targetItem:getId(), amount, itemMetadata)
		TriggerClientEvent("vorpInventory:removeItem", _source, itemName, item:getId(), amount)

		if item:getCount() - amount <= 0 then
			DbService.DeleteItem(sourceCharIdentifier, item:getId())
			sourceInventory[item:getId()] = nil
		else
			item:quitCount(amount)
			DbService.SetItemAmount(sourceCharIdentifier, item:getId(), item:getCount())
		end

		local ItemsLabel = svItems[itemName]:getLabel()
		--NOTIFY

		TriggerClientEvent("vorp:TipRight", _source, "you gave " .. amount .. " of " .. ItemsLabel, 2000)
		TriggerClientEvent("vorp:TipRight", _target, "you received " .. amount .. " " .. ItemsLabel, 2000)
		TriggerEvent("vorpinventory:itemlog", _source, _target, itemName, amount)
		SvUtils.Trem(_source)
	end

	if targetItem ~= nil then
		targetItem:addCount(amount)
		DbService.SetItemAmount(targetCharIdentifier, targetItem:getId(), targetItem:getCount())
		updateClient()
	else
		if svItems[itemName] ~= nil then
			DbService.CreateItem(targetCharIdentifier, svItems[itemName]:getId(), amount, itemMetadata, function (craftedItem)
				targetItem = Item:New({
					id = craftedItem.id,
					count = amount,
					limit = svItems[itemName]:getLimit(),
					label = svItems[itemName]:getLabel(),
					name = itemName,
					type = "item_inventory",
					metadata = itemMetadata,
					canUse = svItems[itemName]:getCanUse(),
					canRemove = svItems[itemName]:getCanRemove(),
					owner = targetCharIdentifier
				})
				targetInventory[craftedItem.id] = targetItem
				updateClient()
			end)
		else
			if svItems[itemName] ~= nil then
				targetInventory[itemName] = Item:New({
					count = amount,
					limit = svItems[itemName]:getLimit(),
					label = svItems[itemName]:getLabel(),
					name = itemName,
					type = "item_inventory",
					canUse = svItems[itemName]:getCanUse(),
					canRemove = svItems[itemName]:getCanRemove(),
					owner = targetCharIdentifier
				})
			else
				if Config.Debug then
					Log.error("ServerGiveItem: Server items does not contain " .. itemName .. ".")
				end
				SvUtils.Trem(_source)
				return
			end
		end

		item:quitCount(amount)

		if item:getCount() == 0 then
			sourceInventory[itemName] = nil
		end

		InventoryAPI.SaveInventoryItemsSupport(_source)

		TriggerClientEvent("vorpInventory:receiveItem", _target, itemName, amount)
		TriggerClientEvent("vorpInventory:removeItem", _source, itemName, amount)



		local ItemsLabel = svItems[itemName]:getLabel()
		--NOTIFY

		TriggerClientEvent("vorp:TipRight", _source, _U("yougive") .. amount .. _U("of") .. ItemsLabel .. "", 2000)
		TriggerClientEvent("vorp:TipRight", _target, _U("youreceive") .. amount .. _U("of") .. ItemsLabel .. "", 2000)
		TriggerEvent("vorpinventory:itemlog", _source, _target, itemName, amount)
		SvUtils.Trem(_source)
	end
end

InventoryService.getItemsTable = function()
	local _source = source

	if svItems ~= nil then
		TriggerClientEvent("vorpInventory:giveItemsTable", _source, svItems)
	end
end

InventoryService.getInventory = function()
	local _source = source
	local sourceCharacter = Core.getUser(_source).getUsedCharacter

	if sourceCharacter == nil then
		return
	end

	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharId = sourceCharacter.charIdentifier

	local characterInventory = {}

	if sourceCharId ~= nil then
		DbService.GetInventory(sourceCharId, "default", function(inventory)
			for _, item in pairs(inventory) do
				if svItems[item.item] ~= nil then
					local dbItem = svItems[item.item]
					characterInventory[item.id] = Item:New({
						count = tonumber(item.amount),
						id = item.id,
						limit = dbItem.limit,
						label = dbItem.label,
						metadata = SharedUtils.MergeTables(dbItem.metadata, item.metadata),
						name = dbItem.item,
						type = dbItem.type,
						canUse = dbItem.canUse,
						canRemove = dbItem.canRemove,
						createdAt = item.created_at,
						owner = sourceCharId
					})
				end
			end
			UsersInventories["default"][sourceIdentifier] = characterInventory
			TriggerClientEvent("vorpInventory:giveInventory", _source, json.encode(inventory))
		end)

		-- exports.ghmattimysql:execute("SELECT * FROM loadout WHERE identifier = @identifier AND charidentifier = @charid AND curr_inv = 'default';", {
		-- 	['identifier'] = sourceIdentifier,
		-- 	['charid'] = sourceCharId,
		-- }, function(result)
		-- 	if result ~= nil then
		-- 		for _, weapon in pairs(result) do
		-- 			local db_Ammo = json.decode(weapon.ammo)
		-- 			local weaponAmmo = {}
		-- 			local used = false
		-- 			local used2 = false

		-- 			for _, ammo in pairs(db_Ammo) do
		-- 				weaponAmmo[_] = ammo
		-- 			end

		-- 			if weapon.used == 1 then used = true end
		-- 			if weapon.used2 == 1 then used2 = true end

		-- 			if  weapon.curr_inv == "default" and (weapon.dropped == nil or weapon.dropped == 0) then
		-- 				local newWeapon = Weapon:New({
		-- 					id = weapon.id,
		-- 					propietary = weapon.identifier,
		-- 					name = weapon.name,
		-- 					ammo = weaponAmmo,
		-- 					used = used,
		-- 					used2 = used2,
		-- 					charId = sourceCharId,
		-- 					currInv = weapon.curr_inv
		-- 				})
		-- 				UsersWeapons[newWeapon:getId()] = newWeapon
		-- 			end
		-- 		end
		-- 		TriggerClientEvent("vorpInventory:giveLoadout", _source, result)
		-- 	end
		-- end)

		-- Weapons are already loaded at the start of the script. We just need to filter the good ones
		local userWeapons = {}
		for _, weapon in pairs(UsersWeapons["default"]) do
			if weapon.charId == sourceCharId and weapon.currInv == "default" then
				userWeapons[#userWeapons+1] = weapon
			end
		end
		TriggerClientEvent("vorpInventory:giveLoadout", _source, userWeapons)

		-- In case a player reconnect with another character, clear custom inventory
		for id, _ in pairs(CustomInventoryInfos) do
			if UsersInventories[id][sourceIdentifier] ~= nil then
				UsersInventories[id][sourceIdentifier] = nil
			end
		end
	end
end

InventoryService.getInventoryTotalCount = function(identifier, charIdentifier, invId)
	invId = invId ~= nil and invId or "default"
	local userTotalItemCount = 0
	local userInventory = {}
	local userWeapons = UsersWeapons[invId]

	if CustomInventoryInfos[invId].shared then
		userInventory = UsersInventories[invId]
	else
		userInventory = UsersInventories[invId][identifier]
	end

	for _, item in pairs(userInventory) do
		userTotalItemCount = userTotalItemCount + item:getCount()
	end
	for _, weapon in pairs(userWeapons) do
		if CustomInventoryInfos[invId].shared or weapon.charId == charIdentifier then
			userTotalItemCount = userTotalItemCount + 1
		end
	end
	return userTotalItemCount
end

InventoryService.canStoreWeapon = function(identifier, charIdentifier, invId, name, amount)
	local invData = CustomInventoryInfos[invId]

	if invData.limit > 0 then
		local sourceInventoryItemCount = InventoryService.getInventoryTotalCount(identifier, charIdentifier, invId)
		sourceInventoryItemCount = sourceInventoryItemCount + amount

		if sourceInventoryItemCount > invData.limit then
			return false
		end
	end

	if invData.limitedItems[name] ~= nil then
		local weapons = SvUtils.FindAllWeaponsByName(invId, identifier, name)
		local weaponCount = #weapons + amount

		if weaponCount > invData.limitedItems[name] then
			return false
		end
	end
	return true
end

InventoryService.canStoreItem = function(identifier, charIdentifier, invId, name, amount)
	local invData = CustomInventoryInfos[invId]

	if invData.limit > 0 then
		local sourceInventoryItemCount = InventoryService.getInventoryTotalCount(identifier, charIdentifier, invId)
		sourceInventoryItemCount = sourceInventoryItemCount + amount

		if sourceInventoryItemCount > invData.limit then
			return false
		end
	end

	if invData.limitedItems[name] ~= nil then
		local items = SvUtils.FindAllItemsByName(invId, identifier, name)

		if #items ~= 0 then
			local itemCount = 0
			for _, item in pairs(items) do
				itemCount = itemCount + item:getCount()
			end
			local totalAmount = amount + itemCount

			if totalAmount > invData.limitedItems[name] then
				return false
			end
		end
	end
	return true
end

InventoryService.getNearbyCharacters = function(obj, sources)
	local _source = source

	local characters = {}
	for _, playerId in pairs(sources) do
		if Config.ShowCharacterNameOnGive then
			local character = Core.getUser(playerId).getUsedCharacter
			characters[#characters+1] = {
				label = character.firstname .. ' ' .. character.lastname,
				player = playerId
			}
		else
			characters[#characters+1] = {
				label = playerId, -- show server id instead of steam name
				player = playerId
			}
		end
	end

	TriggerClientEvent('vorp_inventory:setNearbyCharacters', _source, obj, characters)
end

InventoryService.MoveToCustom = function(obj)
	local _source = source
	local data = json.decode(obj)
	local invId = tostring(data.id)
	local item = data.item
	local amount = tonumber(data.number)

	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharIdentifier = sourceCharacter.charIdentifier

	if item.type == "item_weapon" then
		if CustomInventoryInfos[invId].acceptWeapons then
			if InventoryService.canStoreWeapon(sourceIdentifier, sourceCharIdentifier, invId, item.name, amount) then
				exports.ghmattimysql:execute("UPDATE loadout SET curr_inv = @invId WHERE charidentifier = @charid AND id = @weaponId;", {
					['invId'] = invId,
					['charid'] = sourceCharIdentifier,
					['weaponId'] = item.id,
				})

				UsersWeapons["default"][item.id]:setCurrInv(invId)
				UsersWeapons[invId][item.id] = UsersWeapons["default"][item.id]
				UsersWeapons["default"][item.id] = nil

				TriggerClientEvent("vorpCoreClient:subWeapon", _source, item.id)
				InventoryAPI.reloadInventory(_source, invId)
			else
				TriggerClientEvent("vorp:TipRight", _source, _U("fullInventory"), 2000)
			end
		else
			-- Print Error Client Side: Can't store weapon here
		end
	else
		if InventoryService.canStoreItem(sourceIdentifier, sourceCharIdentifier, invId, item.name, amount) then
			InventoryService.subItem(_source, "default", item.id, amount)
			TriggerClientEvent("vorpInventory:removeItem", _source, item.name, item.id, amount)
			InventoryService.addItem(_source, invId, item.name, amount, item.metadata, function (itemAdded)
				if itemAdded == nil then
					return
				end
				InventoryAPI.reloadInventory(_source, invId)
			end)
		else
			TriggerClientEvent("vorp:TipRight", _source, _U("fullInventory"), 2000)
		end
	end
end

InventoryService.TakeFromCustom = function(obj)
	local _source = source
	local data = json.decode(obj)
	local invId = tostring(data.id)
	local item = data.item
	local amount = tonumber(data.number)

	local sourceCharacter = Core.getUser(_source).getUsedCharacter
	local sourceIdentifier = sourceCharacter.identifier
	local sourceCharIdentifier = sourceCharacter.charIdentifier

	if item.type == "item_weapon" then
		InventoryAPI.canCarryAmountWeapons(_source, 1, function(res)
			if res then
				exports.ghmattimysql:execute("UPDATE loadout SET curr_inv = 'default' WHERE charidentifier = @charid AND id = @weaponId;", {
					['charid'] = sourceCharIdentifier,
					['weaponId'] = item.id,
				})
				UsersWeapons[invId][item.id]:setCurrInv("default")
				UsersWeapons["default"][item.id] = UsersWeapons[invId][item.id]
				UsersWeapons[invId][item.id] = nil
		
				local weapon = UsersWeapons["default"][item.id]
		
				TriggerClientEvent("vorpInventory:receiveWeapon", _source, item.id, weapon:getPropietary(), weapon:getName(), weapon:getAllAmmo())
				InventoryAPI.reloadInventory(_source, invId)
			else
				TriggerClientEvent("vorp:TipRight", _source, _U("fullInventory"), 2000)
			end
		end)
	else
		InventoryAPI.canCarryItem(_source, item.name, amount, function (res)
			if res then
				InventoryService.subItem(_source, invId, item.id, amount)
				InventoryService.addItem(_source, "default", item.name, amount, item.metadata, function (itemAdded)
					if itemAdded == nil then
						return
					end
					TriggerClientEvent("vorpInventory:receiveItem", _source, item.name, itemAdded:getId(), amount, itemAdded:getMetadata())
					InventoryAPI.reloadInventory(_source, invId)
				end)
			else
				TriggerClientEvent("vorp:TipRight", _source, _U("fullInventory"), 2000)
			end
		end, item.metadata)
	end
end
