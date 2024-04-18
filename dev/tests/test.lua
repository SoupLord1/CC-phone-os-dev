require("modules.aeslua.aeslua")

local key = "test"
local keyLength = aeslua.AES128
local mode = aeslua.ECBMODE
-- local cipher = aeslua.encrypt(key, msg, keyLength, mode)
-- local decipher = aeslua.decrypt(key, cipher, keyLength, aeslua.CBCMODE)

local file = fs.open("os/TEST.txt", "r")
local content = file.readAll()
file.close()

print(aeslua.decrypt(key, content, keyLength, mode))