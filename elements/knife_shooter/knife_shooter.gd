extends Node2D

var knife_scene := preload("res://elements/knife/knife.tscn")
var is_enabled := true

@onready var knife = $Knife
@onready var timer = $Timer

func create_new_knife():
	if (is_enabled):
		knife = knife_scene.instantiate()
		add_child(knife)

func _input(event: InputEvent):
	if Globals.knives > 0 and \
	is_enabled and \
	event is InputEventScreenTouch and \
	event.is_pressed() and \
	 timer.time_left <= 0:
		knife.throw()
		Globals.remove_knife()
		timer.start( )

func _on_timer_timeout():
	create_new_knife()

func disable_knife_shooter():
	is_enabled = false

func enable_knife_shooter():
	is_enabled = true	
