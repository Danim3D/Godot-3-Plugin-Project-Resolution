# https://github.com/Danim3D/godot-plugin-project-resolution

# Folder structure to use the plugin look like this inside the addons folder in your Godot project : "res://addons/ProjectResolution"

tool
extends EditorPlugin

const POPUP_BUTTON_TEXT = "Project Resolution"
const MENU_BUTTON_TOOLTIP = "Quickly change and test different Project Resolution settings"
const PLUGIN_SELF_NAME = "ProjectResolution" #this variable must match the name of the plugin

var _plugin_menu_btn = MenuButton.new()
var _plugins_menu = _plugin_menu_btn.get_popup()

var _menu_items_idx = 0
var play_on_change = false
var multistart = false
var landscape = false


func _enter_tree():
	_plugin_menu_btn.text = POPUP_BUTTON_TEXT
	_plugin_menu_btn.hint_tooltip = MENU_BUTTON_TOOLTIP
	_plugin_menu_btn.icon = return_editor_icon("Viewport")
	
	_populate_menu()
	
	_plugins_menu.connect("id_pressed", self, "_item_toggled", [_plugins_menu])
	_plugin_menu_btn.get_popup().connect("id_pressed", self, "_set_resolution", [_plugin_menu_btn])
		
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, _plugin_menu_btn)


func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, _plugin_menu_btn)
	if _plugin_menu_btn:
		_plugin_menu_btn.queue_free()


func return_editor_icon(icon_name):
	if Engine.editor_hint:
		# Find internal `EditorNode` class.
		var editor_node = get_tree().get_root().get_child(0)
		# Get internal GUI base.
		# This is equivalent to `EditorInterface.get_base_control()`.
		var gui_base = editor_node.get_gui_base()
		# Get icon from the base control.
		var icon = gui_base.get_icon(icon_name, "EditorIcons")
		#_plugin_menu_btn.icon = icon_add
		return icon


func _refresh_plugins_menu_list():
	_plugins_menu.clear()
	_menu_items_idx = 0
	_populate_menu()


func _populate_menu():
	var current_fullscreen = ProjectSettings.get_setting("display/window/size/fullscreen")
	var current_res = str(ProjectSettings.get_setting("display/window/size/width"))+"x"+str(ProjectSettings.get_setting("display/window/size/height"))
	
	#by default added buttons are unchecked unless true
	var isPluginEnabled = false
	
	#Add Button settings
	var _buttons = ["Fullscreen", "Play On Change", "Multistart"]
	for button in _buttons:
		isPluginEnabled = false
		if button == "Fullscreen" and current_fullscreen == true:
			isPluginEnabled = true
		if button == "Play On Change" and play_on_change == true:
			isPluginEnabled = true
		if button == "Multistart" and multistart == true:
			isPluginEnabled = true

		_plugins_menu.add_check_item(button)
		_plugins_menu.set_item_checked(_menu_items_idx, isPluginEnabled)
		_menu_items_idx += 1
	
	#Add desktop resolutions
	_plugins_menu.add_separator("Desktop");
	_menu_items_idx += 1
	
	var _resolutions = ["Native", "2560x1600", "2560x1440", "1920x1200", "1920x1080", "1600x1200", "1280x1024", "1280x720", "1024x768", "800x600", "720x405", "640x480", "640x360","320x240"]
	for resolution in _resolutions:
		isPluginEnabled = false
		if resolution == current_res:
			isPluginEnabled = true
		
		_plugins_menu.add_check_item(resolution)
		_plugins_menu.set_item_checked(_menu_items_idx, isPluginEnabled)
		_menu_items_idx += 1
	
	#Add widescreen resolutions
	_plugins_menu.add_separator("Widescreen");
	_menu_items_idx += 1
	
	var _widescreen_resolutions = ["5120x1440", "3840x1080", "2560x1080", "2560x720", "1920x540", "1280x360"]
	for resolution in _widescreen_resolutions:
		isPluginEnabled = false
		if resolution == current_res:
			isPluginEnabled = true
		
		_plugins_menu.add_check_item(resolution)
		_plugins_menu.set_item_checked(_menu_items_idx, isPluginEnabled)
		_menu_items_idx += 1
	
	#Add mobile resolutions
	_plugins_menu.add_separator("Mobile");
	_menu_items_idx += 1
	
	var buttonLandscape = "Landscape"
	if landscape == true:
		isPluginEnabled = true
	_plugins_menu.add_check_item(buttonLandscape)
	_plugins_menu.set_item_checked(_menu_items_idx, isPluginEnabled)
	_menu_items_idx += 1
	
	var _mobile_resolutions = ["1536x2048", "768x1024", "1242x2208", "1080x1920", "768x1280", "750x1334", "640x1136", "640x960", "480x800", "375x667", "414x896", "375x812", "320x640", "320x480"]
	for resolution in _mobile_resolutions:
		isPluginEnabled = false
		if resolution == current_res:
			isPluginEnabled = true
		if landscape == true:
			var res = resolution.split("x")
			resolution = res[1]+"x"+res[0]
		
		_plugins_menu.add_check_item(resolution)
		_plugins_menu.set_item_checked(_menu_items_idx, isPluginEnabled)
		_menu_items_idx += 1


