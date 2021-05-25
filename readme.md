Mkos, an OpenOS version that integrate session

Session Fonctonement :
1 session server, who host file
infinite (or near) session client (just computer with session.lua command)


When session file download needed :
 -The client ask for server "sessionname.sessionpassword"
 -The server respond "sessionok"
 -The server send "session tree " (home|file1/file2/file3;folder1|file1/file2/file3)
 -The server send file in order of apparence in session tree
 -The server cut the link