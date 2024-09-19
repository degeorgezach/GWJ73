extends Node3D

@export var scenes: Array = [ 
	"res://scenes/plateau_1.tscn",
	"res://scenes/plateau_2.tscn",
	"res://scenes/plateau_3.tscn",
	"res://scenes/plateau_4.tscn",
	"res://scenes/plateau_5.tscn",
	"res://scenes/mountain_1.tscn",
	"res://scenes/mountain_2.tscn",
	"res://scenes/mountain_3.tscn",
	"res://scenes/mountain_4.tscn",
	"res://scenes/mountain_5.tscn",
	"res://scenes/mountain_6.tscn",
	"res://scenes/mountain_7.tscn",
	"res://scenes/mountain_8.tscn",
	"res://scenes/mountain_9.tscn",
	"res://scenes/mountain_10.tscn"
	]

@export var ground_size: Vector2 = Vector2(512, 512) # Size of your ground area
@export var density: int = 75 # Number of scenes to place

func _ready():
	randomize()  # Initialize random number generator
	place_scenes()
	
func place_scenes():
	for test in range(density):
		var scene_path = scenes[randi() % scenes.size()]
		var scene = load(scene_path).instantiate()
		var x = randf_range(0, ground_size.x)
		var z = randf_range(0, ground_size.y)
		scene.position = Vector3(x, 0, z)
		add_child(scene)
