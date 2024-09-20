extends CanvasLayer

# Pre-define colors
var normal_color = Color(1, 1, 1)  # Default white color
var focus_color = Color(0, 1, 0)   # Green color for focused button

@onready var FocusTimer = $Timer
var can_click = false

# Reference to buttons
@onready var buttons = [
	$ButtonSubmit,
	$ButtonDeny,
	$ButtonDestroy
]

# Keep track of which button is focused
var focused_button_index = 0

var buttons_refresh = false
var submit_pressed = false

# Variables to control joystick input speed
var debounce_time = 0.2  # Time in seconds between joystick inputs
var joystick_timer = 0.0

# Joystick deadzone threshold to avoid registering tiny movements
var joystick_deadzone = 0.5

func _ready():
	# Initially focus the first button
	focus_button(focused_button_index)

func _process(delta):
	# Update the timer for joystick input debouncing
	if joystick_timer > 0:
		joystick_timer -= delta

	# Handle joystick navigation with debouncing
	handle_joystick_input()
	
	if visible and buttons_refresh == false:
		focused_button_index = 0
		focus_button(0)
		buttons_refresh = true
		$Timer2.start()
	
	
	if Input.is_action_just_pressed("action") and Ending.visible == true and can_click:
		if focused_button_index == 0:
			_on_button_submit_pressed()
		elif focused_button_index == 1:
			_on_button_deny_pressed()
		elif focused_button_index == 2:
			_on_button_destroy_pressed()
			
	if submit_pressed:
		# Create a frantic vibration effect by randomly offsetting the label's position    
		var random_x = randf_range(-vibration_intensity, vibration_intensity)
		var random_y = randf_range(-vibration_intensity, vibration_intensity)
		Hud.Content.position = original_position + Vector2(random_x, random_y)
		# the world get's darker. 
		# some text on the screen says you continue to live but it's miserable. 
		

func _input(event):
	# Handle keyboard input as before
	if event.is_action_pressed("menu_down"):
		move_focus(1)
	elif event.is_action_pressed("menu_up"):
		move_focus(-1)

# Handle joystick input with debouncing
func handle_joystick_input():
	var joystick_value = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)  # Read the Y axis of the left joystick

	if joystick_timer <= 0:
		if joystick_value > joystick_deadzone:  # Down movement
			move_focus(1)
			joystick_timer = debounce_time  # Reset the debounce timer
		elif joystick_value < -joystick_deadzone:  # Up movement
			move_focus(-1)
			joystick_timer = debounce_time  # Reset the debounce timer

# Function to move focus based on input
func move_focus(direction):
	focused_button_index += direction
	if focused_button_index >= buttons.size():
		focused_button_index = 0  # Wrap around to the first button
	elif focused_button_index < 0:
		focused_button_index = buttons.size() - 1  # Wrap around to the last button
	
	focus_button(focused_button_index)

# Focus a specific button and change colors
func focus_button(index):
	for i in range(buttons.size()):
		if i == index:
			buttons[i].grab_focus()  # Set focus on the button
			buttons[i].get_child(0).modulate = focus_color  # Change label color (assuming the label is the first child)
		else:
			buttons[i].get_child(0).modulate = normal_color  # Reset other buttons to normal color

@export var vibration_intensity: float = 5.0  # Intensity of the vibration
@export var vibration_speed: float = 0.1  # Speed of vibration
var original_position

func _on_button_submit_pressed():
	original_position = Hud.Content.position
	$ButtonSubmit.visible = false
	$ButtonDeny.visible = false
	$ButtonDestroy.visible = false
	Hud.current_message = 4
	Hud.typing = true
	Hud.start_dialogue()

	Hud.wood_current = 0
	Hud.stone_current = 0
	Hud.Content.add_theme_color_override("font_color", Color(1, 0, 0))  # Red color
	submit_pressed = true
	$Fade/AnimationPlayer.play("fade")



func _on_button_deny_pressed():
	self.visible = false
	Hud.current_message = 5
	Hud.typing = true
	Hud.start_dialogue()
	# the world fades to black
	# you are immedietly killed by the tower


func _on_button_destroy_pressed():
	self.visible = false
	Hud.current_message = 6
	Hud.typing = true
	Hud.start_dialogue()
	#bonus level with actual good ending. 


func _on_timer_timeout():
	$Timer.stop()
	$Timer2.start()


func _on_timer_2_timeout():
	$Timer2.stop()
	can_click = true
