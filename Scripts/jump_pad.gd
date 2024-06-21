extends Area2D

@onready var spring = $AnimatedSprite2D

@export var jump_force = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Checking if the class of the body that enters the collision shape is the Player, then calling the jump method on it.
func _on_body_entered(body):
	if body is Player:
		body.jump(jump_force)
		spring.play("jump")
