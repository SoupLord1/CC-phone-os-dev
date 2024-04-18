local sha2 = require("modules.sha2.sha2")

local function set_pass()
    write("Password: ")
    local password = read()

    local sha_password = sha2.sha224(password)

    local file = fs.open("os/default_apps/storage/settings/password.txt", "w+")

    file.write(sha_password)

    file.close()
end

local function check_pass()
    write("Enter Password: ")
    local chPass = sha2.sha224(read())

    local file = fs.open("os/default_apps/storage/settings/password.txt", "r")

    local password = file.readAll()

    file.close()    

    if chPass == password then
        print("true")
    else
        print("false")
    end
end

local function write_hash(text, filepath)
    local cipher = sha2.sha384(text)
    local file = fs.open(filepath, "w")
    file.write(cipher)
    file.close()
end

write_hash("server-check", "os/test.txt")