local indev = false
shell = require("shell")
local args, options = shell.parse(...)

if options[2] == "i" then
	print("indev download ...")
	indev = true
	end

function file_exist(file) 
	local file = io.open(file, "r")
	if file~=nil then 
		io.close(file)
		return true
	else
		return false
	end
end


print("Removing old version if they exist")
if file_exist("/bin/session.lua") then 
	os.execute("rm /bin/session.lua")
	print("removed session.lua")
	end

-- Mkapt, the command used to interract with packet manager
if file_exist("/bin/mkapt.lua") then 
	os.execute("rm /bin/mkapt.lua")
	os.execute("rmdir /etc/mkapt")
	print("removed mkapt.lua and dependancies")
	end

-- Session Server, the command who start define an computer as an session hoster
if file_exist("/bin/sessionserver.lua") then 
	os.execute("rm /bin/sessionserver.lua")
	print("removed sessionserver.lua")
	end

-- Replace the tips
if file_exist("/usr/misc/greetings.txt") then 
	os.execute("rm /usr/misc/greetings.txt")
	print("removed greetings.txt")
	end


print("Removed all old file, downloading new")
if indev == false then
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/main/bin/session.lua /bin/session.lua")
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/main/bin/sessionserver.lua /bin/sessionserver.lua")
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/main/usr/misc/greetings.txt /usr/misc/greetings.txt")
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/main/bin/mkapt.lua /bin/mkapt.lua")
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/main/etc/mkapt/packet.list /etc/mkapt/packet.list -f")
	
else 
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/thorchlomo-indev/bin/session.lua /bin/session.lua")
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/thorchlomo-indev/bin/sessionserver.lua /bin/sessionserver.lua")
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/thorchlomo-indev/usr/misc/greetings.txt /usr/misc/greetings.txt")
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/thorchlomo-indev/bin/mkapt.lua /bin/mkapt.lua")
	os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/thorchlomo-indev/etc/mkapt/packet.list /etc/mkapt/packet.list -f")
	end

print("creating mkapt folder in /etc")
os.execute("mkdir /etc/mkapt")