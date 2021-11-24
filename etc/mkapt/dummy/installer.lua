local version = "1.0"
print("Initializting Dummy Packet !")

function ver()
	return version
end

function install()
	return "I'm a lonely packet"
end

function remove()
	print("I'm sad, why did you want to do that")
	os.execute("rm /etc/mkapt/dummy/installer.lua")
	return "I'm Broken !"
end

function update()
	install()
	return "ready to start !"
end
