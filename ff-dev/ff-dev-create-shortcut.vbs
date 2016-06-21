Set oWS = WScript.CreateObject("WScript.Shell")
sLinkFile = oWS.ExpandEnvironmentStrings("%USERPROFILE%") + "\Desktop\ff-dev.lnk"
Set oLink = oWS.CreateShortcut(sLinkFile)

oLink.TargetPath = "C:\usr\ff-dev\START-ff-dev.cmd"
oLink.WorkingDirectory = "C:\usr\ff-dev"
oLink.IconLocation = oWS.ExpandEnvironmentStrings("%USERPROFILE%") + "\Pictures\icon\ff-dev.ico"
oLink.Description = "ff-dev"
'oLink.Arguments = ""
'oLink.HotKey = "ALT+CTRL+F"
oLink.WindowStyle = 7

oLink.Save
