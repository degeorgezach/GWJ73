extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var sensitivity_x = 2.0  # Sensitivity for horizontal (left/right) camera movement
var sensitivity_y = 128.0  # Increased sensitivity for vertical (up/down) camera movement
var invert_y = true     # Option to invert Y axis
var joystick_deadzone = 0.1  # Deadzone to prevent jitter

var sensitivity = 0.003
@onready var camera = $Camera3D


@onready var raycast = $Camera3D/RayCast3D
var can_collect_wood: bool = false
var tree_in_sight: Node = null
var can_collect_stone: bool = false
var stone_in_sight: Node = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):			
	# Handle joystick input in the same function
	handle_joystick_input(delta)
	handle_tree_interaction()
	handle_stone_interaction()
	
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()


func _physics_process(delta):
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
	# Move camera with mouse
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(70))
		$Camera3D/MeshInstance3D.position = camera.position
		$Camera3D/MeshInstance3D.position.z -= 1




# Handle joystick input
func handle_joystick_input(delta):
	var device_id = 0  # Assuming first controller (usually ID 0)

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




# Detect if player is looking at the tree
func handle_tree_interaction():
	# Check if the raycast is colliding
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		print("Colliding with: ", collider)
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


# Detect if player is looking at the stone
func handle_stone_interaction():
	# Check if the raycast is colliding
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		print("Colliding with: ", collider)
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

func collect_wood():
	Hud.wood_current += 1
	var tree = tree_in_sight.get_owner()
	tree.queue_free()
	Hud.TimberCollectLabel.visible = false
	can_collect_wood = false
	
	
	
func collect_stone():
	Hud.stone_current += 1
	var stone = stone_in_sight.get_owner()
	stone.queue_free()
	Hud.StoneCollectLabel.visible = false
	can_collect_stone = false
