extends CanvasLayer

@onready var TimberCollectLabel = $TimberCollectLabel
@onready var StoneCollectLabel = $StoneCollectLabel
@onready var TowerUpgradeLabel = $TowerUpgradeLabel
@onready var TimberLabel = $TimberLabel
@onready var StoneLabel = $StoneLabel
@onready var RoundTimerLabel = $RoundTimerLabel
@onready var RoundTimer = $Timer

var loss_count = 0


var messages = [ "A mysterious and sentient tower has appeared from the shadows, looming ominously over the land. This enigmatic structure demands upgrades to unlock its true power. 

Brave adventurer, gather the necessary materials to enhance the tower before the time runs out. Fail to do so, and you will face the wrath of the tower’s dark fury.",

"You have gathered the required materials. The tower’s demand is clear: 
	
	You must return to the tower.",
	
"You're out of time! Now we both suffer… unless you do better. 

Restart, fool.",
	
"The tower is fully upgraded.",
	
"You have chosen to submit.", #4
	
"You have chosen to reject.", #5
	
"You have chosen to destroy." #6
]


var wood_current = 0 
var wood_needed = 1
var stone_current = 0 
var stone_needed = 1

var typing_speed = .055
var read_time = 20

var current_message = 0
var display = ""
var current_char = 0
var typing = false

@onready var Content = $Label

@export var lvl_1_countdown_time: int = 30 # Set initial countdown time (in seconds)
@export var lvl_2_countdown_time: int = 20 # Set initial countdown time (in seconds)
@export var lvl_3_countdown_time: int = 30 # Set initial countdown time (in seconds)
@export var lvl_4_countdown_time: int = 40 # Set initial countdown time (in seconds)
var time_left: int
var current_level = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	current_message = 0
	start_dialogue()
	time_left = lvl_1_countdown_time
	$Timer.start(1.0) # Start the timer, trigger every 1 second
	update_timer_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimberLabel.text = "Timber: " + str(wood_current) + " / " + str(wood_needed)
	$StoneLabel.text = "Stone: " + str(stone_current) + " / " + str(stone_needed)
	
	if Input.is_action_just_pressed("action") and Pause.visible == false and Ending.visible == false:
		if typing and $Label.text != messages[current_message]:
			$next_char.stop()
			$Label.text = messages[current_message]
			typing = false
		elif $Label.text == messages[current_message]:
			$Label.text = ""
			typing = false
			if current_message == 2:				
				set_level_timer()
				$Label.add_theme_color_override("font_color", Color(1, 1, 1))  # Set the color to white
			elif current_message == 3 and Ending.visible == false:
				Ending.visible = true
	
	if time_left < 30:
		$RoundTimerLabel.add_theme_color_override("font_color", Color(1, 0, 0))  # Set the color to red
	else:
		$RoundTimerLabel.add_theme_color_override("font_color", Color(1, 1, 1))  # Set the color to white
		
	if (current_message == 1 and $Label.text != "") or  Pause.visible:
		$Timer.paused = true
	else:
		$Timer.paused = false
		
	if current_level >= 5:
		$Timer.paused = true


func start_dialogue():
	typing = true
	display = ""
	current_char = 0	
	$next_char.set_wait_time(typing_speed)
	$next_char.start()

func _on_next_char_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char		
		$Label.text = display
		current_char += 1
	else:
		$next_char.stop()


# Update the label with the time left
func update_timer_label():
	$RoundTimerLabel.text = "Time Left: %d" % time_left

func _on_timer_timeout():
	if time_left > 0:
		time_left -= 1
		update_timer_label()
	else:
		$Timer.stop()


func set_level_timer():
	if current_level == 1:
		time_left = lvl_1_countdown_time
	elif current_level == 2:
		time_left = lvl_2_countdown_time
	elif current_level == 3:
		time_left = lvl_3_countdown_time
	elif current_level == 4:
		time_left = lvl_4_countdown_time
		
	$Timer.start(1.0) # Start the timer, trigger every 1 second
	update_timer_label()
