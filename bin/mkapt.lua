if #args < 3 then	
	io.write("Usage: session <user> <password> [g/p]\n")
	io.write(" g: Download existing session from session server.\n")
	io.write(" p: Put actual session to session server.\n")
	io.write(" P.S: using the shutdown command, session is automaticaly pushed to server.")
	return
 end