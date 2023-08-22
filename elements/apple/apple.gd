extends Node2D

const EXPLOSION_TIME := 1.0
var is_hinted := false

@onready var particles = [
	$AppleParticles2D,
	$AppleParticles2D2 
]

@onready var sprite = $Sprite2D  

func _on_area_2d_body_entered(_body):
	if not is_hinted:
		is_hinted = true
		Globals.add_apples(1)
		sprite.hide()
		var tween = create_tween()
		for particle in particles:
			particle.emitting  = true
			tween.parallel().tween_property(particle, "modulate", Color(), EXPLOSION_TIME)
			particle.rotation = -rotation
		tween.play() 
		await tween.finished
		queue_free()
