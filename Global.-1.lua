-- Tabletop Simulator Connector for D&D Combat Assistant
-- Made by Benjamin Kim & Joshua Haynes, April 2023


-- XML variables: 

XML_STRING = [[
<Panel id = "test" onCLick = "foo">Test</Panel>
]]

-- Network constants:

IP_ADDRESS = nil
PORT = "9001"

GET_INITIATIVE_PATH = "/playermenu/getinitiative"
ROLL_INITIATIVE_PATH = "/playermenu/rollinitiative"
GET_PCS_PATH = "/playermenu/getpcs"
ADD_TO_MAP_PATH = "/playermenu/movetomap"
NEXT_TURN_PATH = "/playermenu/nextturn"
GET_CURRENT_PLAYER_PATH = "/playermenu/getcurrentcharacter"
GET_NEXT_PLAYER_PATH = "/playermenu/getnextcharacter"
GET_TIMED_EFFECTS_PATH = "/playermenu/gettimedeffects"
ADD_TIMED_EFFECT_PATH = "/playermenu/addtimedeffect"

-- XML id constants:

changeIPAddressID = "change_ipaddress"
inputIPAddressID = "ipaddress_input"
pcListID = "pc_list"
textButtonID = "text_button"
requestInitiativeID = "requestInit"
blueInitiativeID = "blueInitiative"
purpleInitiativeID = "purpleInitiative"
greenInitiativeID = "greenInitiative"
orangeInitiativeID = "orangeInitiative"
tealInitiativeID = "tealInitiative"
brownInitiativeID = "brownInitiative"
pinkInitiativeID = "pinkInitiative"
redInitiativeID = "redInitiative"
yellowInitiativeID = "yellowInitiative"
whiteInitiativeID = "whiteInitiative"
gmInitiativeID = "gm_roll_initiative"
gmInitTextID = "text_button_2"
turnOrderID = "h_scrollView"
endTurnID = "end_turn_button"
endTurnGmID = "end_turn_gm"
endCombatID = "end_combat_gm"
refreshCombatID = "refresh_combat_gm"
addAPlayerID = "addAPlayer"
requestSkillID = "requestPartySkill"
whiteSkillID = "whiteSkill"
blueSkillID = "blueSkill"
greenSkillID = "greenSkill"
yellowSkillID = "yellowSkill"
purpleSkillID = "purpleSkill"
redSkillID = "redSkill"
orangeSkillID = "orangeSkill"
tealSkillID = "tealSkill"
pinkSkillID = "pinkSkill"
brownSkillID = "brownSkill"
skillTextID = "text_button_5"
openPartySkillViewerID = "openPartySkillViewer"
addTimedEffectID = "add_timed_effect"
addTimedEffectDurationID = "timed_effect_duration"
addTimedEffectTargetsID = "timed_effect_targets"
addTimedEffectNameID = "timed_effect_name"
timedEffectEffectID = "timed_effect_effect"
timedEffectTextID = "text_button_6"
cancelTimedEffectID = "cancel_timed_effect"
confirmTimedEffectID = "confirm_timed_effect"
displayTimedEffectsTextID = "text_button_7"
timedEffect1ID = "text_button_8"
timedEffect2ID = "text_button_9"
timedEffect3ID = "text_button_10"
timedEffectsDownID = "timed_effects_down_button"
timedEffectsUpID = "timed_effects_up_button"
initTextID = "text_button_3"
initSlot1ID = "text_button_4"
initSlot2ID = "text_button_11"
initSlot3ID = "text_button_12"
initSlot4ID = "text_button_13"
initSlot5ID = "text_button_14"
turnLeftButtonID = "turn_left_button"
turnRightButtonID = "turn_right_button"
closeBlueInitID = "closeBlueInit"
closeBlueSkillID = "closeBlueSkill"
closeWhiteInitID = "closeWhiteInit"
closeWhiteSkillID = "closeWhiteSkill"
closeGreenInitID = "closeGreenInit"
closeGreenSkillID = "closeGreenSkill"
closeRedInitID = "closeRedInit"
closeRedSkillID = "closeRedSkill"
closeTealInitID = "closeTealInit"
closeTealSkillID = "closeTealSkill"
closeBrownInitID = "closeBrownInit"
closeBrownSkillID = "closeBrownSkill"
closeYellowInitID = "closeYellowInit"
closeYellowSkillID = "closeYellowSkill"
closeOrangeInitID = "closeOrangeInit"
closeOrangeSkillID = "closeOrangeSkill"
closePinkInitID = "closePinkInit"
closePinkSkillID = "closePinkSkill"
closePurpleInitID = "closePurpleInit"
closePurpleSkillID = "closePurpleSkill"

-- Game constants:

