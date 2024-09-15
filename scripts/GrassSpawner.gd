extends Node3D

# Path to your grass scenes (change to the correct paths)
@export var grass_scenes: Array = [ "res://scenes/grass_1.tscn", "res://scenes/grass_2.tscn", "res://scenes/grass_3.tscn", "res://scenes/grass_4.tscn", "res://scenes/grass_5.tscn", "res://scenes/grass_6.tscn", "res://scenes/grass_7.tscn"]
@export var ground_size: Vector2 = Vector2(500, 500) # Size of your ground area
@export var density: int = 10000 # Number of grass tufts to place

func _ready():
	randomize()  # Initialize random number generator
	#place_grass() THIS WORKS BUT IT'S SLOW and kinda looks bad for this game. 
	
func place_grass():
	for test in range(density):
		var scene_path = grass_scenes[randi() % grass_scenes.size()]
		var grass_scene = load(scene_path).instantiate()
		var x = randf_range(0, ground_size.x)
		var z = randf_range(0, ground_size.y)
		grass_scene.position = Vector3(x, 0, z)
		add_child(grass_scene)
