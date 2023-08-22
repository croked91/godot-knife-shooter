extends HBoxContainer

const PASSED_COLOR := "#f0ad1f"
const DEFAULT_COLOR := "#ffffff"

func _ready():
	Events.stage_changed.connect(update_stage)

func update_stage(_stage:Stage):
	var current_stage = Globals.get_current_stage() % Globals.get_bossfigth_period()
	
	for i in range(Globals.get_bossfigth_period()):
		var texture_rect: TextureRect = get_child(i)
		texture_rect.modulate = Color(PASSED_COLOR) \
		if current_stage == 0 or i < current_stage \
		else Color(DEFAULT_COLOR)
