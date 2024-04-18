local network = {}

local sha2 = require("modules.sha2.sha2")

function network.startNetwork()

    periphemu.create("right", "modem") 

    peripheral.find("modem", rednet.open)
    

    while true do
        local id, data = rednet.receive()
        print(id)
        print(data)
        
        if type(data) == "table" then

            if data["type"] == sha2.sha384("test") then
                print("Testing Network!")
            elseif data["type"] == sha2.sha384("connection-check") then
                local payload = {type="server-check", data="Device Response"}
                rednet.broadcast(payload)
            end
            local log = fs.open("os/modules/network/network_log.txt", "a")
            log.write("ID: "..id.." Type: "..data["type"].." Data: "..data["data"].."\n")
            log.close()

        end
        sleep(0.001)
    end
    
end


return network