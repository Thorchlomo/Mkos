local component = require("component")
local event = require("event")
local m = component.modem

local port = 1441
local onRoadCom = {}

local account = {"test.1234"}	--Todo : Find a more secure way to stock that

print("Session system by thorchlomo")
print("Initializating Session Server")

m.open(port) --Use of 1441 port
io.stderr:write("Openned port 1441 :" ..tostring( m.isOpen(port)))


while true do
	local _, _, from, portused, _, message = event.pull("modem_message")
	messageR = tostring(message)
	print("Got a message from " .. from .. " on port " .. portused .. ": " .. messageR)
	if message == "session" then
		table.insert(onRoadCom, from)
		print(from .. " Added to onRoadCom !")
		local _, _, from, portused, _, message = event.pull("modem_message_2")
		pseudo = message
		print(pseudo)

		while from ~= onRoadCom[1] do
			local _, _, from, portused, _, message = event.pull("modem_message")
			password = message
			m.send(from, portused, "The session server is curently used, try later")
		end
		for value, index in ipairs(account) do
			if account[index] == pseudo .. "." .. password then 
				print("I've found an identification ! : " .. account[index])
			else 
				print("Not that one")
			end
		end
	end
end