local basalt = require("basalt")

local lastSelected, mode = 1, 1

local plusImage={{    {
    "                         ",
    "000000000000000000000000",
    "ffffffffffffffffffffffff",
  },
  {
    "                         ",
    "000000000000000000000000",
    "ffffffffffffffffffffffff",
  },
  {
    "                    ",
    "000000000077780000000000",
    "ffffffffff8887ffffffffff",
  },
  {
    "                    ",
    "00000000007ff80000000000",
    "ffffffffff8887ffffffffff",
  },
  {
    "                    ",
    "00000000007ff80000000000",
    "ffffffffff8887ffffffffff",
  },
  {
    "          ",
    "00000777777ff77777800000",
    "fffff88888888888887fffff",
  },
  {
    "          ",
    "00000888887f788888800000",
    "fffff77777888777777fffff",
  },
  {
    "                    ",
    "00000000007ff80000000000",
    "ffffffffff8887ffffffffff",
  },
  {
    "                    ",
    "00000000007f780000000000",
    "ffffffffff8887ffffffffff",
  },
  {
    "                    ",
    "000000000088880000000000",
    "ffffffffff7777ffffffffff",
  },
  {
    "                        ",
    "000000000000000000000000",
    "ffffffffffffffffffffffff",
  },
  {
    "                        ",
    "000000000000000000000000",
    "ffffffffffffffffffffffff",
  },}}

local availableColors = {"cyan", "purple", "brown", "orange", "red", "gray", "magenta", "blue", "lightBlue", "green", "lightGray", "pink", "black", "white", "black", "lime"}
local img

local main = basalt.createFrame("base"):setBackground(colors.lightGray)
basalt.setRenderingThrottle(0)

-- Notification Message
local notifications = {}
local activeNotifications = 0

local blitTable = {}
local mainColor, secondColor = "0", "f"
local text, text2 = " ", " "
local xO, yO = 0, 0

local latestPath = ""

local function tableCount(t)
    local n = 0
    if(t~=nil)then
        for k,v in pairs(t)do
            n = n + 1
        end
    end
    return n
end

local function getFreeNotification()
    for k,v in pairs(notifications)do
        if not(v.active)then
            return k
        end
    end
    return #notifications + 1
end

local function sendNotification(title, info, time)
    freeNotification = getFreeNotification()
    if(notifications[freeNotification]==nil)then
        notifications[freeNotification] = {}
        notifications[freeNotification].frame = main:addFrame():setSize(30, 5):setZIndex(25)
        notifications[freeNotification].title = notifications[freeNotification].frame:addLabel():setForeground(colors.lightGray):setPosition(2, 1)
        notifications[freeNotification].label = notifications[freeNotification].frame:addLabel():setSize("parent.w - 3", "parent.h - 2"):setPosition(2, 3):setForeground(colors.black)
        notifications[freeNotification].show = main:addAnimation()
        notifications[freeNotification].hide = main:addAnimation()
    end
    local selectedNotification = notifications[freeNotification]
    selectedNotification.active = true
    local notificationOffset = (freeNotification-1)*6
    selectedNotification.frame:setPosition("parent.w + 2", "parent.h - 5 - "..notificationOffset)
    selectedNotification.frame:show()
    selectedNotification.title:setText(title)
    selectedNotification.label:setText(info)
    basalt.schedule(function()
        selectedNotification.show:clear()
        selectedNotification.show:setMode("easeOutBounce")
        selectedNotification.show:setObject(selectedNotification.frame)
        selectedNotification.show:move(main:getWidth() - 30, main:getHeight() - 5 - notificationOffset, 1)
        selectedNotification.show:onDone(function()
            selectedNotification.frame:setPosition("parent.w - 30", "parent.h - 5 - "..notificationOffset)
        end)
        selectedNotification.show:play()
        sleep(time or 4)
        selectedNotification.hide:clear()
        selectedNotification.hide:setObject(selectedNotification.frame)
        selectedNotification.hide:move(main:getWidth() + 2, main:getHeight() - 5 - notificationOffset, 1)
        selectedNotification.hide:onDone(function()
            selectedNotification.frame:setPosition("parent.w + 2", "parent.h - 5 - "..notificationOffset)
            selectedNotification.frame:hide()
        end)
        selectedNotification.hide:play()
        activeNotifications = activeNotifications - 1
        selectedNotification.active = false
    end)()
end

-- Show Image Frame
local showImageFrame = main:addFrame():setSize("parent.w", "parent.h"):setZIndex(100):setBackground(colors.black):hide()
local showImg = showImageFrame:addImage():setSize("parent.w", "parent.h")

main:onKey(function(key)
    showImageFrame:hide()
    basalt.resetPalette()
end)
--

-- Topbar
local topbar = main:addFrame("sub"):setSize("parent.w", 1):setZIndex(30)
local fileButton = topbar:addButton():setPosition(2, 1):setSize(4, 1):setText("File")
local editButton = topbar:addButton():setPosition(10, 1):setSize(4, 1):setText("Edit")
topbar:addButton():setPosition(18, 1):setSize(4, 1):setText("Show"):onClick(function()
    showImageFrame:show()
    showImg:setImage(img:getImage()):usePalette(true):play(true)
end)

local menuFileFrame = main:addFrame():setSize(12, 11):setPosition(1, -14):setZIndex(18):setShadow(colors.black)

local menuFileOpened = false
local editFile
local function menuFile(open, ignore)
    if(menuFileOpened)and(open~=true)then
        menuFileFrame:animatePosition(1, -14, 0.3)
        menuFileOpened = false
    elseif not(menuFileOpend)and(open==true)or(open==nil)then
        menuFileFrame:animatePosition(1, 2, 0.3)
        menuFileFrame:setFocus()
        menuFileOpened = true
    end
    if(ignore)then return end
    editFile(false, true)
