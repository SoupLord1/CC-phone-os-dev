print("Building Directories")
-- Modules
fs.makeDir("os/modules/main_os/")
fs.makeDir("os/modules/sha2/")
-- Default Apps
fs.makeDir("os/default_apps/apps/")
fs.makeDir("os/default_apps/icons/")
fs.makeDir("os/default_apps/setup/")
fs.makeDir("os/default_apps/storage/settings")

print("Downloading Files")

shell.run("pastebin get jPdJqDXV os/basalt.lua")

shell.run("pastebin get P04NNdK5 os/os_startup.lua")

shell.run("pastebin get HG3r2CWQ os/modules/main_os/app_loader.lua")

shell.run("pastebin get xvYAg6UL os/modules/sha2/sha2.lua")

shell.run("pastebin get rwVdZa5w os/default_apps/apps/settings.lua")
shell.run("pastebin get pUpKn7hC os/default_apps/icons/settings.bimg")
shell.run("pastebin get uqLfAMKh os/default_apps/setup/settings.app")
shell.run("pastebin get 8UCBMTe3 os/default_apps/storage/settings/password.txt")