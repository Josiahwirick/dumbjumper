extends Control

func set_time_label(value):
	$TimeLabel.text = "TIME: " + str(value)


func _on_left_pressed():
	Input.action_press("move_left")


func _on_right_pressed():
	Input.action_press("move_right")


func _on_jump_pressed():
	Input.action_press("jump")


func _on_reset_pressed():
	Input.action_press("reset")
