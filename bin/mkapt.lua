local filesystem = require("filesystem")
local component = require("component")
local internet = require("internet")
local shell = require("shell")

local args, options = shell.parse(...) -- Récuperation des arguments et des options

if #args < 2 then	
	io.write("Usage: mkatp <get/update/upgrade/add-src/remove-src> <packet/src-url> [a_name_for_the_source_in_case_of_add/remove]\n")
	io.write(" get : Used to download packet from all source server available.\n")
	io.write(" remove : Used to remove packet from the computer.\n")
	io.write(" update : Update the packet list.\n")
	io.write(" upgrade : upgrade all the packet or the specified packet")
	io.write(" add-src : Add an source server.\n")
	io.write(" remove-src : Make the opposite (put anything you want in src-url ;) ).\n")
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
	local p = io.popen('find "/etc/mkapt/" --type=f --name=*.list')  --Open directory look for files     
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
	os.exit()
end

function get_all_packet()
	local directorys = {}
	local q = io.popen('find "/etc/mkapt" --type=d ')
	for directory in q:lines() do                         --Loop through all files
		print(directory)
		directorys[#directorys + 1] =  string.gsub(directory, "/etc/mkapt/", "")
	end
	return directorys
end

function upgrade(packet)
	print("upgrading "..packet)
	local source,name,version = read_source(packet)
	package.path = package.path .. ";/etc/mkapt/"..name.."/installer.lua"
	if version() == version then
		print("Packet already up-to-date")
	else
		os.execute("wget "..source.."/"..name.."/installer.lua -f /etc/mkapt/"..name.."/installer.lua")
		print(update())
	end
end

if args[1] == "get" then -- The user want to recover an packet from packet server
	local source,name,version = read_source(args[2])
	os.execute("mkdir /etc/mkapt/"..name)
	os.execute("wget "..source.."/"..name.."/installer.lua -f /etc/mkapt/"..name.."/installer.lua")
	package.path = package.path .. ";/etc/mkapt/"..name.."/installer.lua"
	print(ver())
	print(install())
	print(name.." "..version.."Is now installed !")
end	

if args[1] == "remove" then 
	print("Removing "..args[2])
	package.path = package.path .. ";/etc/mkapt/"..args[2].."/installer.lua"
	print(remove())
end

if args[1] == "update" then --Don't work'
	print("Updating package list for the following source :",args[2])
	os.setenv("/etc/mkapt")
	os.execute("wget "..args[2].." -f")
end

if args[1] == "upgrade" then
	if args[2] == "*" then
		print("Upgrading all packets")
		for index, valeur in ipairs(get_all_packet()) do
			print(valeur)
			upgrade(valeur)
		end
	else
		upgrade(args[2])
	end
end

if args[1] == "add-src" then
	os.execute("wget "..args[2].." /etc/mkapt/"..args[3]..".list")
	print(args[3].." Added !")
end

if args[1] == "remove-src" then 
	os.execute("rm /etc/mkapt/"..args[3])
	print(args[3].." Removed !")
end

if args[1] == "debug" then
	read_source(args[2])
end