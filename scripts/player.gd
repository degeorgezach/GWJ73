extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var sensitivity_x = 2.0  # Sensitivity for horizontal (left/right) camera movement
var sensitivity_y = 128.0  # Increased sensitivity for vertical (up/down) camera movement
var invert_y = true     # Option to invert Y axis
var joystick_deadzone = 0.1  # Deadzone to prevent jitter
var is_camera_locked = false

var sensitivity = 0.003
@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
var can_collect_wood: bool = false
var tree_in_sight: Node = null
var can_collect_stone: bool = false
var stone_in_sight: Node = null

@onready var raycast_tower = $Camera3D/RayCast3DTower
var tower_in_sight: Node = null
var can_upgrade_tower: bool = false

@export var target_node: Node
@export var move_speed: float = 50.0  # Speed of the camera movement
@export var rotate_speed: float = 50.0  # Speed of the camera rotation

var condition_met = false  # Placeholder for your condition logic
var something_bad_happening = false

var target_fov = 60.0  # Default field of view for your camera
var zoomed_in_fov = 35.0  # Desired FOV when zoomed in
var zoom_speed = 1.0  # Adjust the speed of zooming
var current_fov = 60.0  # Keep track of the current FOV
var near_clip = 0.1  # Near clipping plane
var far_clip = 1000.0  # Far clipping plane

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var world = self.get_owner()
	target_node = world.get_node("Tower")
	original_position = Hud.Content.position
	current_fov = target_fov
	set_camera_perspective(current_fov)


# Sets the camera's perspective projection with FOV, near, and far clipping planes
func set_camera_perspective(fov: float):
	var aspect_ratio = get_viewport().get_size().x / get_viewport().get_size().y
	$Camera3D.set_perspective(fov, near_clip, far_clip)

func _process(delta):
	handle_joystick_input(delta)
	handle_tree_interaction()
	handle_stone_interaction()
	handle_tower_interaction()
	
	if Hud.wood_current >= Hud.wood_needed and Hud.stone_current >= Hud.stone_needed and !condition_met:
		condition_met = true
		Hud.current_message = 1
		Hud.typing = true
		Hud.start_dialogue()
	
	if condition_met:
		look_at_target()
		# Smoothly zoom in
		current_fov = lerp(current_fov, zoomed_in_fov, zoom_speed * delta)
	else:
		# Reset to default FOV if condition no longer met
		current_fov = lerp(current_fov, target_fov, zoom_speed * delta)
	# Apply the new FOV
	set_camera_perspective(current_fov)
	
	if Input.is_action_just_pressed("escape"):
		#get_tree().quit()
		if Pause.visible:
			Pause.visible = false
		else:
			Pause.visible = true
			Pause.focus_button(0)
		
	if Hud.time_left <= 0:
		something_bad_happens(delta)
	else:
		something_bad_happening = false
		


func _physics_process(delta):
	if Pause.visible == false:
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		var input_dir = Input.get_vector("left", "right", "up", "down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()


func _unhandled_input(event):	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Move camera with mouse
	if !is_camera_locked and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))
		$Camera3D/MeshInstance3D.position = camera.position
		$Camera3D/MeshInstance3D.position.z -= 1


func handle_joystick_input(delta):
	var device_id = 0
	# Get the right joystick input using Input.get_vector()
	var joystick_input = Input.get_vector("look_right", "look_left", "look_down", "look_up", joystick_deadzone)
	# If the joystick input exceeds the deadzone, apply the camera movement
	if joystick_input.length() > joystick_deadzone:
		# Left/Right rotation (yaw)
		rotate_y(joystick_input.x * sensitivity_x * delta)
		# Up/Down rotation (pitch)
		var pitch_change = joystick_input.y * sensitivity_y * delta
		if invert_y:
			pitch_change = -pitch_change
		var new_rotation_x = rotation_degrees.x - pitch_change  # Invert up/down
		new_rotation_x = clamp(new_rotation_x, -90, 90)
		rotation_degrees.x = new_rotation_x


func handle_tree_interaction():
	# Check if the raycast is colliding
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		# Check if the collider is a tree (you can tag the tree with a group, like "tree")
		if collider != null and collider.is_in_group("trees"):
			# Player is close and looking at a tree
			Hud.TimberCollectLabel.visible = true
			tree_in_sight = collider
			can_collect_wood = true
		else:
			# Not looking at a tree
			Hud.TimberCollectLabel.visible = false
			tree_in_sight = null
			can_collect_wood = false
	else:
		
		Hud.TimberCollectLabel.visible = false
		tree_in_sight = null
		can_collect_wood = false


func handle_stone_interaction():
	# Check if the raycast is colliding
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		# Check if the collider is a stone
		if collider != null and collider.is_in_group("stones"):
			# Player is close and looking at a tree
			Hud.StoneCollectLabel.visible = true
			stone_in_sight = collider
			can_collect_stone = true
		else:
			# Not looking at a tree
			Hud.StoneCollectLabel.visible = false
			stone_in_sight = null
			can_collect_stone = false
	else:
		
		Hud.StoneCollectLabel.visible = false
		stone_in_sight = null
		can_collect_stone = false

