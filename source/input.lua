local input = {}

-- records whether or not a key is down
-- example:
-- input.keyStates["Gamepad 1"]["buttonA"] will be true if "buttonA" is down
-- on the device with the ID of "Gamepad 1" (tostring(event.device) in key event function)
input.keyState = {}

return input