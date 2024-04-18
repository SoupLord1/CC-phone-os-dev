return function(user)
    
    local user_settings = user:addFrame():setSize("parent.w", "parent.h"):setBackground(colors.black):hide()
    local user_settingsPage = require("default_apps/storage/settings/pages/user/user_settings")(user_settings)
    local user_settings_button = user:addButton():setText("User Settings"):setSize("parent.w-2", 3):setPosition(2, 2):onClick(function() user_settings:show() end)

    local password_settings = user:addFrame():setSize("parent.w", "parent.h"):setBackground(colors.black):hide()
    local password_settingsPage = require("default_apps/storage/settings/pages/user/password_settings")(password_settings)
    local password_settings_button = user:addButton():setText("Password Settings"):setSize("parent.w-2", 3):setPosition(2, 6):onClick(function() password_settings:show() end)

    
    
end