Set oWS = WScript.CreateObject("WScript.Shell")
sLinkFile = oWS.ExpandEnvironmentStrings("%USERPROFILE%") + "\Desktop\ff-dev.lnk"
Set oLink = oWS.CreateShortcut(sLinkFile)

oLink.TargetPath = "C:\bin\ff-dev\START-ffdev.cmd"
'oLink.Arguments = ""
oLink.Description = "ff-dev"
'oLink.HotKey = "ALT+CTRL+F"
oLink.IconLocation = oWS.ExpandEnvironmentStrings("%USERPROFILE%") + "\Pictures\icon\firefox-developer.ico"
oLink.WindowStyle = 7
oLink.WorkingDirectory = "C:\bin\ff-dev"
oLink.Save
