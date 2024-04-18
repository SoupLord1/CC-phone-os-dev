return function(desktop)
    
    local basalt = require("modules.basalt.basalt")
    local app = desktop:addFrame():setSize("parent.w", "parent.h"):setBackground(colors.green)
    
    return app
end