func _item_toggled(id, menuBtn):
	var is_item_checked = menuBtn.is_item_checked(id)
	_plugins_menu.set_item_checked(id, not is_item_checked)
	
	_refresh_plugins_menu_list()


func _set_resolution(id, menuBtn):
	var is_item_checked = menuBtn.get_popup().is_item_checked(id)
	_plugins_menu.set_item_checked(id, not is_item_checked)
	
	var item_name = menuBtn.get_popup().get_item_text(id)
	if item_name == "Fullscreen":
		#Set Project Fullscreen setting
		ProjectSettings.set_setting("display/window/size/fullscreen", not ProjectSettings.get_setting("display/window/size/fullscreen"))
		print("Fullscreen: "+str(ProjectSettings.get_setting("display/window/size/fullscreen")))
	elif item_name == "Play On Change":
		play_on_change = !play_on_change
		print("Play On Change: "+str(play_on_change))
	elif item_name == "Multistart":
		multistart = !multistart
		print("Multistart: "+str(multistart))
	elif item_name == "Landscape":
		landscape = !landscape
		print("Landscape: "+str(landscape))
	else:
		#Set Project Resolution settings
		if item_name == "Native":
			item_name = str(OS.get_screen_size().x) + "x" + str(OS.get_screen_size().y)
		
		var res = item_name.split("x")
		ProjectSettings.set_setting("display/window/size/height", int(res[1]))
		ProjectSettings.set_setting("display/window/size/width", int(res[0]))
		print("Set Project Resolution: " + str(ProjectSettings.get_setting("display/window/size/width"))+"x"+str(ProjectSettings.get_setting("display/window/size/height")))
		
		#Update menu button name by resolution
		menuBtn.text = item_name
		
		if play_on_change and !multistart:
			#play after resolution selected
			if ProjectSettings.get_setting("display/window/size/height") > OS.get_screen_size().y:
				print("Project Settings Height resolution is higher than desktop resolution.")
			get_editor_interface().play_main_scene()
		else:
			#if multistart is true, set fullscreen to false
			ProjectSettings.set_setting("display/window/size/fullscreen", false)
		if multistart and not ProjectSettings.get_setting("display/window/size/fullscreen"):
			#start 2 window instance
			var spacing = 2
			var window_pos = Vector2(OS.get_screen_size().x/2 - ProjectSettings.get_setting("display/window/size/width")-spacing, OS.get_screen_size().y/2 - ProjectSettings.get_setting("display/window/size/height")/2)
			OS.execute(OS.get_executable_path(), ["--path", ".", "--position", window_pos], false)
			window_pos = Vector2(OS.get_screen_size().x/2+spacing, OS.get_screen_size().y/2 - ProjectSettings.get_setting("display/window/size/height")/2)
			OS.execute(OS.get_executable_path(), ["--path", ".", "--position", window_pos], false)
	
	ProjectSettings.save()
	
	_refresh_plugins_menu_list()
