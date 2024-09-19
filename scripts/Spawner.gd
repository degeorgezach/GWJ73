extends Node3D

@export var scenes: Array = [ 
	"res://scenes/tree_01.tscn",
	"res://scenes/tree_02.tscn",
	"res://scenes/tree_03.tscn",
	"res://scenes/stone_small_1.tscn",
	"res://scenes/stone_small_02.tscn",
	"res://scenes/stone_mid_01.tscn",
	"res://scenes/stone_mid_02.tscn"
	]

@export var ground_size: Vector2 = Vector2(750, 750) # Size of your ground area
@export var density: int = 2500 # Number of scenes to place

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
