extends Node3D

var working: bool = true

var fps_preset_next: int = 15

var fps_max: int = 0

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			Engine.max_fps = 15
		NOTIFICATION_WM_WINDOW_FOCUS_IN:
			Engine.max_fps = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if working:
			Engine.max_fps = 15
		else:
			Engine.max_fps = fps_max
		working=!working
	if event.is_action_pressed("fps_change") and working == true:
		Engine.max_fps = fps_preset_next
		fps_max=fps_preset_next
		fps_preset_next += 15
		if fps_preset_next>75:
			fps_preset_next=0