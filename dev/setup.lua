print("Downloading Downloader...")
shell.run("pastebin get sz2x1jZC clone.min.lua")
print("Downloader Downloaded!")
shell.run("clone.min https://github.com/SoupLord1/CC-phone-os-build.git os")
shell.run("delete clone.min.lua")
shell.run("cd os")
shell.run("move startup.lua /")
shell.run("os_startup")
 