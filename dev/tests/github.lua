local args = { ... }
os.loadAPI("os/modules/json/json.lua")
 
local user = ""
local repo = ""
local dest = ""
 
if #args == 2 then
    user = args[1]
    repo = args[2]
    dest = repo
elseif #args == 3 then
    user = args[1]
    repo = args[2]
    dest = args[3]
elseif #args > 3 then
    user = args[1]
    repo = args[2]
    dest = ""
    for i = 3, #args, 1 do
        dest = dest.." "..args[i]
    end
else
    print("Usage:\ngithub <username> <repositoryName> [target directory]")
    return
end
 
if string.sub(dest,-1) == "/" then
    dest = string.sub(dest,0,string.len(dest)-1)
end
 
local allFiles = { }
 
function getRepo(url)
    local rs = http.get(url).readAll()
    local res = json.decode(rs)
    local files = { }
    for i,j in pairs(res) do
        local data = { }
 
        if j.type == "file" then
            print("downloading "..j.download_url)
            data = http.get(j.download_url).readAll()
        elseif j.type == "dir" then
            data = getRepo(j.url)
        end
 
        local entry = {
            type = j.type,
            name = j.name,
            contents = data
        }
        table.insert(files,entry)
 
    end
    return files
end
 
function createFiles(files, target)
 
    if fs.exists(target) and #fs.list(target) > 0 then
        print("Please select an empty target directory.")
        return
    else
        fs.makeDir(target)
    end
 
    for i,j in pairs(files) do
        if j.type == "file" then
            local file = fs.open(target.."/"..j.name,"w")
            file.write(j.contents)
            file.flush()
            file.close()
        elseif j.type == "dir" then
            createFiles(j.contents, target.."/"..j.name)
        end
    end
end
 
allFiles = getRepo("https://api.github.com/repos/"..user.."/"..repo.."/contents")
print("Saving...")
createFiles(allFiles, dest)