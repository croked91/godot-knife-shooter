extends VBoxContainer



var knife_texture: Texture2D = preload('res://assets/knife_ico_2.png')

func _ready():
	Events.knives_changed.connect(update_knives_couter)

func update_knives_couter(knives: int): 
	var knives_diff := knives - get_child_count()
	if knives_diff > 0:
		add_knives(knives_diff)
	elif knives_diff < 0:
		remove_knives(-knives_diff)

func create_knife_icon() -> TextureRect:
	var texture_rect := TextureRect.new()
	texture_rect.texture = knife_texture
	return texture_rect

func add_knives(knives: int):
	for knife in range(knives):
		add_child(create_knife_icon())

func remove_knives(knives: int):
	for knife in range(knives): 
		get_child(knife).queue_free()
