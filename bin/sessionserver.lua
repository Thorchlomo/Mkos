local component = require("component")
local event = require("event")
local m = component.modem

local port = 1441
local onRoadCom = {}
local files = {}

local account = {"test.1234"}	--Todo : Find a more secure way to stock that

print("Session system by thorchlomo")
print("Initializating Session Server")

m.open(port) --Use of 1441 port
io.stderr:write("Openned port 1441 :" ..tostring( m.isOpen(port)))

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


while true do
	local _, _, from, portused, _, message = event.pull("modem_message")
	messageR = tostring(message)
	print("Got a message from " .. from .. " on port " .. portused .. ": " .. messageR)
	if message == "session" then
		--table.insert(onRoadCom, from)
		--print(from .. " Added to onRoadCom !")
		print("session !")
		local _, _, from, portused, _, message = event.pull("modem_message")
		pseudo = message
		print(pseudo)

		local _, _, from, portused, _, message = event.pull("modem_message")
		password = message
		print("finito !")
		curentid = pseudo .. "." .. password
		print("waiting for mode !")
		local _, _, from, portused, _, message = event.pull("modem_message")
		if message == "get" then
			for index, value in ipairs(account) do
				print(account[index])
				print(curentid)
				if account[index] == curentid then 
					print("I've found an identification ! : " .. account[index])
					print("Sending files")
					sendFile(pseudo, from)
					print("sended files, finish for that one !")
				else 
					print("Not that one")
				end
			end
		end
		elseif message == "push" then
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
					break
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
		end
	end
end