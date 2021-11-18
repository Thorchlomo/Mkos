local component = require("component")
local internet = require("internet")
local shell = require("shell")

local args, options = shell.parse(...) -- Récuperation des arguments et des options

if #args < 2 then	
	io.write("Usage: mkatp <get/update/add-src/remove-src> <packet/src-url>\n")
	io.write(" get : Used to download packet from all source server available.\n")
	io.write(" update : Update all the packet (if needed only).\n")
	io.write(" add-src : Add an source server.\n")
	io.write(" remove-src : Make the opposite.\n")
	io.write(" P.S. : This program require an internet card to work")
	return
 end

 if not component.isAvailable("internet") then
  io.stderr:write("This program requires an internet card to run.")
  return
end

if args[1] == "get" then -- The user want to recover an packet from packet server
	local packet = args[2]
	print("Looking for packet : ",packet)
 
	local handle = internet.request("https://raw.githubusercontent.com/Thorchlomo/Mkos/main/etc/mkapt")
	local result = ""
	local mt = getmetatable(handle)
 
	-- The response method grabs the information for
	-- the HTTP response code, the response message, and the
	-- response headers.
	local code, message, headers = mt.__index.response()
	print("code = "..tostring(code))
end	