--[[ Lua code. See documentation: https://api.tabletopsimulator.com/ --]]
IP_ADDRESS = nil
PORT = "9001"
GET_INITIATIVE_PATH = "/playermenu/getinitiative"
changeIPAddressID = "change_ipaddress"
inputIPAddressID = "ipaddress_input"
--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
    --[[ print('onLoad!') --]]
end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate()
    --[[ print('onUpdate loop!') --]]
end

function storeIPAddress(player, ipAddress, id)
    IP_ADDRESS = ipAddress
    print("The current IP Address is: " .. ipAddress)
    UI.show(changeIPAddressID)
    UI.hide(inputIPAddressID)
    UI.setAttribute(changeIPAddressID, "text",IP_ADDRESS)
    loadPlayerData()
end

function changeIPAddress()
    UI.show(inputIPAddressID)
    UI.hide(changeIPAddressID)
end

function loadPlayerData()
    WebRequest.get(IP_ADDRESS .. ":" .. PORT .. GET_INITIATIVE_PATH, function(request)
        UI.show(changeIPAddressID)
        if request.is_error then
            log(request.error)
        else
            broadcastToAll(request.text)
        end
    end)
    
end

--initiative rolling
--end turn
--