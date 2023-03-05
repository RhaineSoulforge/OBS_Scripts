obs = obslua
filename = "FNVictories.txt"  -- Name and location of the save file.
filelocation = "" -- Location of Victory count
iWins = 0 -- Number of Victories.
iCrownWins = 0 -- Number of Crowned Victories.

-- Sets hotkeys to null until either loaded or set.
m_reset_id = obs.OBS_INVALID_HOTKEY_ID
m_cvictory_id = obs.OBS_INVALID_HOTKEY_ID
m_victory_id = obs.OBS_INVALID_HOTKEY_ID

-- Resets all counts.
function Reset(pressed)
   if(pressed) then
      iWins = 0
      iCrownWins = 0
      
      local fin = io.open(filelocation.."/"..filename,"w+")
      fin:write(iWins.." ("..iCrownWins..")")
      fin:close()      
   end
end

-- Increments Crowned Victory counter (iCrownWins)
function CrownedVictory(pressed)
   if(pressed) then
      iWins = iWins + 1
      iCrownWins = iCrownWins + 1
      
      local fin = io.open(filelocation.."/"..filename,"w+")
      fin:write(iWins.." ("..iCrownWins..")")
      fin:close()
   end
end

-- Increment Victory counter (iWins)
function Victory(pressed)
   if(pressed) then
      iWins = iWins + 1
      
      local fin = io.open(filelocation.."/"..filename,"w+")
      fin:write(iWins.." ("..iCrownWins..")")
      fin:close()
   end
end

-- Sets the OBS saved values for file_location and file_name.
function script_properties()
   local props = obs.obs_properties_create()
   
   obs.obs_properties_add_path(props,"file_location","Counter file location:",obs.OBS_PATH_DIRECTORY,"",NULL)
   obs.obs_properties_add_text(props,"file_name","Counter File Name:",obs.OBS_TEXT_DEFAULT)
   
   return props
end

-- Description of what the script does.
function script_description()
   return "Fornite victories counter.\nBy Jason A Biddle of Maiden's Kiss Studios"
end

-- Updates the filename when location of file or name of file is changed.
function script_update(settings)
   filelocation = obs.obs_data_get_string(settings,"file_location")
   filename = obs.obs_data_get_string(settings,"file_name")
end

-- Default setting for the script on initial setup.
function script_defaults(settings)
   obs.obs_data_set_default_string(settings,"file_name",filename)
end

-- Save the hotkey values that the user has set in OBS.
function script_save(settings)
	local hotkey_save_array = obs.obs_hotkey_save(m_reset_id)
	obs.obs_data_set_array(settings, "reset_hotkey", hotkey_save_array)
	obs.obs_data_array_release(hotkey_save_array)

	hotkey_save_array = obs.obs_hotkey_save(m_cvictory_id)
	obs.obs_data_set_array(settings, "cvictory_hotkey", hotkey_save_array)
	obs.obs_data_array_release(hotkey_save_array)

	hotkey_save_array = obs.obs_hotkey_save(m_victory_id)
	obs.obs_data_set_array(settings, "victory_hotkey", hotkey_save_array)
	obs.obs_data_array_release(hotkey_save_array)
end

function script_load(settings)
   -- Set the location and name of file (if not using default values.)
   filelocation = obs.obs_data_get_string(settings,"file_location")
   filename = obs.obs_data_get_string(settings,"file_name")
   
   -- Open the victory and read the entry.
   local fin = io.open(filelocation.."/"..filename,"r")
   
   if(fin) then
      local val = fin:read()
      
      --Get wins from file
      local pos = string.find(val," ")
      iWins = string.sub(val,0,pos)
      
      --Get Crowned wins from file
      local start = string.find(val,"%(")
      local endpos = string.find(val,"%)")
      iCrownWins = string.sub(val,start + 1,endpos - 1)

      -- Close the file we're done with it for now.
      fin:close()
   end
   
   m_reset_id = obs.obs_hotkey_register_frontend("reset_hotkey","Victory Reset",Reset)
   m_cvictory_id = obs.obs_hotkey_register_frontend("cvictory_hotkey","Crowned Victory",CrownedVictory)
   m_victory_id = obs.obs_hotkey_register_frontend("victory_hotkey","Victory",Victory)   
   
   local hotkey_save_array = obs.obs_data_get_array(settings,"reset_hotkey")
   obs.obs_hotkey_load(m_reset_id,hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)

   hotkey_save_array = obs.obs_data_get_array(settings,"cvictory_hotkey")
   obs.obs_hotkey_load(m_cvictory_id,hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)

   hotkey_save_array = obs.obs_data_get_array(settings,"victory_hotkey")
   obs.obs_hotkey_load(m_victory_id,hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)
end