extends Area2D

@onready var exit = $AnimatedSprite2D

func animate():
	exit.play("pressed")


