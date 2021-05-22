local component = require("component")
local event = require("event")
local m = component.modem

local port = 1441


print("Session system by thorchlomo")
print("Initializating Session Server")

m.open(port) --Use of 1441 port
io.stderr:write("Openned port 1441 :" ..tostring( m.isOpen(port)))


while true do
	local _, _, from, portused, _, message = event.pull("modem_message")
	messageR = tostring(message)
	print("Got a message from " .. from .. " on port " .. portused .. ": " .. messageR)
	if string.match(messageR, ".") then 
		print("This message appear be an session asking, consider it is")
		sessionName = string.sub(messageR,0, tonumber(string.sub(string.find(messageR, "."), 0, 0)))
		print("Session Name : " .. sessionName)
	end
end