end

menuFileFrame:onLoseFocus(function()
    menuFile(false, true)
end)

local editFileFrame = main:addFrame():setSize(12, 11):setPosition(6, -14):setZIndex(18):setShadow(colors.black)
local editFileOpened = false
function editFile(open, ignore)
    if(editFileOpened)and(open~=true)then
        editFileFrame:animatePosition(6, -14, 0.3)
        editFileOpened = false
    elseif not(menuFileOpend)and(open==true)or(open==nil)then
        editFileFrame:animatePosition(6, 2, 0.3)
        editFileFrame:setFocus()
        editFileOpened = true
    end
    if(ignore)then return end
    menuFile(false, true)
end

editFileFrame:onLoseFocus(function()
    editFile(false, true)
end)


fileButton:onClick(function()
    menuFile()
end)
editButton:onClick(function()
    editFile()
end)
--


-- Config Window:

local function sendModeNotification()
    if(mode==1)then sendNotification("Mode", "Background", 2)
    elseif(mode==2)then sendNotification("Mode", "Foreground", 2)
    elseif(mode==3)then sendNotification("Mode", "Text", 2)
    elseif(mode==4)then sendNotification("Mode", "Background, Text", 2)
    elseif(mode==5)then sendNotification("Mode", "Foreground, Text", 2)
    elseif(mode==6)then sendNotification("Mode", "Background, Foreground", 2)
    elseif(mode==7)then sendNotification("Mode", "Background, Foreground, Text", 2)
    elseif(mode==8)then sendNotification("Mode", "Custom Mode: Blit", 2)
    end
end

local config = main:addFrame():setSize(15, "parent.h-1"):setPosition(main:getWidth() + 14, 2)
config:animatePosition(main:getWidth()-14, 2, nil, nil, nil, function(self)
    config:setPosition("parent.w - 14", 2)
end)
config:onDrag(function(self, event, btn, x, y, xOffset, yOffset)
    local xPos, yPos = config:getPosition()
    if(xPos-xOffset<=main:getWidth())and(xPos-xOffset>=main:getWidth()-14)then
        config:setPosition("parent.w - "..main:getWidth() - xPos+xOffset, yPos)
    end
end)

local ascii = config:addScrollableFrame():setSize(config:getWidth()-3, 7):setPosition(2,12):setBackground(colors.gray)
config:addButton():setText(" "):setPosition("parent.w", "parent.h"):setZIndex(50):setSize(2, 1):onDrag(function(self, event, btn, xOffset, yOffset)
    local w, h = config:getSize()
    local wOff, hOff = w, h
    if(h+yOffset-1>=15)and(h+yOffset-1<=50)then
        hOff = h+yOffset-1
    end
    config:setSize(wOff, hOff)
end)

local textInput = config:addInput():setBackground(colors.black):setForeground(colors.lightGray):setPosition(2, 10):setSize(6, 1):onChange(function(self, v)
    text = v=="" and " " or v
end):onGetFocus(function() lastSelected = 1 end)
local textInput2 = config:addInput():setBackground(colors.black):setForeground(colors.lightGray):setPosition(9, 10):setSize(6, 1):onChange(function(self, v)
    text2 = v=="" and " " or v
end):onGetFocus(function() lastSelected = 2 end)

local modes = config:addMenubar():setPosition(3, 7):setSize("parent.w - 5", 1)
    :setSelectionColor(colors.gray, colors.lightGray)
    :setSpace(1)
    :setScrollable()
    :addItem("B")
    :addItem("F")
    :addItem("T")
    :addItem("BT")
    :addItem("FT")
    :addItem("BF")
    :addItem("BFT")
    :onChange(function(self)
        mode = self:getItemIndex()
        sendModeNotification()
    end)

local function changeMode(m)
    mode = m
    modes:selectItem(m)
end

local x,y = 1,1
local w = ascii:getSize()
for i=1,255 do
    ascii:addButton():setSize(1,1):setText(string.char(i)):setPosition(x,y):onClick(function(self, _, btn)
        if(btn==2)then
            if(lastSelected==1)then
                textInput:setValue(textInput:getValue()..string.char(i))
            else
                textInput2:setValue(textInput2:getValue()..string.char(i))
            end
        else
            if(lastSelected==1)then
                textInput:setValue(string.char(i))
            else
                textInput2:setValue(string.char(i))
            end
        end
        if(mode<3)then changeMode(3) end
    end)
    x = x + 1
    if(x>w)then
        x = 1
        y = y + 1
    end
end

local blitCanvas = config:addFrame():setZIndex(5):setPosition(2,2)
blitCanvas:setBackground(colors.black):setSize("parent.w - 15", "parent.h - 6")
local graphicFrameColors = {
    ["0"] = config:addButton():setPosition(3, 3):setBackground(colors.white):setSize(1,1):setText("1"),
    ["1"] = config:addButton():setPosition(4, 3):setBackground(colors.orange):setSize(1,1):setText(" "),
    ["2"] = config:addButton():setPosition(5, 3):setBackground(colors.magenta):setSize(1,1):setText(" "),
    ["3"] = config:addButton():setPosition(6, 3):setBackground(colors.lightBlue):setSize(1,1):setText(" "),
    ["4"] = config:addButton():setPosition(7, 3):setBackground(colors.yellow):setSize(1,1):setText(" "),
    ["5"] = config:addButton():setPosition(8, 3):setBackground(colors.lime):setSize(1,1):setText(" "),
    ["6"] = config:addButton():setPosition(9, 3):setBackground(colors.pink):setSize(1,1):setText(" "),
    ["7"] = config:addButton():setPosition(10, 3):setBackground(colors.gray):setSize(1,1):setText(" "),
    ["8"] = config:addButton():setPosition(3, 4):setBackground(colors.lightGray):setSize(1,1):setText(" "),
    ["9"] = config:addButton():setPosition(4, 4):setBackground(colors.cyan):setSize(1,1):setText(" "),
    ["a"] = config:addButton():setPosition(5, 4):setBackground(colors.purple):setSize(1,1):setText(" "),
    ["b"] = config:addButton():setPosition(6, 4):setBackground(colors.blue):setSize(1,1):setText(" "),
    ["c"] = config:addButton():setPosition(7, 4):setBackground(colors.brown):setSize(1,1):setText(" "),
    ["d"] = config:addButton():setPosition(8, 4):setBackground(colors.green):setSize(1,1):setText(" "),
    ["e"] = config:addButton():setPosition(9, 4):setBackground(colors.red):setSize(1,1):setText(" "),
    ["f"] = config:addButton():setPosition(10, 4):setBackground(colors.black):setSize(1,1):setForeground(colors.white):setText("2"),
}


