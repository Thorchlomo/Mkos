io.write("Session system by thorchlomo\n")

local session_host = nil --This is the adress of the session server, must be seted before use

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