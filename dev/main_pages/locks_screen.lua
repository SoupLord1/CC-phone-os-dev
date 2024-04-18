return function(lock_screen)

    local basalt = require("modules.basalt.basalt")
    local function getFileContents(filepath)
        local file = fs.open(filepath, "r")
        local content = file:readAll()
        file:close()
        return content
    end
    
    local topBar_ls = lock_screen:addFrame():setPosition(1,1):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
    local versionLabel_ls = topBar_ls:addLabel():setText("OS v1.0"):setPosition(2, 1)
    local Clock_ls = topBar_ls:addLabel():setText("Tempclock"):setPosition("parent.w-11", 1)

    local desktop_ls = lock_screen:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h-2"):setBackground(colors.black)

    local passFrame = desktop_ls:addFrame():setSize("parent.w/3", "parent.h/3 + 2"):setPosition("parent.w/2-self.w/2", "parent.h/2-self.h/2"):setBackground(colors.gray)
    local passLabel = passFrame:addLabel():setText(" Password:"):setPosition("parent.w/2-self.w/2", "parent.h/2-self.h/2"):setForeground(colors.white)
    local passInput = passFrame:addInput():setInputType("password"):setInputLimit(12):setPosition("parent.w/2-self.w/2", "parent.h/2-self.h/2+1"):setForeground(colors.white)
    local pass_submit = passFrame:addButton():setText("Submit"):setPosition("parent.w/2-self.w/2", "parent.h/2+3"):setSize(8, 1):setBackground(colors.lightGray)
    local passReponse = passFrame:addLabel():setText(""):setPosition("parent.w/2-self.w/2", "parent.h/2+2"):setForeground(colors.white)

    local bottomBar_ls = lock_screen:addFrame():setPosition(1,"parent.h"):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
    local exit_button_ls = bottomBar_ls:addButton():setText("Exit"):setBackground(colors.lightGray):setSize(6,1):setPosition("parent.w/2-self.w/2",1):onClick(basalt.stop)

    local function enterPass()
        local sha2 = require("modules.sha2.sha2")
        local password = getFileContents("os/default_apps/storage/settings/data/password.txt")
        local entered_password = sha2.sha224(passInput:getValue())
        if password == entered_password then
            passInput:setValue("")
            lock_screen:hide()
        else
            passInput:setValue("")
            passReponse:setText("Incorrect"):setForeground(colors.red)
        end
    
      end
    
    pass_submit:onClick(enterPass)

    local function clockTick_ls()
        while true do
            Clock_ls:setText(os.date("%r"))
            sleep(0.01)
        end
    end
    local clockThread_ls = lock_screen:addThread()
    clockThread_ls:start(clockTick_ls)
    
    
end