obs = obslua
m_sFilename = "Deaths.txt" -- Name of the Death counter file
m_sFileLocation = "" -- Location of the Death counter file
m_iDeathCount = 0 -- Number of Deaths

m_reset_id = obs.OBS_INVALID_HOTKEY_ID
m_Death_Plus = obs.OBS_INVALID_HOTKEY_ID
m_Death_Minus = obs.OBS_INVALID_HOTKEY_ID

-- Reset Death counter.
function Reset(pressed)
   if(pressed) then
      local props = obs.obs_properties_create()      
      m_iDeathCount = 0
      
      local fin = io.open(m_sFileLocation.."/"..m_sFilename,"w+")
      fin:write(m_iDeathCount)
      fin:close()
   end
end

-- Increment Death counter.
function Increment(pressed)
   if(pressed) then
      m_iDeathCount = m_iDeathCount + 1
      
      local fin = io.open(m_sFileLocation.."/"..m_sFilename,"w+")
      fin:write(m_iDeathCount)
      fin:close()
   end
end

-- Decrement Death counter.
function Decrement(pressed)
   if(pressed) then
      m_iDeathCount = m_iDeathCount - 1
      
      local fin = io.open(m_sFileLocation.."/"..m_sFilename,"w+")
      fin:write(m_iDeathCount)
      fin:close()
   end
end

-- Sets the OBS saved value for m_sFileLocation.
function script_properties()
   local props = obs.obs_properties_create()
   
   obs.obs_properties_add_path(props,"death_file_location","Counter file location:",obs.OBS_PATH_DIRECTORY,"",NULL)
   return props
end

-- Description of what the script does.
function script_description()
   return "Death counter\nBy Jason A. Biddle of Maiden's Kiss Studios"
end

-- Updates m_sFileLocation when updated in properties window.
function script_update(settings)
   m_sFileLocation = obs.obs_data_get_string(settings,"death_file_location")
   
   local fin = io.open(m_sFileLocation.."/"..m_sFilename,"r")
   
   if(fin) then
      m_iDeathCount = fin:read()
      fin:close()
   else
      fin = io.open(m_sFileLocation.."/"..m_sFilename,"w+")
      fin:write("0")
      fin:close()
   end
end

-- Default settings for intial setup of script(none at this time).
function script_defaults(settings)
end

-- Saves the hotkey values that the user has set for the script.
function script_save(settings)
   -- Saving reset key.
   local hotkey_save_array = obs.obs_hotkey_save(m_reset_id)
   obs.obs_data_set_array(settings,"DC_Reset_key",hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)
   
   -- Saving plus key
   hotkey_save_array = obs.obs_hotkey_save(m_Death_Plus)
   obs.obs_data_set_array(settings,"DC_Plus_key",hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)
   
   -- Saving minus key
   hotkey_save_array = obs.obs_hotkey_save(m_Death_Minus)
   obs.obs_data_set_array(settings,"DC_Minus_key",hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)
end

-- Loads up script settings including currenct Death count, file location, and hotkey values.
function script_load(settings)
   -- Setting saved file location.
   m_sFileLocation = obs.obs_data_get_string(settings,"death_file_location")
   
   -- Lets see if the file exist and if so load that data in.
   local fin = io.open(m_sFileLocation.."/"..m_sFilename,"r")
   
   -- Read the Death count then close the file.
   if(fin) then
      m_iDeathCount = fin:read()
      fin:close()      
   end   
   
   -- Load in the saved hotkeys.
   m_reset_id = obs.obs_hotkey_register_frontend("DC_Reset_key","Death count reset",Reset)
   m_Death_Minus = obs.obs_hotkey_register_frontend("DC_Minus_key","Death count minus",Decrement)
   m_Death_Plus = obs.obs_hotkey_register_frontend("DC_Plus_key","Death count plus",Increment)
   
   -- Load in Reset Key
   local hotkey_save_array = obs.obs_data_get_array(settings,"DC_Reset_key")
   obs.obs_hotkey_load(m_reset_id,hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)
   
   -- Load in Plus Key
   hotkey_save_array = obs.obs_data_get_array(settings,"DC_Plus_key")
   obs.obs_hotkey_load(m_Death_Plus,hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)
   
   -- Load in Minus Key
   hotkey_save_array = obs.obs_data_get_array(settings,"DC_Minus_key")
   obs.obs_hotkey_load(m_Death_Minus,hotkey_save_array)
   obs.obs_data_array_release(hotkey_save_array)
end