import obspython as obs
import datetime

source_name = ""

def time_update():
    current_time = datetime.datetime.now()
    source = obs.obs_get_source_by_name(source_name)
    
    if source != None:
        settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", current_time.strftime("%A %B %d, %Y %H:%M:%S %Z"))
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)

def script_description():
    return "Displays the current date and time on screen.  By Jason A. Biddle"

def script_properties():
    props = obs.obs_properties_create()
    p = obs.obs_properties_add_list(props,"dislocation","Display Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    sources = obs.obs_enum_sources()

    if sources != None:
        for source in sources:
            source_id = obs.obs_source_get_unversioned_id(source)
            if source_id == "text_gdiplus" or source_id == "text_ft2_source":
                name = obs.obs_source_get_name(source)
                obs.obs_property_list_add_string(p, name, name)

    obs.source_list_release(sources)

    return props

def script_defaults(setting):
    pass

def script_update(setting):
    global source_name
    source_name = obs.obs_data_get_string(setting, "dislocation")

def script_save(setting):
    pass

def script_load(setting):
    source_name = obs.obs_data_get_string(setting,"dislocation")
    if source_name != None:
        obs.timer_add(time_update,1000)

def script_unload():
    if source_name != None or source_name == "":
        obs.timer_remove(time_update)