extends AudioStreamPlayer

# All of the audio files.
var audio_unit_move = preload("res://SFX/546119__el_boss__piece-placement.mp3")
var audio_unit_captured = preload("res://SFX/546120__el_boss__piece-capture.mp3")
var audio_start_match = preload("res://SFX/546121__el_boss__board-start.mp3")

var audio_node: AudioStreamPlayer = self
func _ready():
	audio_node.finished.connect(destroy_self)
	audio_node.stop()

func play_sound(sound_name):

	match sound_name:
		"unit_move":
			audio_node.stream = audio_unit_move
		"unit_captured":
			audio_node.stream = audio_unit_captured
		"start_match":
			audio_node.stream = audio_start_match
		_:
			print ("UNKNOWN STREAM")
			return
	if audio_node.stream:
		audio_node.play()
	else:
		print("{0} has no valid stream".format([sound_name]))


func destroy_self():
	audio_node.stop()
