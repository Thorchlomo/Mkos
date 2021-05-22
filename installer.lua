
function file_exist(file) 
	local file = io.open(file, "r")
	if file~=nil then 
		io.close()
		return true
	else
		return false
	end
end


print("Removing old version if they exist")
if file_exist("/bin/session.lua") then 
	os.remove("/bin/session.lua")
	print("removed session.lua")
	end

print("Removed all old file, downloading new")
os.execute("wget https://raw.githubusercontent.com/Thorchlomo/Mkos/main/bin/session.lua?token=ARPS2KTEI7UKBZOOBSFQQKDAVDUDM")