SELECTED_GREY = "#787878"
PROMPT_BLUE = "#3498DB"
NPC_PURPLE = "#9B59B6"
DEFAULT_RED_PINK = "#ff6666"
DEFAULT_BLUE_GREY = "#5c7091"
CURRENT_GOLD = "#ffcc00"
NEXT_PURPLE = "#9900cc"
END_RED = "#cc0000"
BLACK = "#000000"
DEFAULTY_GREY = "#d1d1d1"
BUTTON_COLOR_1 = "#99ccff"
BUTTON_COLOR_2 = "#3399ff"
BUTTON_COLOR_3 = "#ff99ff"
BUTTON_COLOR_4 = "#cc99ff"
BUTTON_COLOR_5 = "#ff0066"
BUTTON_COLOR_6 = "#cc0000"
BUTTON_COLOR_7 = "#ffcc99"
BUTTON_COLOR_8 = "#e48b07"
BUTTON_COLOR_9 = "#00ffcc"
BUTTON_COLOR_10 = "#009933"
BUTTON_COLOR_11 = "#ebebeb"
BUTTON_COLOR_12 = "#bdbdbd"
CR_STRING = [[%pCR%s]]
CR_STRING_2 = [[%p%d]]
XML_REPLACE = [[onClick%s=%s"]]
XML_REPLACE_2 = [[onEndEdit%s=%s"]] -- todo: update this with %p and maybe %c
-- ATTRIBUTES = "attributes"
-- ID = "id"
-- CHILDREN = "children"

-- Game variables:

pcList = {}
numberOfPCs = 0
playerColorMap = {White = "", Red = "", Brown = "", Orange = "", Yellow = "", Green = "", Teal = "", Blue = "", Purple = "", Pink = ""}
currentTurnName = ""
nextTurnName = ""
pcSelectorActive = false
timedEffectsList = {}
threeViewed = {1,2,3} -- indexes of viewed effects
fiveViewed = {1,2,3,4,5} -- indexes of viewed characters


-- Core functions:

function onLoad()
    broadcastToAll("Loading the D&D Combat Assistant...")
end

function onUpdate()
    -- print('onUpdate loop!')
end

-- Network setup functions:

function storeIPAddress(player, ipAddress, id)
    IP_ADDRESS = ipAddress
    -- print("The current IP Address is: " .. ipAddress)
    UI.setAttribute(changeIPAddressID, "active", "true")
    UI.setAttribute(changeIPAddressID, "visibility", "host")
    UI.setAttribute(inputIPAddressID, "active", "false")
    UI.setAttribute(changeIPAddressID, "text", IP_ADDRESS)
    loadPlayerData()
end

function changeIPAddress()
    UI.setAttribute(inputIPAddressID, "active", "true")
    UI.setAttribute(inputIPAddressID, "visibility", "host")
    UI.setAttribute(changeIPAddressID, "active", "false")
end

-- Player selection functions:

function makePcList(pcListFromServer)
    pcList = mysplit(shaveString(pcListFromServer), ",")
    numberOfPCs = #(pcList)
    displayPcs()
    UI.setAttribute(addAPlayerID, "active", "true")
end

function addPlayerToggle()
    if UI.getAttribute(addAPlayerID, "text") == "Open Player Selector" then
        UI.setAttribute(addAPlayerID, "text", "Close Player Selector")
        UI.setAttribute(addAPlayerID, "color", BUTTON_COLOR_6)
        displayPcs()
    else
        UI.setAttribute(addAPlayerID, "text", "Open Player Selector")
        UI.setAttribute(addAPlayerID, "color", PROMPT_BLUE)
        closePcSelector()

    end
end

function displayPcs()
    -- for each PC, activate a button (max 10 PCs)
    for i = 1, numberOfPCs, 1 do
        -- print(pcList[i])
        name = shaveString(pcList[i])
        buttonId = "buttonId" .. tostring(i)
        UI.setAttribute(buttonId, "active", "true")
        UI.setAttribute(buttonId, "text", name)
        if isTabletopObject then
            UI.setAttribute(buttonId, "onClick", objectGuid.."/playerSelected("..name..")")
        else
            UI.setAttribute(buttonId, "onClick", "playerSelected("..name..")")
        end
        
    end

    UI.setAttribute(textButtonID, "active", "true")
    UI.setAttribute(pcListID, "active", "true")
    pcSelectorActive = true
end

function playerSelected(player, name, id)
    -- id is the buttonId
    playerCurrentName = findPlayerNameFromColor(player.color)
    if playerCurrentName == name then
        broadcastToColor("You've already selected "..name, player.color)
    else
        broadcastToAll(player.steam_name .. " (" .. player.color .. ") selected: " .. name)
        playerColorMap[tostring(player.color)] = name
        updatePlayerButtons()
        apiAddToMap(name)
        UI.setAttribute(requestInitiativeID, "active", "true")
        UI.setAttribute(requestInitiativeID, "color", SELECTED_GREY)
        UI.setAttribute(requestSkillID, "active", "true")
        UI.setAttribute(requestSkillID, "color", SELECTED_GREY)
        checkIfAllPCsSelected()
    end
end

function updatePlayerButtons()
    -- set any selected buttons to SELECTED_GREY, all others to default
    for m = 1, 12, 1 do
        buttonId = "buttonId" .. tostring(m)
        playerName02 = UI.getAttribute(buttonId, "text")
        -- print(playerName02)
        setColor = DEFAULT_RED_PINK

        if isPlayerInColorMap(playerName02) then
            setColor = SELECTED_GREY
        else
            if m == 1 then
                setColor = BUTTON_COLOR_1
            else 
                if m == 2 then
                    setColor = BUTTON_COLOR_2
                else
                    if m == 3 then
                        setColor = BUTTON_COLOR_3
                    else
                        if m == 4 then
                            setColor = BUTTON_COLOR_4
                        else
                            if m == 5 then
                                setColor = BUTTON_COLOR_5
                            else
                                if m == 6 then
                                    setColor = BUTTON_COLOR_6
                                else
                                    if m == 7 then
                                        setColor = BUTTON_COLOR_7
                                    else
                                        if m == 8 then
                                            setColor = BUTTON_COLOR_8
                                        else
                                            if m == 9 then
                                                setColor = BUTTON_COLOR_9
                                            else
                                                if m == 10 then
                                                    setColor = BUTTON_COLOR_10
                                                else
                                                    if m == 11 then
                                                        setColor = BUTTON_COLOR_11
                                                    else
                                                        if m == 12 then
                                                            setColor = BUTTON_COLOR_12
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        UI.setAttribute(buttonId, "color", setColor)
    end
end

function checkIfAllPCsSelected()
    -- for each PC, check if it is assigned to a color
    foundNames = 0
    for k = 1, numberOfPCs, 1 do
        name = shaveString(pcList[k])
        -- print(name)
        if isPlayerInColorMap(name) then
            foundNames = foundNames + 1 
        end
    end
    -- print(foundNames)
    if foundNames == numberOfPCs then
        addPlayerToggle()
        UI.setAttribute(requestInitiativeID, "color", PROMPT_BLUE)
        UI.setAttribute(requestSkillID, "color", PROMPT_BLUE)
    end
end

function closePcSelector()
    UI.setAttribute(textButtonID, "active", "false")
    UI.setAttribute(pcListID, "active", "false")
    pcSelectorActive = false
end

-- Initiative funtions:

function requestInitiative()
    endCombat()
    if  pcSelectorActive then
        UI.setAttribute(addAPlayerID, "text", "Open Player Selector")
        UI.setAttribute(addAPlayerID, "color", PROMPT_BLUE) -- double added to cover an error
        closePcSelector()
    end
    numberInitspopulated = 0
    initNameList = ""
    initListForDisplay = ""
    initNamesJsonString = ""
    broadcastToAll("It\'s time to roll initiative!")
    -- for each color, if a PC, activate that UI element to request init
    if isNotEmpty(playerColorMap.White) then
        UI.setAttribute(whiteInitiativeID, "active", "true") -- todo: activate buttons too

    end
    if isNotEmpty(playerColorMap.Red) then
        UI.setAttribute(redInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Orange) then
        UI.setAttribute(orangeInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Brown) then
        UI.setAttribute(brownInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Pink) then
        UI.setAttribute(pinkInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Purple) then
        UI.setAttribute(purpleInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Yellow) then
        UI.setAttribute(yellowInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Blue) then
        UI.setAttribute(blueInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Green) then
        UI.setAttribute(greenInitiativeID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Teal) then
        UI.setAttribute(tealInitiativeID, "active", "true")
    end
    UI.setAttribute(requestInitiativeID, "color", SELECTED_GREY)
end

function addPlayerInitiative(player, initTotal, id)
    UI.setAttribute(id, "active", "false") -- todo: activate color buttons

    addNameToGMPopup(findPlayerNameFromColor(player.color), initTotal)
end

function addNameToGMPopup(pName, initiativeTotal)
        initNameList = initNameList..pName..":"..initiativeTotal..", "
        initListForDisplay = "[" .. string.sub(initNameList, 1, string.len(initNameList)-2) .. "]"

        UI.setAttribute(gmInitTextID, "active", "true")
        UI.setAttribute(gmInitTextID, "text", initListForDisplay)

        initNamesJsonString = initNamesJsonString.."\""..pName.."\":\""..initiativeTotal.."\", "
        initNamesJsonStringToSend = "{" .. string.sub(initNamesJsonString, 1, string.len(initNamesJsonString)-2) .. "}"
        -- print("initNamesJsonStringToSend: "..initNamesJsonStringToSend)

        UI.setAttribute(gmInitiativeID, "active", "true")
        UI.setAttribute(gmInitiativeID, "color", SELECTED_GREY)

        numberInitspopulated = numberInitspopulated + 1
        if numberInitspopulated == numberOfPCs then
            UI.setAttribute(gmInitiativeID, "color", PROMPT_BLUE)
        end
end

function rollGmInitiative()
    UI.setAttribute(gmInitTextID, "active", "false")
    UI.setAttribute(gmInitiativeID, "active", "false")
    -- broadcastToAll("Rolling npcs...")
    apiRollInit()
    setUpTurnOrder()
    UI.setAttribute(requestInitiativeID, "color", PROMPT_BLUE)
end

function endCombat()
    UI.setAttribute(endTurnID, "active", "false")
    UI.setAttribute(endTurnGmID, "active", "false")
    UI.setAttribute(endCombatID, "active", "false")
    UI.setAttribute(refreshCombatID, "active", "false")
    UI.setAttribute(addTimedEffectID, "active", "false")
    closeTimedEffects()
    closeTurnOrder()
end

-- Party skill check functions:

function requestPartySkillCheck()
    if  pcSelectorActive then
        UI.setAttribute(addAPlayerID, "text", "Open Player Selector")
        UI.setAttribute(addAPlayerID, "color", PROMPT_BLUE)
        closePcSelector()
    end
    skillNameList = ""
    statsString = ""
    statsList = {}
    broadcastToAll("It\'s time for a skill check!")
    -- for each color, if a PC, activate that UI element to request skill
    if isNotEmpty(playerColorMap.White) then
        UI.setAttribute(whiteSkillID, "active", "true") -- todo add buttons
    end
    if isNotEmpty(playerColorMap.Red) then
        UI.setAttribute(redSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Orange) then
        UI.setAttribute(orangeSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Brown) then
        UI.setAttribute(brownSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Pink) then
        UI.setAttribute(pinkSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Purple) then
        UI.setAttribute(purpleSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Yellow) then
        UI.setAttribute(yellowSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Blue) then
        UI.setAttribute(blueSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Green) then
        UI.setAttribute(greenSkillID, "active", "true")
    end
    if isNotEmpty(playerColorMap.Teal) then
        UI.setAttribute(tealSkillID, "active", "true")
    end
    UI.setAttribute(requestSkillID, "color", SELECTED_GREY)
end

function addPlayerSkill(player, skillTotal, id)
    UI.setAttribute(id, "active", "false")
    name03 = findPlayerNameFromColor(player.color)
    -- print(name03)
    addNameToPartySkillPopup(name03, skillTotal)
end

function addNameToPartySkillPopup(skillName, skillTotal)
    skillNameList = skillNameList..skillName..": "..skillTotal.."\n"
    table.insert(statsList,tonumber(skillTotal))
    UI.setAttribute(skillTextID, "text", "Party Skill Results:\n"..skillNameList.."\nStatistics:\n["..getSkillStatistics().."]")
    UI.setAttribute(skillTextID, "active", "true")

    UI.setAttribute(openPartySkillViewerID, "active", "true")
    activateClosePartySkillButton()
end

function getSkillStatistics()
    
    -- get the total, mean, & median
    local sum = 0
    for _,number in pairs(statsList) do
        print("number: "..tostring(number))
        sum = sum + number
    end

    if #statsList < 2 then
        return "Total: "..tostring(sum)
    end

    local mean = sum / #(statsList)

    table.sort(statsList)
    local mid = #statsList/2
    local median = 0
    print("mid: "..tostring(mid))
    if math.floor(mid)==mid then
        median = nums[mid]
    else
        median = (statsList[math.floor(mid)]+statsList[math.ceil(mid)])/2
    end

    statsString = "Total: "..tostring(sum)..", Average: "..tostring(mean)..", Middle: "..tostring(median)
    return statsString
end

function skillPopupToggle()
    if UI.getAttribute(openPartySkillViewerID, "text") == "Open Party Skill Viewer" then
        activateClosePartySkillButton()
    else
        UI.setAttribute(openPartySkillViewerID, "text", "Open Party Skill Viewer")
        UI.setAttribute(openPartySkillViewerID, "color", PROMPT_BLUE)
        UI.setAttribute(skillTextID, "active", "false")
        UI.setAttribute(requestSkillID, "color", PROMPT_BLUE)
    end
end

function activateClosePartySkillButton()
    UI.setAttribute(openPartySkillViewerID, "text", "Close Party Skill Viewer")
    UI.setAttribute(openPartySkillViewerID, "color", BUTTON_COLOR_6)
    UI.setAttribute(skillTextID, "active", "true")
    UI.setAttribute(requestSkillID, "color", SELECTED_GREY)
end

-- Turn & time functions:

function announceTurn(currPlayer)
    if isCharacterNpc(currPlayer) then
        currPlayer = cutOutCRtext(currPlayer)
        UI.setAttribute(endTurnGmID, "color", NPC_PURPLE)
    else
        UI.setAttribute(endTurnGmID, "color", DEFAULT_RED_PINK)
    end
    currentTurnName = currPlayer
    broadcastToAll("It\'s your turn, "..currentTurnName.."!")

    noMatch = false
    if playerColorMap.White == currentTurnName then
        UI.setAttribute(endTurnID, "visibility", "white")
    else
        if playerColorMap.Yellow == currentTurnName then
            UI.setAttribute(endTurnID, "visibility", "yellow")
        else
            if playerColorMap.Orange == currentTurnName then
                UI.setAttribute(endTurnID, "visibility", "orange")
            else
                if playerColorMap.Teal == currentTurnName then
                    UI.setAttribute(endTurnID, "visibility", "teal")
                else
                    if playerColorMap.Brown == currentTurnName then
                        UI.setAttribute(endTurnID, "visibility", "brown")
                    else
                        if playerColorMap.Pink == currentTurnName then
                            UI.setAttribute(endTurnID, "visibility", "pink")
                        else
                            if playerColorMap.Purple == currentTurnName then
                                UI.setAttribute(endTurnID, "visibility", "purple")
                            else
                                if playerColorMap.Green == currentTurnName then
                                    UI.setAttribute(endTurnID, "visibility", "green")
                                else
                                    if playerColorMap.Blue == currentTurnName then
                                        UI.setAttribute(endTurnID, "visibility", "blue")
                                    else
                                        if playerColorMap.Red == currentTurnName then
                                            UI.setAttribute(endTurnID, "visibility", "red")
                                        else
                                            noMatch = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if noMatch then
        UI.setAttribute(endTurnID, "active", "false")
    else
        UI.setAttribute(endTurnID, "active", "true")
    end
end

function setNextTurn(nextPlayer)
    if isCharacterNpc(nextPlayer) then
        nextPlayer = cutOutCRtext(nextPlayer)
    end
    nextTurnName = nextPlayer

    displayTurnOrder() -- performs api call
    displayTimedEffects() -- perfmors api call
end

function announceTime(currRound)
    print("The current time is: "..currRound)
    setUpTurnOrder() -- refresh on end turn
end

function setUpTurnOrder() 
    doAPIrefresh() -- calls APIs in order

    UI.setAttribute(endTurnGmID, "active", "true")
    UI.setAttribute(endCombatID, "active", "true")
    UI.setAttribute(refreshCombatID, "active", "true")
    UI.setAttribute(addTimedEffectID, "active", "true")
end

function displayTurnOrder()
    apiGetInit() -- populates initList
end

function receiveInitiativeStr(initiativeStr)
    -- print("received: "..initiativeStr)
    initiativeOrderList = {{Name="",Bloodied=false,Armor=0,Resistances="",Reactions=""}}
    initiativeOrderList = getInitOrderListFromJsonStr(initiativeStr)
end

function getInitOrderListFromJsonStr(jsonStr)
    local initList = {}
    local responseBody = JSON.decode(jsonStr)
    for i, v in pairs( responseBody ) do
        local tempInitList = {Name="",Bloodied=false,Armor=0,Resistances="",Reactions=""}
        local cName = responseBody[i]["name"]
        if isCharacterNpc(cName) then
            cName = cutOutCRtext(cName) -- remove "(CR x)" from name
            if tonumber(responseBody[i]["hp"]) * 2 <= tonumber(responseBody[i]["hpMax"]) then
                tempInitList.Bloodied = true
            end
        end
        tempInitList.Name = cName
        tempInitList.Armor = tonumber(responseBody[i]["ac"])
        tempInitList.Resistances = responseBody[i]["resistances"]
        tempInitList.Reactions = responseBody[i]["reactions"]
        -- print(tempInitList.Effect)
        table.insert(initList,tempInitList)
        -- print(effectsList[i].Name)
    end
    return initList
end

function checkNumberOfInits()
    if initiativeOrderList == nil then return end
    numberOfPeopleInInitiative = #(initiativeOrderList)
    print("displaying "..numberOfPeopleInInitiative.." characters in initiative order")
    if numberOfPeopleInInitiative == 0 then return end
    UI.setAttribute(initTextID, "active", "true")
    UI.setAttribute(initTextID, "text", "Initiatve Order ("..numberOfPeopleInInitiative.." characters):")
    getToCurrChar()
    refresh5Inits() 
end

function getToCurrChar()
    while true do
        if isCurrChar(initiativeOrderList[fiveViewed[1]].Name) then return end
        turnOrderLeft()
    end
end

function turnOrderLeft()
    local firstTurnNum = fiveViewed[1]
    local secondTurnNum = fiveViewed[2]
    local thirdTurnNum = fiveViewed[3]
    local fourthTurnNum = fiveViewed[4]
    local fifthTurnNum = fiveViewed[5]
    -- print("left. fiveViewed numbers: "..firstTurnNum..","..secondTurnNum..","..thirdTurnNum..","..fourthTurnNum..","..fifthTurnNum)

    if fifthTurnNum == numberOfPeopleInInitiative then
        fiveViewed = {secondTurnNum, thirdTurnNum, fourthTurnNum, fifthTurnNum, 1}
    else
        if fourthTurnNum == numberOfPeopleInInitiative then
            fiveViewed = {secondTurnNum, thirdTurnNum, fourthTurnNum, 1, 2}
        else
            if thirdTurnNum == numberOfPeopleInInitiative then
                fiveViewed = {secondTurnNum, thirdTurnNum, 1, 2, 3}
            else
                if secondTurnNum == numberOfPeopleInInitiative then
                    fiveViewed = {secondTurnNum, 1, 2, 3, 4}
                else
                    if firstTurnNum == numberOfPeopleInInitiative then
                        fiveViewed = {1,2,3,4,5} -- full reset
                    else
                        fiveViewed = {firstTurnNum + 1, secondTurnNum + 1, thirdTurnNum + 1, fourthTurnNum + 1, fifthTurnNum + 1} -- regular case
                    end
                end
            end
        end
    end

    refresh5Inits()
end

function turnOrderRight()
    local firstTurnNum = fiveViewed[1]
    local secondTurnNum = fiveViewed[2]
    local thirdTurnNum = fiveViewed[3]
    local fourthTurnNum = fiveViewed[4]
    local fifthTurnNum = fiveViewed[5]
    print("right. fiveViewed numbers: "..firstTurnNum..","..secondTurnNum..","..thirdTurnNum..","..fourthTurnNum..","..fifthTurnNum)

    if firstTurnNum == 1 then
        fiveViewed = {numberOfPeopleInInitiative, 1, 2, 3, 4}
    else
        if secondTurnNum == 1 then
            fiveViewed = {numberOfPeopleInInitiative - 1,numberOfPeopleInInitiative, 1, 2, 3}
        else
            if thirdTurnNum == 1 then
                fiveViewed = {numberOfPeopleInInitiative - 2, numberOfPeopleInInitiative - 1, numberOfPeopleInInitiative, 1, 2}
            else 
                if fourthTurnNum == 1 then
                    fiveViewed = {numberOfPeopleInInitiative - 3, numberOfPeopleInInitiative - 2, numberOfPeopleInInitiative - 1, numberOfPeopleInInitiative, 1}
                else
                    if fifthTurnNum == 1 then
                        fiveViewed = {numberOfPeopleInInitiative - 4, numberOfPeopleInInitiative - 3, numberOfPeopleInInitiative - 2, numberOfPeopleInInitiative - 1, numberOfPeopleInInitiative}
                    else
                        fiveViewed = {firstTurnNum - 1, secondTurnNum - 1, thirdTurnNum - 1, fourthTurnNum - 1, fifthTurnNum - 1} -- regular case 
                    end
                end
            end
        end
    end

    refresh5Inits()
end

function refresh5Inits()
    local first = fiveViewed[1]
    local second = fiveViewed[2]
    local third = fiveViewed[3]
    local fourth = fiveViewed[4]
    local fifth = fiveViewed[5]

    if numberOfPeopleInInitiative >= 1 then
        makeInitTextButton(initSlot1ID,initiativeOrderList[first])
    end
    if numberOfPeopleInInitiative >= 2 then
        makeInitTextButton(initSlot2ID, initiativeOrderList[second])
    end
    if numberOfPeopleInInitiative >= 3 then
        makeInitTextButton(initSlot3ID, initiativeOrderList[third])
    end
    if numberOfPeopleInInitiative >= 4 then
        makeInitTextButton(initSlot4ID, initiativeOrderList[fourth])
    end
    if numberOfPeopleInInitiative >= 5 then
        makeInitTextButton(initSlot5ID, initiativeOrderList[fifth])
    end
    if numberOfPeopleInInitiative > 5 then -- have to choose 5 based on the buttons
        UI.setAttribute(turnLeftButtonID, "active", "true")
        UI.setAttribute(turnRightButtonID, "active", "true")
    else
        UI.setAttribute(turnLeftButtonID, "active", "false")
        UI.setAttribute(turnRightButtonID, "active", "false")
    end
end

function makeInitTextButton(initSlotID, initChar)
    -- print("activating "..initSlotID)
    UI.setAttribute(initSlotID, "active", "true")
    local charName = initChar.Name
    -- print("name: "..charName)
    UI.setAttribute(initSlotID, "text", charName)
    -- print("setting color to DEFAULT_BLUE_GREY")
    UI.setAttribute(initSlotID, "color", DEFAULT_BLUE_GREY) -- color default, text default
    if isCurrChar(charName) then
        UI.setAttribute(initSlotID, "color", CURRENT_GOLD) -- color gold
        -- print("setting color to CURRENT_GOLD")
    else
        if isNextChar(charName) then
            UI.setAttribute(initSlotID, "color", NEXT_PURPLE) -- color purple
            -- print("setting color to NEXT_PURPLE")
        end
    end
    UI.setAttribute(initSlotID, "textColor", BLACK)
    if initChar.Bloodied then
        UI.setAttribute(initSlotID, "textColor", END_RED) -- red text
    end
end

function isCurrChar(char01)
    return currentTurnName == char01
end

function isNextChar(char02)
    return nextTurnName == char02
end

function closeTurnOrder()
    initiativeOrderList = {}
    UI.setAttribute(turnRightButtonID, "active", "false")
    UI.setAttribute(turnLeftButtonID, "active", "false")
    UI.setAttribute(initSlot5ID, "active", "false")
    UI.setAttribute(initSlot2ID, "active", "false")
    UI.setAttribute(initSlot4ID, "active", "false")
    UI.setAttribute(initSlot3ID, "active", "false")
    UI.setAttribute(initSlot1ID, "active", "false")
    UI.setAttribute(initTextID, "active", "false")
end

-- Timed Effect functions:

function addTimedEffect(player)
    broadcastToAll(findPlayerNameFromColor(player.color).." is adding a timed effect...")
    setTimedEffectColor(player.color)
    effectName = ""
    effectTargets = ""
    effectDuration = ""
    timedEffectEffect = ""
    UI.setAttribute(addTimedEffectDurationID, "active", "true")
    UI.setAttribute(addTimedEffectTargetsID, "active", "true")
    UI.setAttribute(addTimedEffectNameID, "active", "true")
    UI.setAttribute(timedEffectEffectID, "active", "true")
    UI.setAttribute(timedEffectTextID, "active", "true")
    UI.setAttribute(cancelTimedEffectID, "active", "true")
    UI.setAttribute(confirmTimedEffectID, "active", "true")
    UI.setAttribute(addTimedEffectID, "visibility", "host") -- hide the button (host has cancel override)
    UI.setAttribute(addTimedEffectID, "text", "Cancel Timed Effect")
    if isTabletopObject then
        UI.setAttribute(addTimedEffectID, "onClick", objectGuid.."/closeTimedEffectCreator")
    else
        UI.setAttribute(addTimedEffectID, "onClick", "closeTimedEffectCreator")
    end
    UI.setAttribute(addTimedEffectID, "color", DEFAULT_RED_PINK)
end

function setTimedEffectColor(pColor)
    UI.setAttribute(addTimedEffectDurationID, "visibility", pColor)
    UI.setAttribute(addTimedEffectTargetsID, "visibility", pColor)
    UI.setAttribute(addTimedEffectNameID,"visibility", pColor)
    UI.setAttribute(timedEffectEffectID, "visibility", pColor)
    UI.setAttribute(timedEffectTextID, "visibility", pColor)
    UI.setAttribute(cancelTimedEffectID, "visibility", pColor)
    UI.setAttribute(confirmTimedEffectID, "visibility", pColor)
end

function closeTimedEffectCreator()
    UI.setAttribute(addTimedEffectDurationID, "active", "false")
    UI.setAttribute(addTimedEffectTargetsID, "active", "false")
    UI.setAttribute(addTimedEffectNameID, "active", "false")
    UI.setAttribute(timedEffectEffectID, "active", "false")
    UI.setAttribute(timedEffectTextID, "active", "false")
    UI.setAttribute(cancelTimedEffectID, "active", "false")
    UI.setAttribute(confirmTimedEffectID, "active", "false")
    UI.setAttribute(addTimedEffectID, "visibility", "") -- show the button to all players again
    UI.setAttribute(addTimedEffectID, "text", "Add Timed Effect")
    if isTabletopObject then
        UI.setAttribute(addTimedEffectID, "onClick", objectGuid.."/addTimedEffect")
    else
        UI.setAttribute(addTimedEffectID, "onClick", "addTimedEffect")
    end
    setTimedEffectColor("host")
    UI.setAttribute(addTimedEffectID, "color", PROMPT_BLUE)
end

function addTimedEffectName(player, effName, id)
    effectName = effName
end

function addTimedEffectEffect(player, effectEffect, id)
    timedEffectEffect = effectEffect
end

function addTimedEffectTargets(player, targets, id)
    effectTargets = targets
end

function addTimedEffectDuration(player, duration, id)
    effectDuration = duration
end

function confirmTimedEffect(player, id)
    timedEffectListToSend = "{\"name\":\""..effectName.."\",\"effect\":\""..timedEffectEffect.."\",\"targets\":\""..effectTargets.."\",\"durationRounds\":"..effectDuration.."}"
    -- print("timedEffectListToSend: "..timedEffectListToSend)
    apiAddTimedEffect(timedEffectListToSend, player.color)
    closeTimedEffectCreator()
    displayTimedEffects()
end

function receiveTimedEffects(timedEffectsStr)
    -- print("received: "..timedEffectsStr)
    timedEffectsList = {{Name="",Effect="",Targets="",RoundsLeft=""}}
    timedEffectsList = getTimedEffectListFromJson(timedEffectsStr)
    -- print(timedEffectsList[1].Name)
end

function getTimedEffectListFromJson(timedEffectJsonStr)
    local effectsList = {}
    local responseBody = JSON.decode(timedEffectJsonStr)
    for i, v in pairs( responseBody ) do
        local tempEffectList = {Name="",Effect="",Targets="",RoundsLeft=""}
        tempEffectList.Name = responseBody[i]["name"]
        tempEffectList.Effect = responseBody[i]["effect"]
        tempEffectList.Targets = responseBody[i]["targets"]
        tempEffectList.RoundsLeft = responseBody[i]["timeLeft"]
        -- print(tempEffectList.Effect)
        table.insert(effectsList,tempEffectList)
        -- print(effectsList[i].Name)
    end
    return effectsList
end

function displayTimedEffects() -- appear only in combat, dissapear when combat ends
    apiGetTimedEffects() --calls receiveTimedEffects & checkNumberOfEffects
end

function checkNumberOfEffects()
    if timedEffectsList == nil then return end
    numberOfEffects = #(timedEffectsList)
    print("displaying "..numberOfEffects.." timed events")
    if numberOfEffects == 0 then return end
    UI.setAttribute(displayTimedEffectsTextID, "active", "true")
    UI.setAttribute(displayTimedEffectsTextID, "text", "Current Effects ("..numberOfEffects.."):")
    refresh3TimedEffects() 
end

function timedEffectsUp()
    local firstEffectNum = threeViewed[1]
    local secondEffectNum = threeViewed[2]
    local thirdEffectNum = threeViewed[3]
    -- print("up. threeViewed numbers: "..firstEffectNum..","..secondEffectNum..","..thirdEffectNum)

    if thirdEffectNum == numberOfEffects then
        threeViewed = {secondEffectNum, thirdEffectNum, 1}
    else
        if secondEffectNum == numberOfEffects then
            threeViewed = {secondEffectNum, 1, 2}
        else
            if firstEffectNum == numberOfEffects then -- full reset
                threeViewed = {1,2,3}
            else -- regular case
                threeViewed = {firstEffectNum + 1, secondEffectNum + 1, thirdEffectNum + 1}
            end
        end
    end

    refresh3TimedEffects()
end

function timedEffectsDown()
    local firstEffectNum = threeViewed[1]
    local secondEffectNum = threeViewed[2]
    local thirdEffectNum = threeViewed[3]
    -- print("down. threeViewed numbers: "..firstEffectNum..","..secondEffectNum..","..thirdEffectNum)

    if firstEffectNum == 1 then
        threeViewed = {numberOfEffects, 1, 2}
    else
        if secondEffectNum == 1 then
            threeViewed = {numberOfEffects - 1, numberOfEffects, 1}
        else
            if thirdEffectNum == 1 then
                threeViewed = {numberOfEffects - 2, numberOfEffects - 1, numberOfEffects}
            else -- regular case
                threeViewed = {firstEffectNum - 1, secondEffectNum - 1, thirdEffectNum - 1}
            end
        end
    end

    refresh3TimedEffects()
end

function refresh3TimedEffects()
    local first = threeViewed[1]
    local second = threeViewed[2]
    local third = threeViewed[3]

    if numberOfEffects >= 1 then
        UI.setAttribute(timedEffect1ID, "active", "true")
        local timedEffect1 = timedEffectsList[first]
        local firstText = timedEffect1.Name..": "..timedEffect1.Effect.."\nTargets: "..timedEffect1.Targets.."\nRounds left: "..timedEffect1.RoundsLeft
        UI.setAttribute(timedEffect1ID, "text", firstText)
    end
    if numberOfEffects >= 2 then
        UI.setAttribute(timedEffect2ID, "active", "true")
        local timedEffect2 = timedEffectsList[second]
        local secondText = timedEffect2.Name..": "..timedEffect2.Effect.."\nTargets: "..timedEffect2.Targets.."\nRounds left: "..timedEffect2.RoundsLeft
        UI.setAttribute(timedEffect2ID, "text", secondText)
    end
    if numberOfEffects >= 3 then
        UI.setAttribute(timedEffect3ID, "active", "true")
        local timedEffect3 = timedEffectsList[third]
        local thirdText = timedEffect3.Name..": "..timedEffect3.Effect.."\nTargets: "..timedEffect3.Targets.."\nRounds left: "..timedEffect3.RoundsLeft
        UI.setAttribute(timedEffect3ID, "text", thirdText)
    end
    if numberOfEffects > 3 then -- have to choose 3 based on the buttons
        UI.setAttribute(timedEffectsUpID, "active", "true")
        UI.setAttribute(timedEffectsDownID, "active", "true")
    else
        UI.setAttribute(timedEffectsUpID, "active", "false")
        UI.setAttribute(timedEffectsDownID, "active", "false")
    end
end

function closeTimedEffects()
    timedEffectsList = {}
    UI.setAttribute(timedEffectsUpID, "active", "false")
    UI.setAttribute(timedEffectsDownID, "active", "false")
    UI.setAttribute(timedEffect1ID, "active", "false")
    UI.setAttribute(timedEffect2ID, "active", "false")
    UI.setAttribute(timedEffect3ID, "active", "false")
    UI.setAttribute(displayTimedEffectsTextID, "active", "false")
end

-- API functions:

function doAPIrefresh()
    getCurrentPlayer() -- announces turn & sets End Turn button
    -- goes to call getNextPlayer(), whiich calls the disaply functions
end

function loadPlayerData()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_PCS_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            makePcList(request.text);
        end
    end)
end

function apiAddToMap(name)
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. ADD_TO_MAP_PATH
    -- print("url: " .. url)
    WebRequest.post(url, name, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        -- else
            -- print(request.text);
        end
    end)
end

function apiRollInit()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. ROLL_INITIATIVE_PATH
    -- print("url: " .. url)
    WebRequest.post(url, initNamesJsonStringToSend, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        -- else
        --     print(request.text)
        end
    end)
end

function apiGetInit()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_INITIATIVE_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            receiveInitiativeStr(request.text) -- converts to list
            checkNumberOfInits() -- populates the textButtons
        end
    end)
    
end

function apiGetTimedEffects()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_TIMED_EFFECTS_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            receiveTimedEffects(request.text) -- convert to a list
            checkNumberOfEffects() -- will populate the textButtons
        end
    end)
end

function apiAddTimedEffect(timedEffectList, pColor)
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. ADD_TIMED_EFFECT_PATH
    -- print("url: " .. url)
    WebRequest.post(url, timedEffectList, function(request)
        if request.response_code > 399 then
            -- print("color: "..pColor)
            broadcastToColor("Unable to add timed effect.", pColor)
        else
            broadcastToColor("Added timed effect:\n"..timedEffectList, pColor)
        end
    end)
end

function getCurrentPlayer()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_CURRENT_PLAYER_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            announceTurn(request.text);
            getNextPlayer()
        end
    end)
