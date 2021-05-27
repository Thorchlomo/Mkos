local component = require("component")
local event = require("event")
local m = component.modem

local port = 1441

io.write("Session system by thorchlomo\n")
-- Dev modem id : f71798c6-bec5-4d00-b8cf-a4e5ef26ccac
local session_host =  "f71798c6-bec5-4d00-b8cf-a4e5ef26ccac" --This is the adress of the session server, must be seted before use

local state = ""
local folders = {}
local files = {}

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


-- This function is re-used from sessionserver
function readFile(fileToRead)
	
	print("[readFile]: reading ")
	print(fileToRead)
	local file = io.open(fileToRead, "rb") -- r read mode and b binary mode
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

function sendFile(pseudo, to)
	print("[sendFile]: send folder status !")
	m.send(to, port, "state:folder")
	local q = io.popen('find "'.. '/home/' .. pseudo ..'" --type=d')
	for directory in q:lines() do                         --Loop through all files
		print(directory)       
		m.send(to, port, directory)
		os.sleep(0.1)
	end
	print("[sendFile]: send file status !")
	m.send(to, port, "state:file")
	local p = io.popen('find "'.. '/home/' .. pseudo ..'" --type=f')  --Open directory look for files     
	for file in p:lines() do                         --Loop through all files
		print(file)       
		table.insert(files, file)
	end
	print("[sendFile]: file scanned, now lets send that !")
	for index, value in ipairs(files) do
		if string.match(files[index], ".") then
			m.send(to, port, files[index])
			os.sleep(0.1)
			local content = readFile(files[index])
			m.send(to, port, content)
			
		else
			print("[readFile]: not a file !")
		end
	end
	print("[sendFile]: Finishing !")
	m.send(to, port, "1441/ended")
	print("[sendFile]: Finish")
end

m.open(port) --Use of 1441 port

io.stderr:write("Openned port 1441 :" ..tostring( m.isOpen(port)))
m.send(session_host, port, "session")
os.sleep(4)
m.send(session_host, port, args[1])
m.send(session_host, port, args[2])
if args[3] == "-g" then
	while true do 
		_, _, from, portused, _, message = event.pull("modem_message")
		print(message)
		if message == "state:folder" then
			state = "folder"
		elseif message == "state:file" then
			state = "file"
			for index, value in ipairs(folders) do
				os.execute("mkdir " .. folders[index])
				print("synchronize : " .. folders[index])
			end
		elseif message == "1441/ended" then
			os.exit()
		else
			if state == "folder" then
				table.insert(folders,message)
			end
			if state == "file" then
				fileWrite = io.open(message, "wb")
				local _, _, from, portused, _, message = event.pull("modem_message")
				fileWrite:write(message)
				fileWrite:close()
			end

		end
	end
elseif args[3] == "p" then
	sendFile(args[1], session_host)
	print("sended files, finish for that one !")
	end
end

-- Theorie pour le bug : file ne peut pas creer de subfolder, il faut les créer à la main  : Vrai !