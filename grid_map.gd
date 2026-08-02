# (C) 2026 Jan Migo
extends GridMap

const SIZE = 16

@onready var camera: Camera3D = get_viewport().get_camera_3d()

var total_shades: int = 11

func _ready() -> void:
	randomize()
	
	# Generate the initial 16x16x16 solid cube
	for x in range(SIZE):
		for y in range(SIZE):
			for z in range(SIZE):
				var random_shade = randi() % total_shades
				set_cell_item(Vector3i(x, y, z), random_shade)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_sculpt(false) # Destroy block
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_sculpt(true)  # Place block

func _sculpt(is_placing: bool) -> void:
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 100.0
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result = space_state.intersect_ray(query)
	
	if result:
		var hit_pos = result.position
		var normal = result.normal
		
		if is_placing:
			hit_pos += normal * 0.1
		else:
			hit_pos -= normal * 0.1
			
		var map_pos = local_to_map(to_local(hit_pos))
		
		if 0 <= map_pos.x and map_pos.x < SIZE and \
		   0 <= map_pos.y and map_pos.y < SIZE and \
		   0 <= map_pos.z and map_pos.z < SIZE:
			
			if is_placing:
				var random_shade = randi() % total_shades
				set_cell_item(map_pos, random_shade)
			else:
				set_cell_item(map_pos, -1)