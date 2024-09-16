extends Node2D

@onready var TimberCollectLabel = $TimberCollectLabel
@onready var StoneCollectLabel = $StoneCollectLabel
@onready var TowerUpgradeLabel = $TowerUpgradeLabel


var messages = [ "A mysterious and sentient tower has appeared from the shadows, looming ominously over the land. This enigmatic structure demands upgrades to unlock its true power. 

Brave adventurer, gather the necessary materials to enhance the tower before the time runs out. Fail to do so, and you will face the wrath of the tower’s dark fury.",

"You have gathered the required materials. The tower’s demand is clear: 
	
	You must return to the tower."
]


var wood_current = 0 
var wood_needed = 3
var stone_current = 0 
var stone_needed = 2

var typing_speed = .055
var read_time = 20

var current_message = 0
var display = ""
var current_char = 0
var typing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_message = 0
	start_dialogue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimberLabel.text = "Timber: " + str(wood_current) + " / " + str(wood_needed)
	$StoneLabel.text = "Stone: " + str(stone_current) + " / " + str(stone_needed)
	
	if Input.is_action_just_pressed("action"):
		if typing and $Label.text != messages[current_message]:
			$next_char.stop()
			$Label.text = messages[current_message]
		elif $Label.text == messages[current_message]:
			$Label.text = ""
			typing = false
			


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