end

function getNextPlayer()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. GET_NEXT_PLAYER_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            setNextTurn(request.text);
        end
    end)
end

function apiEndTurn()
    url = "http://" .. IP_ADDRESS .. ":" .. PORT .. NEXT_TURN_PATH
    -- print("url: " .. url)
    WebRequest.get(url, function(request)
        if request.is_error then
            print("error: " .. request.error)
            log(request.error)
        else
            announceTime(request.text);
        end
    end)
end

-- Utility functions:

function findPlayerNameFromColor(playerColor)
    -- find player name
    if playerColor == "Purple" then
        playerName = playerColorMap.Purple
    else
        if playerColor == "Red" then
            playerName = playerColorMap.Red
        else
            if playerColor == "Blue" then
                playerName = playerColorMap.Blue
            else
                if playerColor == "Orange" then
                    playerName = playerColorMap.Orange
                else
                    if playerColor == "Green" then
                        playerName = playerColorMap.Green
                    else
                        if playerColor == "Brown" then
                            playerName = playerColorMap.Brown
                        else
                            if playerColor == "Yellow" then
                                playerName = playerColorMap.Yellow
                            else
                                if playerColor == "Teal" then
                                    playerName = playerColorMap.Teal
                                else
                                    if playerColor == "White" then
                                        playerName = playerColorMap.White
                                    else
                                        if playerColor == "Pink" then
                                            playerName = playerColorMap.Pink
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if playerName == nil or playerName == "" then
        playerName = "Somebody"
    end
    -- print("player name: " .. playerName)
    return playerName
