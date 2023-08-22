extends CanvasLayer


@onready var stage_label := $MarginContainer/Control/PanelContainer/VBoxContainer/Label

func _ready():
	stage_label.text = str(Globals.get_current_stage())

func _on_button_pressed():
	Events.location_changed.emit(Events.LOCATIONS.GAME)