local function colorSetup(obj, color)
    obj:onClick(function(self, event, btn)
        if(btn==1)then
            if(secondColor == color)then return end
            mainColor = color
        elseif(btn==2)then
            if(mainColor == color)then return end
            secondColor = color
        end
        for k,v in pairs(graphicFrameColors)do
            if(k==mainColor)then
                v:setText("1")
            elseif(k==secondColor)then
                v:setText("2")
            else
                v:setText(" ")
            end
        end
        if(mode==3)then changeMode(1) end
    end)
end


for k,v in pairs(graphicFrameColors)do
    colorSetup(v, k)
end
--

-- Image Editor
img = main:addImage():setPosition(1, 2):setBackground(colors.black , "\127", colors.gray):setSize("parent.w", "parent.h-1")
local canvasSizeDrag = main:addButton("cSD"):setPosition(-1, -1):setSize(1,1):setText("\23"):setZIndex(8):setBackground(colors.black):setForeground(colors.lightGray)
local canvasAllowAutoSize = main:addCheckbox():setValue(true):setPosition("cSD.x + 1", "cSD.y"):setZIndex(8)

local function saveBimg(path)
    if not(path=="")then
        if not(path:find(".bimg"))then path = path..".bimg" end
        local f = fs.open(path, "w")
        sendNotification("Info", "Successfully saved to "..path)
        f.write(textutils.serialize(img:getImage()))
        f.close()
    else
        sendNotification("Info", "Error - invalid path!")
    end
end

local function canvasSizeDragPosition()
    local xOffset, yOffset = img:getOffset()
    local wI, hI = img:getImageSize()
    --canvasSizeDrag:setPosition(wI+1+xOffset, hI+1+yOffset)
end