end

function isPlayerInColorMap(potentialPlayerName)
    return playerColorMap.White == potentialPlayerName or playerColorMap.Red == potentialPlayerName or playerColorMap.Brown == potentialPlayerName or playerColorMap.Orange == potentialPlayerName or playerColorMap.Yellow == potentialPlayerName or playerColorMap.Green == potentialPlayerName or playerColorMap.Teal == potentialPlayerName or playerColorMap.Blue == potentialPlayerName or playerColorMap.Purple == potentialPlayerName or playerColorMap.Pink == potentialPlayerName
end

function shaveString(inputstr)
    return string.sub(inputstr, 2, string.len(inputstr)-1)
end

function mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function isNotEmpty(s)
    return s ~= nil and s ~= ''
end

function isCharacterNpc(str)
    if str:find(CR_STRING) then
        return true
    else
        return false
    end
end

function cutOutCRtext(str)
    -- print("CR str: " .. CR_STRING..", name: "..str)
    p, q = str:find(CR_STRING)
    r, s = str:find(CR_STRING_2)
    if r ~= nil then -- numbered npc, add the number
        local stringA = string.sub(str, 1, p-1)
        local stringB = string.sub(str, r+1, string.len(str))
        str = stringA..stringB
    else -- un-numbered npc
        str = string.sub(str, 1, p-2) -- cut off the space too
    end
    -- print("non CR str: "..str)
    return str
