extends Node2D

# This is where the bulk of the actual game code lives.
# Generally speaking, the scripts on all the nodes that are not the root node (a.k.a. the game level)
# should only be used to define methods with "func", setting export variables, and be self contained
# enough to where the scene the script is connected to has everything it needs to be ready to be used.
# This means a lot of export variables and a lot of emitting and connecting signals through code.
var player = null

@export var next_level: PackedScene = null
@export var is_final_level = false

# These "@onready" variables are used to create references to the different nodes we're using.
# The reason this is a good idea is you can make something long and cumbersome like "$UILayer/HUD"
# Into something short and sweet, like just "hud", and also makes it so that if the node structure
# in a scene changes, you don't need to update every line of code that node was referenced, you
# just update the one variable you set here.
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer
@onready var death_zone = $DeathZone
@onready var exit = $Exit
@onready var start_pos = $Start

var timer_node = null
var time_left = null
var win = false
@export var level_time = 5

# Called when the node enters the scene tree for the first time.
func _ready(): # The player node was added to a "group" named "player", which is basically
# just a tag. the method below searches the scene tree from top to bottom and grabs the
# first node with that tag. In this case, it's basically checking if the player exists in the scene
# in order to spawn them at the start position.
	player = get_tree().get_first_node_in_group("player")
	if player!=null:
		player.global_position = start_pos.get_spawn_pos()
	# This method is different in that it gets every node with the group tag and puts them in an array.
	# Then it connects the signal defined in all the nodes with that tag, which was named "touched_player"
	# and connects it to the _on_trap_touched_player method to trigger when emitted.
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.connect("touched_player", _on_trap_touched_player)
	
	# This is more signal connecting through code. Using the example below, it goes like
	# Node.signal_in_node.connect(_method_to_trigger_when_signal_is_emitted)
	# If you check the exit.tscn, the Area2D node comes with the body_entered signal. This will also
	# work with custom signals.
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_death_zone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "LevelTimer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()

func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left <= -1:
			get_tree().reload_current_scene()
			AudioPlayer.play_sfx("hurt")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_death_zone_body_entered(body):
	reset_player()
	AudioPlayer.play_sfx("hurt")


func _on_trap_touched_player():
	reset_player()
	AudioPlayer.play_sfx("hurt")

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start_pos.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || next_level != null:
			win = true
			exit.animate()
			body.active = false
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			get_tree().change_scene_to_packed(next_level)
