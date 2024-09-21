extends CanvasLayer

var load_states = ["Loading", "Loading .", "Loading . .", "Loading . . ."]
var current_state = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = load_states[current_state]
	$Timer.start()

func _on_timer_timeout():
	current_state = (current_state + 1) % load_states.size()
	$Label.text = load_states[current_state]
