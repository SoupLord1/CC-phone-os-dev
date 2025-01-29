local basalt = require("modules.basalt.basalt")

local function exitOs()
    basalt.stop()
end

local main = basalt.createFrame()

local device_type = "desktop"
local device_width, device_height = term.getSize()

if device_width == 26 then
    device_type = "mobile"
end

basalt.debug("Device: "..device_type)

-- LOCK SCREEN


-- LOCK SCREEN END

local main_os = main:addFrame():setSize("parent.w", "parent.h")



local topBar = main_os:addFrame():setPosition(1,1):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local versionLabel = topBar:addLabel():setText("OS v1.0"):setPosition(2, 1)
local Clock = topBar:addLabel():setText("Tempclock"):setPosition("parent.w-11", 1)

local desktop = main_os:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h-2"):setBackground(colors.black)

local bottomBar = main_os:addFrame():setPosition(1,"parent.h"):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local exit_button = bottomBar:addButton():setText("Exit"):setBackground(colors.lightGray):setSize(6, 1):setPosition(1,1):onClick(exitOs)
local logout_button = bottomBar:addButton():setText("Logout"):setBackground(colors.lightGray):setSize(8, 1):setPosition("parent.w-self.w+1",1)
local home_button = bottomBar:addButton():setText("Home"):setBackground(colors.lightGray):setSize(6,1):setPosition("parent.w/2-self.w/2",1)
-- MAIN OS END

local app_loader = require("modules.main_os.app_loader")
local apps = app_loader.get_default_apps()

local app_slots = {}
app_slots["app_frame"] = {}
app_slots["slot_handle"] = {}
app_slots["app_frame_2"] = {}
app_slots["slot_handle_2"] = {}

local spacing = {w = 8, h = 6}
local offset = {w = 4, h = 2}

for i = 1, #apps.appsL1 do
    app_slots["app_frame"][i] = apps.appsL1[i]["app"](desktop):hide()
end

for i = 1, #app_slots["app_frame"] do
    app_slots["slot_handle"][i] = {icon = desktop:addImage():setPosition(spacing.w*(i-1) + offset.w, offset.h):setImage(apps.appsL1[i]["icon"]):onClick(function () app_slots["app_frame"][i]:show(); end),
    nameL1 = desktop:addLabel():setText(apps.appsL1[i]["name"]["nameL1"]):setPosition(spacing.w*(i-1) + offset.w - (string.len(apps.appsL1[i]["name"]["nameL1"])-5)/2,3 + offset.h ):setForeground(colors.white),
    nameL2 = desktop:addLabel():setText(apps.appsL1[i]["name"]["nameL2"]):setPosition(spacing.w*(i-1) + offset.w - (string.len(apps.appsL1[i]["name"]["nameL2"])-5)/2,4 + offset.h ):setForeground(colors.white)}
end

for i = 1, #apps.appsL2 do
    app_slots["app_frame_2"][i] = apps.appsL2[i]["app"](desktop):hide()
end
for i = 1, #app_slots["app_frame_2"] do
    app_slots["slot_handle_2"][i] = {icon = desktop:addImage():setPosition(spacing.w*(i-1) + offset.w, offset.h + spacing.h):setImage(apps.appsL2[i]["icon"]):onClick(function () app_slots["app_frame_2"][i]:show(); end),
    nameL1 = desktop:addLabel():setText(apps.appsL2[i]["name"]["nameL1"]):setPosition(spacing.w*(i-1) + offset.w - (string.len(apps.appsL2[i]["name"]["nameL1"])-5)/2,3 + offset.h + spacing.h):setForeground(colors.white),
    nameL2 = desktop:addLabel():setText(apps.appsL2[i]["name"]["nameL2"]):setPosition(spacing.w*(i-1) + offset.w - (string.len(apps.appsL2[i]["name"]["nameL2"])-5)/2,4 + offset.h + spacing.h):setForeground(colors.white)}
end


local function home()
    for i = 1, #app_slots["app_frame_2"] do
        app_slots["app_frame_2"][i]:hide()
    end

    for i = 1, #app_slots["app_frame"] do
        app_slots["app_frame"][i]:hide()
    end
end

home_button:onClick(home)

-- local function show_app(self)
--     basalt.debug(self)
-- end

-- local function hide_app()
--     apps["test_app"][1]:hide()
-- end



local leftButton = desktop:addButton():setText("<"):setPosition(1, "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)
local leftButton = desktop:addButton():setText(">"):setPosition("parent.w", "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)

local lock_screen = main:addFrame():setSize("parent.w", "parent.h")
local lock_screen_page = require("main_pages.locks_screen")(lock_screen)
-- MAIN OS
local function Logout()
    lock_screen:show()
end

logout_button:onClick(Logout)

-- TODO
-- Add a app title

-- IDEA
-- Try to store a frame in a file and send it like a module

-- local testApp = desktop:addImage():setPosition(3, 2):loadImage("test.bimg"):onClick(show_app)

local function clockTick()
    while true do
        Clock:setText(os.date("%r"))
        sleep(0.01)
    end
end


local clockThread = main_os:addThread()

--local imageThread = main:addThread()

clockThread:start(clockTick)
--imageThread:start(updateImages)

basalt.autoUpdate()