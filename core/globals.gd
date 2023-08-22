extends Node 

const KNIFE_TEXTURES := [
	preload("res://assets/knife1.png"),
	preload("res://assets/knife2.png"),
	preload("res://assets/knife3.png"),
	preload("res://assets/knife4.png"),
	preload("res://assets/knife5.png"),
	preload("res://assets/knife6.png"),
	preload("res://assets/knife7.png"),
	preload("res://assets/knife8.png"),
	preload("res://assets/knife9.png"),
]

const TARGETS := [
	preload("res://elements/targets/target/target.tscn"),
	preload("res://elements/targets/target_accelerate/target_accelerate.tscn")
]

const BOSS_TARGETS := [
	preload("res://elements/targets/target_boss_cheese/target_boss_cheese.tscn")
]

const UNLOCK_COST := 250 

const BOSS_FIGTH_PERIOD := 5

const location_to_scene = {
	Events.LOCATIONS.GAME: preload("res://scenes/game/game.tscn"),
	Events.LOCATIONS.START: preload("res://scenes/start_screen/start_screen.tscn"),
	Events.LOCATIONS.SHOP: preload("res://scenes/knife_shop/knife_shop.tscn" )
}

const SAVE_GAME_FILE := "user://savegame.save"
const SAVE_VARIABLES := ["apples", "active_knife_index", "unlocked_knives"]

const MAX_STAGE_APPLES := 3
const MIN_STAGE_APPLES := 1
const MAX_STAGE_KNIVES := 3
const MIN_STAGE_KNIVES := 1
const MIN_KNIVES := 5
const MAX_KNIVES := 8

var rng := RandomNumberGenerator.new()
var points := 0
var knives := 0
var current_stage := 1
var apples := 0

var active_knife_index := 0
var unlocked_knives := 0b000000001


func _ready():
	load_game() 
	rng.randomize()
	seed(rng.seed)
	Events.location_changed.connect(handle_location_changed)

func unlock_knives(knife_index: int):
	unlocked_knives |= (1 << knife_index)
	
func is_knife_unlocked(knife_index: int) -> bool:
	return unlocked_knives & (1 << knife_index) != 0

func change_active_knife(knife_index:int):
	active_knife_index = knife_index
	Events.active_knife_changed.emit(active_knife_index)

func save_game():
	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.WRITE)
	if save_game_file == null:
		printerr("save failed with error code {0}".format([FileAccess.get_open_error()]))
		return
	var game_data := {}
	for save_variable in SAVE_VARIABLES:
		game_data[save_variable] = get(save_variable)
	save_game_file.store_line(JSON.stringify(game_data))
	
func load_game():
	if not FileAccess.file_exists(SAVE_GAME_FILE):
		return
	var save_game_file = FileAccess.open(SAVE_GAME_FILE, FileAccess.READ)
	if save_game_file == null:
		printerr("save failed with error code {0}".format([FileAccess.get_open_error()]))
		return
	var json_object = JSON.new()
	var error = json_object.parse(save_game_file.get_line())
	if error != OK:
		return
	var game_data = json_object.get_data()
	for variable in game_data:
		set(variable, game_data[variable])
	
	
func add_apples(amount: int):
	apples += amount
	Events.apples_changed.emit(apples)
	
func spend_apples(amount: int):
	apples -= amount
	Events.apples_changed.emit(apples)
	
func change_stage(stage_i: int):
	current_stage = stage_i
	var stage: Stage
	if stage_i == 1:
		stage = Stage.new()
		add_items_to_target(stage)
	elif stage_i % 5 == 0:
		stage = Stage.new(BOSS_TARGETS.pick_random())
		add_items_to_target(stage)
	else:
		stage = get_random_stage()
	knives = rng.randi_range(MIN_KNIVES, MAX_KNIVES)
	Events.knives_changed.emit(knives)
	Events.stage_changed.emit(stage)

func handle_location_changed(location: Events.LOCATIONS):
	get_tree().change_scene_to_packed(location_to_scene.get(location))
	
func remove_knife():
	knives -= 1
	Events.knives_changed.emit(knives)

func add_points():
	points += 1
	Events.points_changed.emit(points)
	
func reset_points():
	points = 0	
	Events.points_changed.emit(points)

func get_random_stage() -> Stage:
	var stage := Stage.new(TARGETS.pick_random())
	add_items_to_target(stage)
	return stage
	
func add_items_to_target(stage: Stage):
	stage.set_stage_apples(rng.randi_range(MIN_STAGE_APPLES, MAX_STAGE_APPLES))
	stage.set_stage_knives(rng.randi_range(MIN_STAGE_KNIVES, MAX_STAGE_KNIVES))

func get_current_stage() -> int:
	return current_stage

func get_knives_count() -> int:
	return knives

func get_bossfigth_period():
	return BOSS_FIGTH_PERIOD
