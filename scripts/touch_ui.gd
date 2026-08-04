# (C) 2026 Jan Migo
extends Control

@onready var btn_break: Button = $LMB
@onready var btn_place: Button = $RMB
@onready var btn_up: Button = $W
@onready var btn_down: Button = $S
@onready var btn_left: Button = $A
@onready var btn_right: Button = $D
@onready var btn_jump: Button = $SPACE

func _ready() -> void:
	btn_break.pressed.connect(func(): _trigger_action("break_block"))
	btn_place.pressed.connect(func(): _trigger_action("place_block"))
	if btn_jump: btn_jump.pressed.connect(func(): _trigger_action("ui_accept"))
	
	if btn_left: btn_left.pressed.connect(func(): _trigger_action("ui_left"))
	if btn_right: btn_right.pressed.connect(func(): _trigger_action("ui_right"))
	if btn_up: btn_up.pressed.connect(func(): _trigger_action("ui_up"))
	if btn_down: btn_down.pressed.connect(func(): _trigger_action("ui_down"))
	visible = false

func _trigger_action(action_name: String) -> void:
	# Simulate a press event for the input map action
	var ev = InputEventAction.new()
	ev.action = action_name
	ev.pressed = true
	Input.parse_input_event(ev)

func _input(event: InputEvent) -> void:
	# If a touch event occurs, enable mobile controls on the fly
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if not visible:
			visible = true
