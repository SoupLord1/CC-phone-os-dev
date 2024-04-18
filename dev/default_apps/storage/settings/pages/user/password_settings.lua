return function(password_settings)
    local sha2 = require("modules.sha2.sha2")

    password_settings:addLabel():setText("Password Settings"):setPosition(2, 2):setForeground(colors.white)
    password_settings:addLabel():setText("New Password: "):setPosition(2, 4):setForeground(colors.white)
    local new_password = password_settings:addInput():setInputType("password"):setInputLimit(12):setPosition(15, 4):setForeground(colors.white)
    password_settings:addLabel():setText("Old Password: "):setPosition(2, 5):setForeground(colors.white)
    local old_password = password_settings:addInput():setInputType("password"):setInputLimit(12):setPosition(15, 5):setForeground(colors.white)
    local change_password_response = password_settings:addLabel():setPosition(2, 8)
    local back_button = password_settings:addButton():setText("Back"):setSize(6, 1):setPosition(2, "parent.h - 1"):onClick(function() change_password_response:setText(""); password_settings:hide() end)

    local function change_password()
        local file = fs.open("os/default_apps/storage/settings/data/password.txt", "r")
        local password = file.readAll()
        file.close()

        if sha2.sha224(old_password:getValue()) == password then
            local file = fs.open("os/default_apps/storage/settings/data/password.txt", "w")
            file.write(sha2.sha224(new_password:getValue()))
            file.close()
            change_password_response:setText("Password Changed!"):setForeground(colors.green)
            
        else
            change_password_response:setText("Incorrect Old Password!"):setForeground(colors.red)
        end
        new_password:setValue("")
        old_password:setValue("")
    end

    local change_password_button = password_settings:addButton():setPosition(2, 7):setSize(17, 1):setText("Change Password"):onClick(change_password)

end