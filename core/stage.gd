extends RefCounted

class_name Stage

var knives := 0
var apples := 0
var target_scene_resource : PackedScene

func _init(_target_scene = null):
	target_scene_resource = _target_scene \
		if _target_scene != null \
		else load("res://elements/targets/target/target.tscn")

func set_stage_apples(stage_apples: int):
	apples = stage_apples

func set_stage_knives(stage_knives: int):
	knives = stage_knives