local function canvasClickHandler(btn, x, y)
    --setFileSubVisiblity(false)
    --setEditSubVisiblity(false)
    local xOffset, yOffset = img:getOffset()
    x = x-xOffset
    y = y-yOffset
    if(x<1)or(y<1)then return end
    if not(canvasAllowAutoSize:getValue())then
        local wI, hI = img:getImageSize() 
        if(x > wI)then return end
        if(y > hI)then return end
    end

    if(mode==1)then
        if(btn==1)then
            img:setBg(mainColor, x, y)
        elseif(btn==2)then
            img:setBg(secondColor, x, y)
        end
    end
    if(mode==4)or(mode==7)then
        if(btn==1)then
            img:setBg(mainColor:rep(#text), x, y)
        else
            img:setBg(mainColor:rep(#text2), x, y)
        end
    end
    if(mode==2)then
        if(btn==1)then
            img:setFg(mainColor, x, y)
        elseif(btn==2)then
            img:setFg(secondColor, x, y)
        end
    end
    if(mode==5)then
        if(btn==1)then
            img:setFg(mainColor:rep(#text), x, y)
        else
            img:setFg(mainColor:rep(#text2), x, y)
        end
    end
    if(mode==7)then
        if(btn==1)then
            img:setFg(secondColor:rep(#text), x, y)
        else
            img:setFg(secondColor:rep(#text2), x, y)
        end
    end
    if(mode==6)then
        if(btn==1)then
            img:setBg(mainColor, x, y)
            img:setFg(secondColor, x, y)
        else
            img:setFg(mainColor, x, y)
            img:setBg(secondColor, x, y)
        end
    end
    if(mode==3)or(mode==4)or(mode==5)or(mode==7)then
        if(btn==1)then
            img:setText(text, x, y)
        elseif(btn==2)then
            img:setText(text2, x, y)
        end
    end
    if(mode==8)then
        if(btn==1)then
            for k,v in pairs(blitTable)do
                img:setText(v[1], x, y+k-1)
                img:setFg(v[2], x, y+k-1)
                img:setBg(v[3], x, y+k-1)
            end
        elseif(btn==2)then
            for k,v in pairs(blitTable)do
                img:setText(v[1], x, y+k-1)
                img:setBg(v[2], x, y+k-1)
                img:setFg(v[3], x, y+k-1)
            end
        end
    end
    canvasSizeDragPosition()
end

img:onDrag(function(self, event, btn, x, y, xOffset, yOffset)
    if(basalt.isKeyDown(keys.leftCtrl))then
        img:setOffset(-xOffset, -yOffset, true)
        xO = xO-xOffset
        yO = yO-yOffset
        canvasSizeDragPosition()
    else
        canvasClickHandler(btn, x, y)
    end
    --updateInfoLabel()
end)

img:onClick(function(self, event, btn, x, y, xOffset, yOffset)
    basalt.setRenderingThrottle(50)
end)
main:onClickUp(function()
    basalt.setRenderingThrottle(0)
end)
img:onClickUp(function(self, event, btn, x, y)
    if not(basalt.isKeyDown(keys.leftCtrl))then
        if(img:isFocused())then canvasClickHandler(btn, x, y) end
    end
    basalt.setRenderingThrottle(0)
end)
-- Menu File

---- New File
local newFileFrame = main:addFrame():setSize(30, 7):setShadow(colors.black)
newFileFrame:setPosition(main:getWidth()/2-newFileFrame:getWidth()/2, -14):onLoseFocus(function(self)
    newFileFrame:animatePosition(main:getWidth()/2-self:getWidth()/2, -14, 0.5)
end)
newFileFrame:addLabel():setText("New File"):setPosition(2, 1)
local newFileInput = newFileFrame:addInput():setPosition(2, 3):setSize("parent.w - 2", 1)
local newFileConfirm = newFileFrame:addButton():setPosition("parent.w - 8", "parent.h - 1"):setSize(8, 1):setBackground(colors.black):setForeground(colors.lightGray):setText("Create"):onClick(function()
    if(newFileInput:getValue()~="")then
        local file = io.open(newFileInput:getValue(), "w")
        file:write("")
        file:close()
        img:clear()
        latestPath = newFileInput:getValue()
        newFileFrame:animatePosition(main:getWidth()/2-newFileFrame:getWidth()/2, -14, 0.5)
    end
end)
local newFileCancel = newFileFrame:addButton():setPosition(2, "parent.h - 1"):setSize(8, 1):setBackground(colors.black):setForeground(colors.lightGray):setText("Cancel"):onClick(function()
    newFileInput:setValue("")
    newFileFrame:animatePosition(main:getWidth()/2-newFileFrame:getWidth()/2, -14, 0.5)
end)
----

---- Open File
local openFileFrame = main:addFrame():setSize(30, 7):setShadow(colors.black)
openFileFrame:setPosition(main:getWidth()/2-openFileFrame:getWidth()/2, -14):onLoseFocus(function(self)
    openFileFrame:animatePosition(main:getWidth()/2-self:getWidth()/2, -14, 0.5)
end)
openFileFrame:addLabel():setText("Path:"):setPosition(2, 1)
local openFileInput = openFileFrame:addInput():setPosition(2, 3):setSize("parent.w - 2", 1)
local openFileConfirm = openFileFrame:addButton():setPosition("parent.w - 8", "parent.h - 1"):setSize(8, 1):setBackground(colors.black):setForeground(colors.lightGray):setText("Open"):onClick(function()
    local path = openFileInput:getValue()
    if(not(fs.exists(path))and(not(fs.exists(path..".bimg")))or(path=="")or(path=="/"))then
        sendNotification("Error", "Path "..path.." doesn't exist!")
        openFileFrame:animatePosition(main:getWidth()/2-openFileFrame:getWidth()/2, -14, 0.5)
        openFileInput:setValue("")
        return
    end
    img:clear()
    img:loadImage(fs.exists(path) and path or path..".bimg")
    latestPath = fs.exists(path) and path or path..".bimg"
    openFileFrame:animatePosition(main:getWidth()/2-openFileFrame:getWidth()/2, -14, 0.5)
    sendNotification("Image", "Successfully opened "..latestPath)
end)

local openFileCancel = openFileFrame:addButton():setPosition(2, "parent.h - 1"):setSize(8, 1):setBackground(colors.black):setForeground(colors.lightGray):setText("Cancel"):onClick(function()
    openFileInput:setValue("")
    openFileFrame:animatePosition(main:getWidth()/2-openFileFrame:getWidth()/2, -14, 0.5)
end)
----

local newFile = menuFileFrame:addButton():setText("New File"):setPosition(1,2):setSize("parent.w", 1):onClick(function() 
    newFileFrame:animatePosition(main:getWidth()/2-newFileFrame:getWidth()/2, 3, 0.5)
    newFileFrame:setFocus()
end)

local openFile = menuFileFrame:addButton():setText("Open File"):setPosition(1,4):setSize("parent.w", 1):onClick(function() 
    openFileFrame:animatePosition(main:getWidth()/2-openFileFrame:getWidth()/2, 3, 0.5)
    openFileFrame:setFocus()
end)



---- Save File As
local saveFileAsFrame = main:addFrame():setSize(30, 7):setShadow(colors.black)
saveFileAsFrame:setPosition(main:getWidth()/2-saveFileAsFrame:getWidth()/2, -14):onLoseFocus(function(self)
    saveFileAsFrame:animatePosition(main:getWidth()/2-self:getWidth()/2, -14, 0.5)
end)
saveFileAsFrame:addLabel():setText("Path:"):setPosition(2, 1)
local saveFileAsInput = saveFileAsFrame:addInput():setPosition(2, 3):setSize("parent.w - 2", 1)
local saveFileAsConfirm = saveFileAsFrame:addButton():setPosition("parent.w - 8", "parent.h - 1"):setSize(8, 1):setBackground(colors.black):setForeground(colors.lightGray):setText("Save"):onClick(function()
    local path = saveFileAsInput:getValue()
    saveBimg(path)
    latestPath = path
end)

local saveFileAsCancel = saveFileAsFrame:addButton():setPosition(2, "parent.h - 1"):setSize(8, 1):setBackground(colors.black):setForeground(colors.lightGray):setText("Cancel"):onClick(function()
    saveFileAsInput:setValue("")
    saveFileAsFrame:animatePosition(main:getWidth()/2-saveFileAsFrame:getWidth()/2, -14, 0.5)
end)
----

local saveFile = menuFileFrame:addButton():setText("Save"):setPosition(1,6):setSize("parent.w", 1):onClick(function()
    saveBimg(latestPath)
end)
local saveFileAs = menuFileFrame:addButton():setText("Save As"):setPosition(1,8):setSize("parent.w", 1):onClick(function() 
    saveFileAsFrame:animatePosition(main:getWidth()/2-saveFileAsFrame:getWidth()/2, 3, 0.5)
    saveFileAsFrame:setFocus()
end)
local quit = menuFileFrame:addButton():setText("Quit"):setPosition(1,10):setSize("parent.w", 1):onClick(function() basalt.stop() end)
-- 

-- Menu Edit
local metadataEdit = main:addFrame():setSize(39, 25):setPosition("parent.w/2 - self.w/2", -30):setBackground(colors.gray):setZIndex(20):setShadow(colors.black)
metadataEdit:setTheme({ButtonBG = colors.black, ButtonText = colors.lightGray, InputBG = colors.black, InputText = colors.lightGray})
metadataEdit:onLoseFocus(function(self)
    metadataEdit:animatePosition(main:getWidth() / 2 - metadataEdit:getWidth() / 2, -30, 0.5)
end)

editFileFrame:addButton():setText("Metadata"):setPosition(1,2):setSize("parent.w", 1):onClick(function(self) 
    metadataEdit:animatePosition(main:getWidth() / 2 - metadataEdit:getWidth() / 2, 3, 0.5)
    metadataEdit:setFocus()
end)

local newMeta = {}
local newMetaPal = {}
metadataEdit:addLabel():setText("Title:"):setPosition(2, 2)
newMeta.title = metadataEdit:addInput():setPosition(21, 2):setSize(18, 1)
metadataEdit:addLabel():setText("Author:"):setPosition(2, 4)
newMeta.author = metadataEdit:addInput():setPosition(21, 4):setSize(18, 1)
metadataEdit:addLabel():setText("Description:"):setPosition(2, 6)
newMeta.description = metadataEdit:addInput():setPosition(21, 6):setSize(18, 1)
metadataEdit:addLabel():setText("Version:"):setPosition(2, 8)
newMeta.version = metadataEdit:addInput():setPosition(21, 8):setSize(18, 1)
metadataEdit:addLabel():setText("Creator:"):setPosition(2, 10)
newMeta.creator = metadataEdit:addInput():setPosition(21, 10):setSize(18, 1)
metadataEdit:addLabel():setText("Date:"):setPosition(2, 12)
newMeta.date = metadataEdit:addInput():setPosition(21, 12):setSize(18, 1)
metadataEdit:addLabel():setText("Animated:"):setPosition(2, 14)
newMeta.animated = metadataEdit:addCheckbox():setPosition(21, 14):setBackground(colors.black):setForeground(colors.lightGray)
metadataEdit:addLabel():setText("Seconds per frame:"):setPosition(2, 16)
newMeta.secondsPerFrame = metadataEdit:addInput():setPosition(21, 16):setSize(18, 1)
metadataEdit:addLabel():setText("Palette:"):setPosition(2, 18)

local metaPaletteInput = metadataEdit:addInput():setPosition(24, 18):setSize(15,1)
local metaPaletteDropdown = metadataEdit:addDropdown():setPosition(11, 18):setBackground(colors.black):setForeground(colors.lightGray):setDropdownSize(12, 3)
:onChange(function(self, val)
    metaPaletteInput:setValue(tonumber(newMetaPal[colors[val.text]]) or colors[val.text])
end)
for k,v in pairs(availableColors)do
    metaPaletteDropdown:addItem(v)
end
metadataEdit:addButton():setPosition(24, 20):setText("Replace"):setSize(9, 1)
:onClick(function()
    local val = metaPaletteInput:getValue()
    if(val=="")then sendNotification("Error", "Please enter a palette color!") return end
    if(tonumber(val)==nil)then
        sendNotification("Error", val.." is not a valid number!")
    else
        local dVal = metaPaletteDropdown:getValue()
        if(dVal~=nil)and(colors[dVal.text]~=nil)then
            newMetaPal[colors[dVal.text]] = val
            sendNotification("Success", "Successfully replaced "..dVal.text.." with "..val..".")
        else
            sendNotification("Error", "Please choose a color to replace!")
        end
    end
end)


local default = {secondsPerFrame = 0.2, animated = true, creator="Basalt Images 1.0", version="1.0", description="", author="Unknown", title="New Image"}
local function updateMetaFrame()
    basalt.schedule(function()
        local curMeta = img:getMetadata()
        for k,v in pairs(newMeta)do
            if(k~=animated)then
                v:setValue(curMeta[k] or default[k] or "")
            end
        end
        newMetaPal = curMeta.palette or {}
    end)()
end
updateMetaFrame()

local function saveMetadata()
    basalt.schedule(function()
        local m = {}
        for k,v in pairs(newMeta)do
            local val = v:getValue()
            if(val~=nil)and(val~="")then
                m[k] = val
            end
        end
        if(tableCount(newMetaPal)>0)then
            m.palette = newMetaPal
        end
        img:setMetadata(m)
    end)()
end
saveMetadata()

metadataEdit:addButton():setText("Close"):setSize(7, 1):setPosition(2, 23):onClick(function()
    metadataEdit:animatePosition(main:getWidth() / 2 - metadataEdit:getWidth() / 2, -30, 0.5)
end)
metadataEdit:addButton():setText("Save"):setSize(6, 1):setPosition("parent.w-6", 23):onClick(function()
    metadataEdit:animatePosition(main:getWidth() / 2 - metadataEdit:getWidth() / 2, -30, 0.5)
    saveMetadata()
end)
--

-- Frames Selection
local editFrameCache
local function editFrame(id)
    if(editFrameCache~=nil)then
        editFrameCache:remove()
        editFrameCache = nil
    end
    editFrameCache = main:addFrame()
        :setSize(30, 11)
        :setPosition("parent.w / 2 - self.w / 2", -20)
        :setFocus()
        :setShadow(colors.black)

    editFrameCache:animatePosition(main:getWidth()/2 - editFrameCache:getWidth()/2, 3, 0.5, nil, nil, function(self)
            self:setPosition("parent.w / 2 - self.w / 2", 3)
        end)

        editFrameCache:addLabel():setPosition(2, 2):setText("Frame "..id)
        local frameMetadata = img:getFrameMetadata(id)
        local newColorPalette = {}
        if(frameMetadata.palette~=nil)then
            for k,v in pairs(frameMetadata.palette)do
                newColorPalette[k] = v
            end
        end
        editFrameCache:addLabel():setPosition(2, 4):setText("Duration:")
        local duration = editFrameCache:addInput():setPosition(17, 4):setBackground(colors.black):setForeground(colors.lightGray):setInputType("number")
        duration:setValue(frameMetadata.duration or "")
        editFrameCache:addLabel():setPosition(2, 6):setText("Palette-Color:")
        local pColor = editFrameCache:addInput():setPosition(17, 6):setBackground(colors.black):setForeground(colors.lightGray)
        local colorDropdown = editFrameCache:addDropdown():setPosition(2, 8):setBackground(colors.black):setForeground(colors.lightGray):setDropdownSize(12, 3)
        :onChange(function(self, val)
            pColor:setValue(tonumber(newColorPalette[colors[val.text]]) or colors[val.text])
        end)
        for k,v in pairs(availableColors)do
            colorDropdown:addItem(v)
        end
        editFrameCache:addButton():setText("Replace"):setPosition(16, 8):setSize(11, 1):setBackground(colors.black):setForeground(colors.lightGray):onClick(function() 
            local val = pColor:getValue()
            if(val=="")then sendNotification("Error", "Please enter a palette color!") return end
            if(tonumber(val)==nil)then
                sendNotification("Error", val.." is not a valid number!")
            else
                local dVal = colorDropdown:getValue()
                if(dVal~=nil)and(colors[dVal.text]~=nil)then
                    newColorPalette[colors[dVal.text]] = tonumber(val)
                    sendNotification("Success", "Successfully replaced "..dVal.text.." with "..val..".")
                else
                    sendNotification("Error", "Please choose a color to replace!")
                end
            end
        end)

        editFrameCache:onLoseFocus(function() 
            editFrameCache:animatePosition(editFrameCache:getX(), -(editFrameCache:getHeight()+1), 0.5, nil, nil, function() editFrameCache:remove() basalt.schedule(function() sleep(0.05) editFrameCache = nil end)() end)
        end)

        editFrameCache:addButton():setText("Cancel"):setPosition("parent.w - 16", "parent.h - 1"):setBackground(colors.black):setForeground(colors.lightGray):setSize(8, 1):onClick(function() 
            editFrameCache:animatePosition(editFrameCache:getX(), -(editFrameCache:getHeight()+1), 0.5, nil, nil, function() editFrameCache:remove() basalt.schedule(function() sleep(0.05) editFrameCache = nil end)() end)
        end)

        editFrameCache:addButton():setText("Apply"):setPosition("parent.w - 7", "parent.h - 1"):setBackground(colors.black):setForeground(colors.lightGray):setSize(7, 1):onClick(function() 
            editFrameCache:animatePosition(editFrameCache:getX(), -(editFrameCache:getHeight()+1), 0.5, nil, nil, function() editFrameCache:remove() basalt.schedule(function() sleep(0.05) editFrameCache = nil end)() end)
            local metadata = {}
            local dur = duration:getValue()
            if(dur~="")and(tonumber(dur)~=nil)then
                metadata.duration = dur
            end
            if(tableCount(newColorPalette)>0)then
                metadata.palette = newColorPalette
            end
            sendNotification("Success", "Successfully saved the metadata for frame"..id..".")
            img:setFrameMetadata(id, metadata)
        end)
end


local framesFrame = main:addScrollableFrame():setSize(47, 17):setShadow(colors.black):setDirection("horizontal"):setPosition("parent.w / 2 - self.w / 2", -18)
img:onClick(function()
    framesFrame:animatePosition(framesFrame:getX(), -(framesFrame:getHeight()+1), 0.5)
end)
config:onClick(function()
    framesFrame:animatePosition(framesFrame:getX(), -(framesFrame:getHeight()+1), 0.5)
end)
topbar:onClick(function()
    framesFrame:animatePosition(framesFrame:getX(), -(framesFrame:getHeight()+1), 0.5)
end)


local framesPreview = {}
local addImgFrame = framesFrame:addImage():setImage(plusImage):setSize(23, 13):setZIndex(15)


local frames = editFileFrame:addButton():setText("Frames"):setPosition(1,4):setSize("parent.w", 1)

local function calculatePreviewImages()
    for k,v in pairs(framesPreview)do
        v:remove()
    end
    framesPreview = {}
    local imgX = 0
    local iWidth, iHeight = img:getImageSize()
    for k,v in pairs(img:getFrames())do
        local selectionFrame = main:addFrame()
            :hide()
            :setShadow(colors.black)
            :setSize(15, 13)
            :setZIndex(30)
            :onLoseFocus(function(self)
                activeSelectionFrame = nil
                self:hide()
                basalt.schedule(function()
                    sleep(0.1)
                    if not(framesFrame:isFocused())then
                        framesFrame:animatePosition(main:getWidth()/2-framesFrame:getWidth()/2, -24, 0.5)
                    end
                end)()
            end)
            selectionFrame:addButton():setSize("parent.w", 1):setPosition(1, 2):setText("Select"):onClick(function() selectionFrame:hide() img:selectFrame(k) end)
            selectionFrame:addButton():setSize("parent.w", 1):setPosition(1, 4):setText("Remove"):onClick(function()
                if(#img:getFrames()>1)then
                    img:removeFrame(k)
                    img:selectFrame(k-1 >= 1 and k-1 or 1)
                    calculatePreviewImages()
                else
                    sendNotification("Remove", "Can't remove last frame.")
                end
                selectionFrame:hide()
            end)
            selectionFrame:addButton():setSize("parent.w", 1):setPosition(1, 6):setText("Copy"):onClick(function() 
                img:addFrame(k+1) 
                local fImg = img:getFrameObject(k).getFrameImage()
                img:getFrameObject(k+1).setFrameImage(fImg)
                selectionFrame:hide()
                calculatePreviewImages()
            end)
            selectionFrame:addButton():setSize("parent.w", 1):setPosition(1, 8):setText("Edit"):onClick(function() editFrame(k) end)
            selectionFrame:addButton():setSize("parent.w", 1):setPosition(1, 10):setText("Move left"):onClick(function() selectionFrame:hide() img:moveFrame(k, -1) calculatePreviewImages() end)
            selectionFrame:addButton():setSize("parent.w", 1):setPosition(1, 12):setText("Move right"):onClick(function() selectionFrame:hide() img:moveFrame(k, 1) calculatePreviewImages() end)

        local i = {v, width=iWidth, height = iHeight}
        table.insert(framesPreview, framesFrame:addImage():setSize(23, 13):setPosition(25*imgX + 2, 3):setImage(i):resizeImage(23, 13)
        :onClick(function(self, ev, btn, x, y, xAbs, yAbs)
            if(btn==1)then
                img:selectFrame(k)
            else
                basalt.schedule(function()
                    sleep(0.1)
                    activeSelectionFrame = selectionFrame
                    local xObj, yObj = self:getPosition()
                    local pObjX, pObjY = self:getParent():getPosition()
                    local xOff, yOff = self:getParent():getOffset()
                    selectionFrame:show()
                        :setPosition(x + xObj + pObjX - xOff - 2, y + yObj + pObjY - yOff - 2)
                        :setFocus()                    
                end)()
            end
        end))
        imgX = imgX + 1
    end
    addImgFrame:setPosition(25*#img:getFrames() + 2, 3)
end
calculatePreviewImages()

addImgFrame:onClick(function()
    img:addFrame()
    calculatePreviewImages()
end)

frames:onClick(function() 
    framesFrame:animatePosition(main:getWidth()/2-framesFrame:getWidth()/2, 3, 0.5)
    framesFrame:setFocus()
    calculatePreviewImages()
end)
--

-- Blit Editor
local blitEditorFrame = main:addFrame():setSize("parent.w - 10", "parent.h - 5"):setShadow(colors.black)
blitEditorFrame:setPosition(main:getWidth()/2-blitEditorFrame:getWidth()/2, -blitEditorFrame:getHeight()-2):onLoseFocus(function(self)
    blitEditorFrame:animatePosition(main:getWidth()/2-self:getWidth()/2, -blitEditorFrame:getHeight()-2, 0.5)
end)
local blitEditor = editFileFrame:addButton():setText("Blit"):setPosition(1,6):setSize("parent.w", 1):onClick(function() 
    blitEditorFrame:animatePosition(main:getWidth()/2-blitEditorFrame:getWidth()/2, main:getHeight()/2 - blitEditorFrame:getHeight()/2, 0.5)
    blitEditorFrame:setFocus()
end)
blitEditorFrame:addLabel():setText("Blit Editor"):setPosition(1, 1)
local blitEditorImage = blitEditorFrame:addImage():setPosition(2, 3):setSize("parent.w - 12", "parent.h - 5"):setImageSize(1, 1)
local blitEditorCancel = blitEditorFrame:addButton():setText("Cancel"):setPosition(2, "parent.h-1"):setSize(8, 1):setBackground(colors.black):setForeground(colors.lightGray):onClick(function()
    blitEditorFrame:animatePosition(main:getWidth()/2-blitEditorFrame:getWidth()/2, -blitEditorFrame:getHeight()-2, 0.5)
end)

local blitWidth = 2
local blitHeight = 3

local blitEditorGenerate = blitEditorFrame:addButton():setText("Generate"):setPosition("parent.w - 10", "parent.h-1"):setSize(10, 1):setBackground(colors.black):setForeground(colors.lightGray):onClick(function()
    blitEditorFrame:animatePosition(main:getWidth()/2-blitEditorFrame:getWidth()/2, -blitEditorFrame:getHeight()-2, 0.5)
    changeMode(8)
    blitTable = {}
    local fullBlitTable = blitEditorImage:getShrinkedImage()
    for i=1, math.floor(blitHeight/2) do
        blitTable[i] = {fullBlitTable[i][1]:sub(1, math.floor(blitWidth/2)), fullBlitTable[i][2]:sub(1, math.floor(blitWidth/2)), fullBlitTable[i][3]:sub(1, math.floor(blitWidth/2))}
    end
end)

local blitWidthLabel = blitEditorFrame:addLabel():setText("W"):setPosition("parent.w - 9", 6)
local blitHeightLabel = blitEditorFrame:addLabel():setText("H"):setPosition("parent.w - 9", 7)
local blitWidthInput = blitEditorFrame:addInput():setPosition("parent.w - 7", 6):setSize(6, 1):setInputType("number"):setValue("2")
local blitHeightInput = blitEditorFrame:addInput():setPosition("parent.w - 7", 7):setSize(6, 1):setInputType("number"):setValue("3")

blitWidthInput:onLoseFocus(function(self)
    blitWidth = tonumber(self:getValue())
    blitEditorImage:setImageSize(blitWidth, blitHeight)
end)

blitHeightInput:onLoseFocus(function(self)
    blitHeight = tonumber(self:getValue())
    blitEditorImage:setImageSize(blitWidth, blitHeight)
end)

blitEditorFrame:addButton():setText("Clear"):setPosition("parent.w - 9", 9):setSize(8, 1):setBackground(colors.black):setForeground(colors.lightGray):onClick(function()
    blitEditorImage:clear()
    blitWidth = 2
    blitHeight = 3
    blitWidthInput:setValue("2")
    blitHeightInput:setValue("3")
end)

local blitEditorMainCol, blitEditorSecondCol = "0", "f"
local blitEditorColors = {
    ["0"] = blitEditorFrame:addButton():setPosition("parent.w - 9", 3):setBackground(colors.white):setSize(1,1):setText("1"),
    ["1"] = blitEditorFrame:addButton():setPosition("parent.w - 8", 3):setBackground(colors.orange):setSize(1,1):setText(" "),
    ["2"] = blitEditorFrame:addButton():setPosition("parent.w - 7", 3):setBackground(colors.magenta):setSize(1,1):setText(" "),
    ["3"] = blitEditorFrame:addButton():setPosition("parent.w - 6", 3):setBackground(colors.lightBlue):setSize(1,1):setText(" "),
    ["4"] = blitEditorFrame:addButton():setPosition("parent.w - 5", 3):setBackground(colors.yellow):setSize(1,1):setText(" "),
    ["5"] = blitEditorFrame:addButton():setPosition("parent.w - 4", 3):setBackground(colors.lime):setSize(1,1):setText(" "),
    ["6"] = blitEditorFrame:addButton():setPosition("parent.w - 3", 3):setBackground(colors.pink):setSize(1,1):setText(" "),
    ["7"] = blitEditorFrame:addButton():setPosition("parent.w - 2", 3):setBackground(colors.gray):setSize(1,1):setText(" "),
    ["8"] = blitEditorFrame:addButton():setPosition("parent.w - 9", 4):setBackground(colors.lightGray):setSize(1,1):setText(" "),
    ["9"] = blitEditorFrame:addButton():setPosition("parent.w - 8", 4):setBackground(colors.cyan):setSize(1,1):setText(" "),
    ["a"] = blitEditorFrame:addButton():setPosition("parent.w - 7", 4):setBackground(colors.purple):setSize(1,1):setText(" "),
    ["b"] = blitEditorFrame:addButton():setPosition("parent.w - 6", 4):setBackground(colors.blue):setSize(1,1):setText(" "),
    ["c"] = blitEditorFrame:addButton():setPosition("parent.w - 5", 4):setBackground(colors.brown):setSize(1,1):setText(" "),
    ["d"] = blitEditorFrame:addButton():setPosition("parent.w - 4", 4):setBackground(colors.green):setSize(1,1):setText(" "),
    ["e"] = blitEditorFrame:addButton():setPosition("parent.w - 3", 4):setBackground(colors.red):setSize(1,1):setText(" "),
    ["f"] = blitEditorFrame:addButton():setPosition("parent.w - 2", 4):setBackground(colors.black):setSize(1,1):setForeground(colors.white):setText("2"),
}

local function blitSizeDragPosition()
    local xOffset, yOffset = blitEditorImage:getOffset()
    local wI, hI = blitEditorImage:getImageSize()
    blitWidth = wI
    blitHeight = hI
    blitWidthInput:setValue(blitWidth)
    blitHeightInput:setValue(blitHeight)
end

local function blitCanvasHandler(btn, x, y)
    local xOffset, yOffset = blitEditorImage:getOffset()
    x = x-xOffset
    y = y-yOffset
    if(x<1)or(y<1)then return end
    if not(canvasAllowAutoSize:getValue())then
        local wI, hI = blitEditorImage:getImageSize() 
        if(x > wI)then return end
        if(y > hI)then return end
    end

    if(btn==1)then
        blitEditorImage:setBg(blitEditorMainCol, x, y)
    elseif(btn==2)then
        blitEditorImage:setBg(blitEditorSecondCol, x, y)
    end
    blitSizeDragPosition()
end

blitEditorImage:onDrag(function(self, event, btn, x, y, xOffset, yOffset)
    if(basalt.isKeyDown(keys.leftCtrl))then
        blitEditorImage:setOffset(-xOffset, -yOffset, true)
        xO = xO-xOffset
        yO = yO-yOffset
        blitSizeDragPosition()
    else
        blitCanvasHandler(btn, x, y)
    end
end)

blitEditorImage:onClick(function(self, event, btn, x, y, xOffset, yOffset)
    if not(basalt.isKeyDown(keys.leftCtrl))then
        basalt.setRenderingThrottle(50)
    end
end)

main:onClickUp(function()
    basalt.setRenderingThrottle(0)
end)

blitEditorImage:onClickUp(function(self, event, btn, x, y)
    if not(basalt.isKeyDown(keys.leftCtrl))then
        if(blitEditorImage:isFocused())then blitCanvasHandler(btn, x, y) end
    end
end)

local function blitEditorColorSetup(obj, color)
    obj:onClick(function(self, event, btn)
        if(btn==1)then
            if(blitEditorSecondCol == color)then return end
            blitEditorMainCol = color
        elseif(btn==2)then
            if(blitEditorMainCol == color)then return end
            blitEditorSecondCol = color
        end
        for k,v in pairs(blitEditorColors)do
            if(k==blitEditorMainCol)then
                v:setText("1")
            elseif(k==blitEditorSecondCol)then
                v:setText("2")
            else
                v:setText(" ")
            end
        end
    end)
end


for k,v in pairs(blitEditorColors)do
    blitEditorColorSetup(v, k)
end
--


basalt.autoUpdate()