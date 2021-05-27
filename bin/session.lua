local component = require("component")
local event = require("event")
local m = component.modem

local port = 1441

io.write("Session system by thorchlomo\n")
-- Dev modem id : f71798c6-bec5-4d00-b8cf-a4e5ef26ccac
local session_host =  "f71798c6-bec5-4d00-b8cf-a4e5ef26ccac" --This is the adress of the session server, must be seted before use

local state = ""
local folders = {}

local shell = require("shell")
local args, options = shell.parse(...)

if #args < 3 then	
	io.write("Usage: session <user> <password> [g/p]\n")
	io.write(" g: Download existing session from session server.\n")
	io.write(" p: Put actual session to session server.\n")
	io.write(" P.S: using the shutdown command, session is automaticaly pushed to server.")
	return
 end

 if session_host == nil then
	io.write("An session server must be seted on /bin/session.lua")
	return
end


m.open(port) --Use of 1441 port

io.stderr:write("Openned port 1441 :" ..tostring( m.isOpen(port)))
m.send(session_host, port, "session")
os.sleep(4)
m.send(session_host, port, args[1])
m.send(session_host, port, args[2])

while true do 
	_, _, from, portused, _, message = event.pull("modem_message")
	print(message)
	if message == "state:folder" then
		state = "folder"
	elseif message == "state:file" then
		state = "file"
		for index, value in ipairs(folders) do
			os.execute("mkdir" .. folders[index])
			print("synchronize : " .. folders[index])
		end
	elseif message == "1441/ended" then
		os.exit()
	else
		if state == "folder" then
			table.insert(folders,message)
		end
		if state = "file" then
			fileWrite = io.open(message, "wb")
			local _, _, from, portused, _, message = event.pull("modem_message")
			fileWrite:write(message)
			fileWrite:close()
		end

	end
end

-- Theorie pour le bug : file ne peut pas creer de subfolder, il faut les créer à la main  : Vrai !