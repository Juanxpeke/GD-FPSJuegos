extends AudioStreamPlayer

# All of the audio files.
var audio_unit_move = preload("res://SFX/546119__el_boss__piece-placement.mp3")
var audio_unit_captured = preload("res://SFX/546120__el_boss__piece-capture.mp3")
var audio_start_match = preload("res://SFX/546121__el_boss__board-start.mp3")
var audio_ui_hover = preload("res://SFX/536108__eminyildirim__ui-click.wav")#CC4.0
var audio_ui_click = preload("res://SFX/506052__mellau__button-click-3.wav")#CC4.0
var audio_transaction = preload("res://SFX/75235__creek23__cha-ching.wav")#non-commercial3.0
var audio_coin = preload("res://SFX/140382__dwoboyle__coins-01.wav")#CC4.0

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
		"ui_hover":
			audio_node.stream = audio_ui_hover
			audio_node.seek(0.23)
		"cha_ching":
			audio_node.stream = audio_transaction
		"coins":
			audio_node.stream = audio_coin
		_:
			print ("UNKNOWN STREAM")
			queue_free()
			return
	if audio_node.stream:
		audio_node.play()
	else:
		print("{0} has no valid stream".format([sound_name]))
		queue_free()


func destroy_self():
	audio_node.stop()
	queue_free()
