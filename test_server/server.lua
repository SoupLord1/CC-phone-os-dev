periphemu.create("right", "modem") 
peripheral.find("modem", rednet.open)

local function getTableFromString(filepath)
    local tableFile = fs.open(filepath, "r")
    local table = loadstring("return"..tableFile:readAll())()
    tableFile:close()
    return table
end

local hashes = getTableFromString("server/server_hashes.txt")

while true do
    term.clear()
    term.setCursorPos(1,1)
    write("MODES: test, server-check")
    write("MODE: ")
    local mode = read()
    local payload
    if mode == "test" then
        local time = os.date("%r")
        payload = {type=hashes[1],data=time}
        rednet.broadcast(payload)
    elseif mode == "server-check" then
        local function sendServerCheck()
            payload = {type=hashes[2], data="Server Check!"}
            while true do
                rednet.broadcast(payload)
                sleep(1)
            end
        end

        local function getServerCheck()
            local id, response 
            repeat
                id, response = rednet.receive()
            until response["type"] == "server-check"
            print(response["data"])
        end

        parallel.waitForAny(sendServerCheck, getServerCheck)

        

        
    end

    sleep(5)
end