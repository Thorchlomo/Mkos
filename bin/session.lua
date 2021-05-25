local component = require("component")
local event = require("event")
local m = component.modem

local port = 1441

io.write("Session system by thorchlomo\n")
-- Dev modem id : f71798c6-bec5-4d00-b8cf-a4e5ef26ccac
local session_host =  "f71798c6-bec5-4d00-b8cf-a4e5ef26ccac" --This is the adress of the session server, must be seted before use

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
m.send(session_host, port, args[2])
m.send(session_host, port, args[3])