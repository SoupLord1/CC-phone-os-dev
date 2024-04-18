local app_loader = {}

local function getTableFromString(filepath)
    local tableFile = fs.open(filepath, "r")
    local table = loadstring("return"..tableFile:readAll())()
    tableFile:close()
    return table
end

function app_loader.get_default_apps()
    local default_app_files = fs.list("os/default_apps/setup/")
    local app_files = fs.list("os/apps/setup/")
    local app_setups = {}
    local apps = {}
    
    apps.appsL1, apps.appsL2 = {}, {}
    for i = 1, #default_app_files do
        app_setups[i] = getTableFromString("os/default_apps/setup/"..default_app_files[i])
    end

    for i = 1, #app_files do
        app_setups[i + #default_app_files] = getTableFromString("os/apps/setup/"..app_files[i])
    end

    for i = 1, #app_setups do
        local name = app_setups[i][1]["name"]

        local nameL1, nameL2



        if string.len(name) > 7 then

            nameL1 = string.sub(name, 1, 7)
            nameL2 = string.sub(name, 8, string.len(name))

            nameL2 = nameL2..string.rep(" ", 14 - string.len(name))
        
        else
            nameL1 = string.sub(name, 1, string.len(name))
            nameL2 = string.rep(" ", 7)

            nameL1 = string.rep(" ", (7 - string.len(name))/2)..nameL1..string.rep(" ", (7 - string.len(name))/2)
        end

        if i < 7 then
            apps.appsL1[i] = {name = {nameL1 = nameL1, nameL2 = nameL2}, 
            app = require(string.gsub(app_setups[i][1]["app"], ".lua", "")), 
            icon = getTableFromString("os/"..app_setups[i][1]["icon"])}
        elseif i < 13 then 
            apps.appsL2[i-6] = {name = {nameL1 = nameL1, nameL2 = nameL2}, 
            app = require(string.gsub(app_setups[i][1]["app"], ".lua", "")), 
            icon = getTableFromString("os/"..app_setups[i][1]["icon"])}
        end
    end 
    return apps
end


-- function app_loader.get_apps()
--     local app_files = fs.list("os/default_apps")


--     local apps = {}

--     local i = 1
--     local j = 1
--     while i < #app_files + 1 do
--         if fs.isDir("os/default_apps/"..app_files[i]) == false then
--             local app_name = string.gsub(app_files[i], ".lua", "")
--             local app_handle = require("default_apps/"..app_name)
--             local app_icon = getImageFromString("os/default_apps/icons/"..app_name..".bimg")
--             apps[j] = {name = string.sub(app_name, 1, 5), handle = app_handle, icon = app_icon}
--             j = j + 1
--         end
--         i = i + 1
--     end
--     return apps
-- end

function app_loader.test()
    local app_files = fs.list("os/default_apps")

    for i = 1, #app_files do
        print(app_files[i])
    end
end

return app_loader

-- Shows same Icon for all apps