-- This resource was made by plesalex100#7387
-- Please respect it, don't repost it without my permission
-- This Resource started from: https://codepen.io/AdrianSandu/pen/MyBQYz
-- Converted to QBCore by JustifY#9606

QBCore = exports['qb-core']:GetCoreObject()
local PlayerData                = {}
local open 						= false

Citizen.CreateThread(function()
	while QBCore == nil do
	  TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
	  Citizen.Wait(0)
	end
	  Citizen.Wait(1000)
	while QBCore.Functions.GetPlayerData().job == nil do
	  Citizen.Wait(1000)
	end
  
	QBCore.PlayerData = QBCore.Functions.GetPlayerData()
		Citizen.Wait(1000)
  end)
  
  
  
  RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
  AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
	QBCore.PlayerData = xPlayer
  end)

-------------------------------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------------------------------
local function drawHint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

-------------------------------------------------------------------------------
-- NET EVENTS
-------------------------------------------------------------------------------
RegisterNetEvent("qb-slots:enterBets")
AddEventHandler("qb-slots:enterBets", function ()
	local requiredItems = {
		[1] = {name = QBCore.Shared.Items["casinochips"]["name"], image = QBCore.Shared.Items["casinochips"]["image"]},
	}
	TriggerEvent('inventory:client:requiredItems', requiredItems, true)
	TriggerEvent('QBCore:Notify', 'How many chips you wanna bet? (Only 50 on 50 values.)', 'success')
    	local bets = KeyboardInput("Enter bet value:", "", Config.MaxBetNumbers)
    	if tonumber(bets) ~= nil then
    		TriggerServerEvent('qb-slots:BetsAndChips', tonumber(bets))
		TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    	else
		TriggerEvent('QBCore:Notify', 'You need to enter numbers (9999 is max bet).')
      		TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    	end
end)

RegisterNetEvent("qb-slots:UpdateSlots")
AddEventHandler("qb-slots:UpdateSlots", function(lei)
	SetNuiFocus(true, true)
	open = true
	TriggerEvent('inventory:client:requiredItems', requiredItems, false)
	SendNUIMessage({
		showPacanele = "open",
		coinAmount = tonumber(lei)
	})
end)

-------------------------------------------------------------------------------
-- NUI CALLBACKS
-------------------------------------------------------------------------------
RegisterNUICallback('exitWith', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	open = false
	TriggerEvent('inventory:client:requiredItems', requiredItems, false)
	TriggerServerEvent("qb-slots:PayOutRewards", data.coinAmount)
end)