# Input to collect wood
func _input(event):
	if event.is_action_pressed("action") and can_collect_wood:
		collect_wood()
	elif event.is_action_pressed("action") and can_collect_stone:
		collect_stone()
	elif event.is_action_pressed("action") and can_upgrade_tower and condition_met and !Hud.typing:
		upgrade_tower()
		
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func collect_wood():
	if tree_in_sight.is_in_group("mid"):
		Hud.wood_current += 4
	else:
		Hud.wood_current += 2
	var tree = tree_in_sight.get_owner()
	tree.queue_free()
	Hud.TimberCollectLabel.visible = false
	can_collect_wood = false
	$Sfx.play(0)
	
		
func collect_stone():
	if stone_in_sight.is_in_group("small"):
		Hud.stone_current += 1
	elif stone_in_sight.is_in_group("mid"):
		Hud.stone_current += 3
	var stone = stone_in_sight.get_owner()
	stone.queue_free()
	Hud.StoneCollectLabel.visible = false
	can_collect_stone = false
	$Sfx.play(1)


func look_at_target():
	if target_node != null:
		var target_position = target_node.global_transform.origin
		target_position.y += 15
		$Camera3D.look_at(target_position, Vector3.UP)
		look_at(target_position, Vector3.UP)


func handle_tower_interaction():
	# Check if the raycast_tower is colliding
	if raycast_tower.is_colliding():
		var collider = raycast_tower.get_collider()
		if collider != null and collider.is_in_group("towers") and condition_met:
			Hud.TowerUpgradeLabel.visible = true
			tower_in_sight = collider
			can_upgrade_tower = true
		else:
			Hud.TowerUpgradeLabel.visible = false
			tower_in_sight = null
			can_upgrade_tower = false
	else:
		Hud.TowerUpgradeLabel.visible = false
		tower_in_sight = null
		can_upgrade_tower = false


func upgrade_tower():
	if Hud.current_level < 4:
		Hud.TowerUpgradeLabel.visible = false
		var transform = tower_in_sight.global_transform
		tower_in_sight.get_owner().queue_free()
		var path = "res://scenes/fire_tower_" + str(Hud.current_level + 1) + ".tscn"
		var new_node = load(path).instantiate()
		new_node.global_transform = transform
		get_parent().add_child(new_node)
		tower_in_sight = new_node
		target_node = new_node
		advance_level()
	elif Hud.current_level == 4:
		$Music.Change(6)
		Hud.TowerUpgradeLabel.visible = false
		Hud.current_level += 1
		condition_met = false
		can_upgrade_tower = false
		target_node.scale = Vector3(2, 2, 2)
		Hud.wood_current = 0
		Hud.stone_current = 0
		Hud.wood_needed = 100
		Hud.stone_needed = 100
		Hud.TimberCollectLabel.visible = false
		Hud.StoneCollectLabel.visible = false
		Hud.TimberLabel.visible = false
		Hud.StoneLabel.visible = false
		Hud.RoundTimerLabel.visible = false
		Hud.RoundTimer.paused = true
		Hud.current_message = 3
		Hud.start_dialogue()


func advance_level():
	Hud.wood_current = Hud.wood_current - Hud.wood_needed
	Hud.stone_current = Hud.stone_current - Hud.stone_needed	
	Hud.wood_needed = ceil(Hud.wood_needed * 1.5)
	Hud.stone_needed = ceil(Hud.stone_needed * 1.5)
	condition_met = false
	can_upgrade_tower = false
	Hud.TowerUpgradeLabel.visible = false
	Hud.current_level += 1
	Hud.set_level_timer()


@export var vibration_intensity: float = 5.0  # Intensity of the vibration
@export var vibration_speed: float = 0.1  # Speed of vibration
var original_position: Vector2

func something_bad_happens(delta):
	Hud.current_message = 2	
	# things under this IF will happen one time, the rest of this method will happen on process()
	if Hud.typing == false and !something_bad_happening:
		if condition_met:
			condition_met = false
		$Music.Change(3)
		something_bad_happening = true
		Hud.start_dialogue()
		Hud.wood_current = 0
		Hud.stone_current = 0
	look_at_target()
	current_fov = lerp(current_fov, zoomed_in_fov, zoom_speed * delta)	
	set_camera_perspective(current_fov)
	Hud.Content.add_theme_color_override("font_color", Color(1, 0, 0))  # Red color
	# Create a frantic vibration effect by randomly offsetting the label's position    
	var random_x = randf_range(-vibration_intensity, vibration_intensity)
	var random_y = randf_range(-vibration_intensity, vibration_intensity)
	Hud.Content.position = original_position + Vector2(random_x, random_y)

