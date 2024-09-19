extends Node3D

var musicStream

#func _ready():
	#$AudioStreamPlayer.volume_db = -5	

func play(sound):
	if sound == 0:
		musicStream = preload("res://assets/sfx/tree.wav")
	elif sound == 1:
		musicStream = preload("res://assets/sfx/stone.wav")	
	$AudioStreamPlayer3D.stream = musicStream
	$AudioStreamPlayer3D.play()
