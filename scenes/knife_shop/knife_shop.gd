extends Control

@onready var grid_container := $MarginContainer/VBoxContainer/GridContainer
@onready var active_knife_texture := $MarginContainer/VBoxContainer/ActiveKnifeTexture

func _ready():
	Events.active_knife_changed.connect(update_active_knife)
	update_active_knife(Globals.active_knife_index)
	for i in range(Globals.KNIFE_TEXTURES.size()):
		var shop_item := grid_container.get_child(i)
		shop_item.initialize(i)

func update_active_knife(idx: int):
	active_knife_texture.texture = Globals.KNIFE_TEXTURES[idx]

func _on_unblock_button_pressed():
	var locked_knives := []
	for i in range(Globals.KNIFE_TEXTURES.size()):
		if not Globals.is_knife_unlocked(i):
			locked_knives.append(i)

	if locked_knives.is_empty():
		return
	
	var random_kife = locked_knives.pick_random()
	Globals.unlock_knives(random_kife)
	Globals.spend_apples(Globals.UNLOCK_COST)
	Globals.save_game()
	grid_container.get_child(random_kife).unlock()
