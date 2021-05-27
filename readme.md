Mkos, an OpenOS version that integrate session

Session Fonctonement :  
1 session server, who host file  
infinite (or near) session client (just computer with session.lua command)  


When session file download needed :
`
 -The client ask for server "sessionname.sessionpassword"  
 -The server respond "sessionok"  
 -The server send "session tree " (file (wait for client confirmation), file (wait), ...)  
 -The server send file in order of apparence in session tree  
 -The server cut the link  
 `  
-How to create session ?  
  
To create a session, type `edit /bin/sessionserver.lua` and modify the `local account = {"test.1234"}	--Todo : Find a more secure way to stock that` line to 
add account like that:  
{"account1.password1", "account2.password2"} etc, etc  
  
Then create an "account1" folder in /home/ (an folder who have EXACTLY the same name of the account 😉)  
  
  
  
TODO :   
Make an more easyer way to create account
Make an more secure way to keep password