end

-- Object XML Utility functions:

function onObjectSpawn(object)
    objectGuid = object.getGUID()
    print("GUID: "..objectGuid)
    isTabletopObject = true
    setupObjectXmlUI()
end

function setupObjectXmlUI()
    local newXML = replaceXmlGuid(XML_STRING, objectGuid)
    UI.setXml(newXML)
end

function replaceXmlGuid(xml, guid)
    print("XML: "..xml)
    xml = xml:gsub(XML_REPLACE, [[onClick = "]]..guid..[[/]]) -- replace onClick = "
    xml = xml:gsub(XML_REPLACE_2, [[onEndEdit = "]]..guid..[[/]]) -- replace onEndEdit = "
    print("New XML: "..xml)
    return xml
end


-- Recursive XML functions:

-- characters = {"Sam", "Frodo", "Bilbo", "Gandalf", "Saruman"}

-- function getElementByIdFromRoot(root, id)
--     for _,childTable in pairs(root) do
--         local table = childTable
--         local foundElement = getElementById(table, id)
--         if foundElement != nil then 
--             return foundElement
--         end
--     end
--     return nil
-- end

-- function getElementById(xmlTable, id)
--     local parentTable = xmlTable

--     if parentTable[ATTRIBUTES] != nil and parentTable[ATTRIBUTES][ID] != nil and parentTable[ATTRIBUTES][ID] == id then
--         return parentTable

--     else
--             if type(parentTable[CHILDREN]) == "table" then
--                 for _, childTable in pairs(parentTable[CHILDREN]) do
--                     parentTable = childTable
--                     local foundElement = getElementById(parentTable,id)
--                     if foundElement != nil then
--                         return foundElement
--                     end
--                 end  
--             end

--     end

--     return nil
-- end

-- function buildInitiativeRow(fullInitiativeOrder)
--     UI.setAttribute(turnOrderID, "active", "true")

--     local gottenElement = getElementByIdFromRoot(UI.getXmlTable() , "nestedInnerPanelLeft")

--     broadcastToAll(gottenElement[ATTRIBUTES][ID])
--     --we have to locate the xml element that will contain 
    
--     -- now populate the xml:


--     for _, characterName in ipairs(fullInitiativeOrder) do
--         broadcastToAll(characterName)
--     end
-- end
