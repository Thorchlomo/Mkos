local filesystem = require("filesystem")
local component = require("component")
local internet = require("internet")
local shell = require("shell")

local args, options = shell.parse(...) -- Récuperation des arguments et des options

if #args < 2 then	
	io.write("Usage: mkatp <get/update/upgrade/add-src/remove-src> <packet/src-url>\n")
	io.write(" get : Used to download packet from all source server available.\n")
	io.write(" update : Update the packet list.\n")
	io.write(" upgrade : upgrade all the packet or the specified packet")
	io.write(" add-src : Add an source server.\n")
	io.write(" remove-src : Make the opposite.\n")
	io.write(" P.S. : This program require an internet card to work")
	return
 end

 if not component.isAvailable("internet") then
  io.stderr:write("This program requires an internet card to run.")
  return
end

-- Start of the "main" code
function read_source(packet_query)
	local config = {}
	local p = io.popen('find "/etc/mkapt/" --type=f')  --Open directory look for files     
	for file in p:lines() do                         --Loop through all files
		print(file)       
		table.insert(config, file)
	end
	local lines = {}
	for cle, chemin in ipairs(config) do -- Loop through all finded file
		for line in io.lines(chemin) do  -- Loop through all lines of the specified file
			lines[#lines + 1] = line
		end
		for index, valeur in ipairs(lines) do
			if valeur == packet_query then
				print("Finded the requested packet in the source :")
				print(lines[1])
				print("Packet : "..lines[index].." Version : "..lines[index+1])
				return lines[1], lines[index], lines[index+1]
			end
		end
	end
end

if args[1] == "get" then -- The user want to recover an packet from packet server
	os.execute("mkdir /etc/mkapt/"..args[2])
	os.execute("wget https://github.com/Thorchlomo/Mkos/blob/main/etc/mkapt/"..args[2].."/installer.lua -f /etc/mkapt/"..args[2].."/installer.lua")
	local installer = require("/etc/mkapt/"..args[2].."/installer.lua")
	print(installer.ver())
end	

if args[1] == "update" then
	print("Updating package list for the following source :",args[2])
	os.setenv("/etc/mkapt")
	os.execute("wget "..args[2].." -f")
end

if args[1] == "debug" then
	read_source()
end