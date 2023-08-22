extends Node2D

@onready var knife_shooter := $knife_shooter
@onready var target_position := $TargetPosition

var restart_overlay_scene := preload("res://elements/ui/restart_overlay.tscn")
var target

func _ready():
	Events.game_over.connect(end_game)
	Events.stage_changed.connect(change_stage)
	Globals.change_stage(1)

func change_stage(stage: Stage):
	Globals.save_game()
	place_target(stage)

func end_game():
	knife_shooter.disable_knife_shooter( )
	show_restart_overlay_scene()
	Globals.save_game()
	Globals.reset_points()

func show_restart_overlay_scene():
	add_child(restart_overlay_scene.instantiate( )) 
	Hud.update_hud_restart()
 
func place_target(stage: Stage): 
	if target:
		target.queue_free()
	target = stage.target_scene_resource.instantiate()
	add_child(target)
	target.add_default_items(stage.knives, stage.apples)
	target.global_position = target_position.global_position
