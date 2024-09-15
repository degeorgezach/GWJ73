extends Node2D

@onready var TimberCollectLabel = $TimberCollectLabel
@onready var StoneCollectLabel = $StoneCollectLabel

var wood_current = 0 
var wood_needed = 15
var stone_current = 0 
var stone_needed = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TimberLabel.text = "Timber: " + str(wood_current) + " / " + str(wood_needed)
	$StoneLabel.text = "Stone: " + str(stone_current) + " / " + str(stone_needed)
