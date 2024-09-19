extends CanvasLayer

# Pre-define colors
var normal_color = Color(1, 1, 1)  # Default white color
var focus_color = Color(0, 1, 0)   # Green color for focused button

# Reference to buttons
@onready var buttons = [
	$ButtonSubmit,
	$ButtonDeny,
	$ButtonDestroy
]

# Keep track of which button is focused
var focused_button_index = 0

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
	
	if Input.is_action_just_pressed("action") and Ending.visible == true:
		if $ButtonSubmit.has_focus():
			_on_button_submit_pressed()
		elif $ButtonDeny.has_focus():
			_on_button_deny_pressed()
		elif $ButtonDestroy.has_focus():
			_on_button_destroy_pressed()

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


func _on_button_submit_pressed():
	Ending.visible = false
	Hud.current_message = 4
	Hud.typing = true
	Hud.start_dialogue()


func _on_button_deny_pressed():
	Ending.visible = false
	Hud.current_message = 5
	Hud.typing = true
	Hud.start_dialogue()


func _on_button_destroy_pressed():
	Ending.visible = false
	Hud.current_message = 6
	Hud.typing = true
	Hud.start_dialogue()
