extends Node

# Create variables that connect to the sound effects
var hurt= preload("res://assets/audio/hurt.wav")
var jump = preload("res://assets/audio/jump.wav")
# Method can be called from any script via the "AudioPlayer.play_sfx()" method and passing the variable of the sound effect as a string
func play_sfx(sfx_name: String):
	var stream = null
	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "jump":
		stream = jump
	else:
		print("Invalid sfx name")
		return
	
	# This part of the method creates a node to play the sound effect, allowing
	# multiple sounds to exist simultaneously instead of repeating the call on
	# one node and cutting off the sound. After the sound finishes the node is removed.
	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.name = "SFX"
	
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()
