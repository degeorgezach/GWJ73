extends Node2D

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
	elif song == 2:
		musicStream = preload("res://assets/music/HorrorGameMusic/Track2_Nightmare Descent.wav")
	elif song == 3:
		musicStream = preload("res://assets/music/HorrorGameMusic/Track3_Purgatory.wav")
	elif song == 4:
		musicStream = preload("res://assets/music/HorrorGameMusic/Track4_Creeping Dread.wav")
	elif song == 5:
		musicStream = preload("res://assets/music/HorrorGameMusic/Track5_Sanctuary in the Shadows.wav")
	elif song == 6:
		musicStream = preload("res://assets/music/HorrorGameMusic/Track6(Bonus)_Suspenseful Solitude.wav")
	$AudioStreamPlayer2D.stream = musicStream
	$AudioStreamPlayer2D.autoplay = true
	$AudioStreamPlayer2D.play()

func set_volume(volume):
	$AudioStreamPlayer2D.volume_db = volume
