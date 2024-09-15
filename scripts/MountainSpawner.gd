extends Node3D

# Path to your grass scenes (change to the correct paths)
@export var grass_scenes: Array = [ 
	"res://scenes/tree_1.tscn",
	"res://scenes/stone_small_1.tscn"
	]
@export var ground_size: Vector2 = Vector2(1500, 1500) # Size of your ground area
@export var density: int = 1500 # Number of grass tufts to place

func _ready():
	randomize()  # Initialize random number generator
	place_mountains()
	
func place_mountains():
	for test in range(density):
		var scene_path = grass_scenes[randi() % grass_scenes.size()]
		var grass_scene = load(scene_path).instantiate()
		var x = randf_range(0, ground_size.x)
		var z = randf_range(0, ground_size.y)
		grass_scene.position = Vector3(x, 0, z)
		add_child(grass_scene)
