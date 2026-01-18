-- Audio Source Switcher
-- Uses SwitchAudioSource to list and switch between audio input/output devices
-- Requires: brew install switchaudio-osx

on run
	-- Bring this app to front so dialogs are focused
	tell me to activate
	
	set switchAudioPath to "/opt/homebrew/bin/SwitchAudioSource"
	
	-- Check if SwitchAudioSource is installed
	try
		do shell script "test -f " & quoted form of switchAudioPath
	on error
		-- Try Intel Mac path
		set switchAudioPath to "/usr/local/bin/SwitchAudioSource"
		try
			do shell script "test -f " & quoted form of switchAudioPath
		on error
			display dialog "SwitchAudioSource is not installed." & return & return & "Install it using:" & return & "brew install switchaudio-osx" buttons {"OK"} default button "OK" with icon stop
			return
		end try
	end try
	
	-- Main menu
	set mainChoice to choose from list {"Switch Both (Input & Output)","Switch Output Device", "Switch Input Device", "Show Current Devices"} with prompt "Audio Source Switcher" with title "Audio Switcher" default items {"Switch Both (Input & Output)"}
	
	if mainChoice is false then return
	
	set selectedOption to item 1 of mainChoice
	
	if selectedOption is "Switch Output Device" then
		switchDevice(switchAudioPath, "output")
	else if selectedOption is "Switch Input Device" then
		switchDevice(switchAudioPath, "input")
	else if selectedOption is "Switch Both (Input & Output)" then
		switchBothDevices(switchAudioPath)
	else if selectedOption is "Show Current Devices" then
		showCurrentDevices(switchAudioPath)
	end if
end run

on switchDevice(switchAudioPath, deviceType)
	-- Get list of available devices
	try
		set deviceList to do shell script switchAudioPath & " -a -t " & deviceType
	on error errMsg
		display dialog "Error getting " & deviceType & " devices: " & errMsg buttons {"OK"} default button "OK" with icon stop
		return
	end try
	
	-- Get current device
	try
		set currentDevice to do shell script switchAudioPath & " -c -t " & deviceType
	on error
		set currentDevice to ""
	end try
	
	-- Parse device list into AppleScript list (use paragraphs for reliable line splitting)
	set deviceItems to paragraphs of deviceList
	
	-- Filter out empty items and mark current device
	set displayList to {}
	set cleanList to {}
	repeat with deviceName in deviceItems
		set deviceName to deviceName as text
		if deviceName is not "" then
			set end of cleanList to deviceName
			if deviceName is currentDevice then
				set end of displayList to "✓ " & deviceName & " (current)"
			else
				set end of displayList to "  " & deviceName
			end if
		end if
	end repeat
	
	if (count of cleanList) is 0 then
		display dialog "No " & deviceType & " devices found." buttons {"OK"} default button "OK" with icon caution
		return
	end if
	
	-- Show device selection dialog
	set promptText to "Select " & deviceType & " device:" & return & "(Current: " & currentDevice & ")"
	set userChoice to choose from list displayList with prompt promptText with title "Switch " & deviceType & " Device" default items {item 1 of displayList}
	
	if userChoice is false then return
	
	-- Extract device name (remove checkmark and "(current)" suffix if present)
	set selectedDisplay to item 1 of userChoice
	set selectedDevice to extractDeviceName(selectedDisplay)
	
	-- Find the matching clean device name
	set targetDevice to ""
	repeat with i from 1 to count of cleanList
		if (item i of cleanList) is selectedDevice then
			set targetDevice to item i of cleanList
			exit repeat
		end if
	end repeat
	
	if targetDevice is "" then
		-- Fallback: try to match by checking if clean name contains selected
		repeat with i from 1 to count of cleanList
			if (item i of cleanList) contains selectedDevice or selectedDevice contains (item i of cleanList) then
				set targetDevice to item i of cleanList
				exit repeat
			end if
		end repeat
	end if
	
	if targetDevice is "" then
		set targetDevice to selectedDevice
	end if
	
	-- Switch to selected device
	try
		do shell script switchAudioPath & " -t " & deviceType & " -s " & quoted form of targetDevice
		display notification "Switched " & deviceType & " to: " & targetDevice with title "Audio Switcher"
	on error errMsg
		display dialog "Error switching " & deviceType & " device: " & errMsg buttons {"OK"} default button "OK" with icon stop
	end try
end switchDevice

