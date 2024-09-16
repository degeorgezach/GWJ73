extends Node3D

var musicStream

# Called when the node enters the scene tree for the first time.
func _ready():
	musicStream = preload("res://assets/music/HorrorGameMusic/Track1_Eerie Silence.wav")
	$AudioStreamPlayer2D.stream = musicStream
	$AudioStreamPlayer2D.play()
	
func Pause():
	$AudioStreamPlayer2D.stop()
	
func Resume():
	$AudioStreamPlayer2D.play()

func Change(song):
	if song == 1:
		musicStream = preload("res://assets/music/HorrorGameMusic/Track1_Eerie Silence.wav")
	$AudioStreamPlayer2D.stream = musicStream
	$AudioStreamPlayer2D.autoplay = true
	$AudioStreamPlayer2D.play()

func set_volume(volume):
	$AudioStreamPlayer2D.volume_db = volume