on switchBothDevices(switchAudioPath)
	-- Get devices that exist in both input and output lists
	try
		set outputList to do shell script switchAudioPath & " -a -t output"
		set inputList to do shell script switchAudioPath & " -a -t input"
	on error errMsg
		display dialog "Error getting devices: " & errMsg buttons {"OK"} default button "OK" with icon stop
		return
	end try
	
	set outputDevices to paragraphs of outputList
	set inputDevices to paragraphs of inputList
	
	-- Find common devices (devices that support both input and output)
	set commonDevices to {}
	repeat with outDevice in outputDevices
		set outDevice to outDevice as text
		if outDevice is not "" then
			repeat with inDevice in inputDevices
				if (inDevice as text) is outDevice then
					set end of commonDevices to outDevice
					exit repeat
				end if
			end repeat
		end if
	end repeat
	
	if (count of commonDevices) is 0 then
		display dialog "No devices found that support both input and output." & return & return & "Use separate switching for input and output devices." buttons {"OK"} default button "OK" with icon caution
		return
	end if
	
	-- Get current devices
	try
		set currentOutput to do shell script switchAudioPath & " -c -t output"
	on error
		set currentOutput to ""
	end try
	try
		set currentInput to do shell script switchAudioPath & " -c -t input"
	on error
		set currentInput to ""
	end try
	
	-- Build display list with current markers
	set displayList to {}
	repeat with deviceName in commonDevices
		set deviceName to deviceName as text
		set marker to "  "
		set suffix to ""
		if deviceName is currentOutput and deviceName is currentInput then
			set marker to "✓ "
			set suffix to " (current both)"
		else if deviceName is currentOutput then
			set marker to "○ "
			set suffix to " (current output)"
		else if deviceName is currentInput then
			set marker to "○ "
			set suffix to " (current input)"
		end if
		set end of displayList to marker & deviceName & suffix
	end repeat
	
	-- Show selection dialog
	set promptText to "Select device for both input & output:" & return & "(Current Output: " & currentOutput & ")" & return & "(Current Input: " & currentInput & ")"
	set userChoice to choose from list displayList with prompt promptText with title "Switch Both Devices" default items {item 1 of displayList}
	
	if userChoice is false then return
	
	-- Extract device name
	set selectedDisplay to item 1 of userChoice
	set selectedDevice to extractDeviceName(selectedDisplay)
	
	-- Remove additional suffixes for "both" and "output/input" markers
	if selectedDevice ends with " (current both)" then
		set selectedDevice to text 1 thru -15 of selectedDevice
	else if selectedDevice ends with " (current output)" then
		set selectedDevice to text 1 thru -17 of selectedDevice
	else if selectedDevice ends with " (current input)" then
		set selectedDevice to text 1 thru -16 of selectedDevice
	end if
	
	-- Find matching device name
	set targetDevice to ""
	repeat with dev in commonDevices
		if (dev as text) is selectedDevice then
			set targetDevice to dev as text
			exit repeat
		end if
	end repeat
	
	if targetDevice is "" then
		set targetDevice to selectedDevice
	end if
	
	-- Switch both input and output
	try
		do shell script switchAudioPath & " -t output -s " & quoted form of targetDevice
		do shell script switchAudioPath & " -t input -s " & quoted form of targetDevice
		display notification "Switched both input & output to: " & targetDevice with title "Audio Switcher"
	on error errMsg
		display dialog "Error switching devices: " & errMsg buttons {"OK"} default button "OK" with icon stop
	end try
end switchBothDevices

on extractDeviceName(displayName)
	-- Remove marker prefixes (✓, ○, or spaces)
	set cleanName to displayName
	if cleanName starts with "✓ " then
		set cleanName to text 3 thru -1 of cleanName
	else if cleanName starts with "○ " then
		set cleanName to text 3 thru -1 of cleanName
	else if cleanName starts with "  " then
		set cleanName to text 3 thru -1 of cleanName
	end if
	
	-- Remove various suffixes
	if cleanName ends with " (current)" then
		set cleanName to text 1 thru -11 of cleanName
	else if cleanName ends with " (current both)" then
		set cleanName to text 1 thru -15 of cleanName
	else if cleanName ends with " (current output)" then
		set cleanName to text 1 thru -17 of cleanName
	else if cleanName ends with " (current input)" then
		set cleanName to text 1 thru -16 of cleanName
	end if
	
	return cleanName
end extractDeviceName

on showCurrentDevices(switchAudioPath)
	try
		set currentOutput to do shell script switchAudioPath & " -c -t output"
	on error
		set currentOutput to "Unknown"
	end try
	
	try
		set currentInput to do shell script switchAudioPath & " -c -t input"
	on error
		set currentInput to "Unknown"
	end try
	
	display dialog "Current Audio Devices:" & return & return & "Output: " & currentOutput & return & "Input: " & currentInput buttons {"Switch Output", "Switch Input", "OK"} default button "OK" with title "Current Devices"
	
	set buttonPressed to button returned of result
	if buttonPressed is "Switch Output" then
		switchDevice(switchAudioPath, "output")
	else if buttonPressed is "Switch Input" then
		switchDevice(switchAudioPath, "input")
	end if
end showCurrentDevices
