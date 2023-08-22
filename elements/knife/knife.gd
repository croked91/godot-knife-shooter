extends CharacterBody2D

enum State { IDLE, FLY_TO_TARGET, FLY_AWAY }

@onready var sprite = $Sprite2D
var state = State.IDLE
var is_flying := false
var is_flying_away := false
var fly_away_direction := Vector2.DOWN


const speed := 5000.0
const fly_away_speed := 1000.0
const fly_away_rotation_speed := 10.0
var fly_away_deviation = PI / 4

func _ready():
	sprite.texture = Globals.KNIFE_TEXTURES[Globals.active_knife_index]

func change_state(new_state: State):
	state = new_state

func _physics_process(delta):
	match state:
		State.FLY_TO_TARGET:
			var collision = move_and_collide(Vector2.UP * speed * delta)
			if collision:
				handle_collision(collision)
		State.FLY_AWAY:
			global_position += fly_away_direction * fly_away_speed * delta
			rotation += fly_away_rotation_speed * delta

			
func throw_away(direction: Vector2):
	var direction_deviation = Globals.rng.randf_range(-fly_away_deviation, fly_away_deviation)
	fly_away_direction = direction.rotated(direction_deviation)
	change_state(State.FLY_AWAY)

func throw():
	change_state(State.FLY_TO_TARGET)

func handle_collision(colision: KinematicCollision2D):
	var collider := colision.get_collider()
	if collider is Target:
		add_knife_to_target(collider)
		change_state(State.IDLE )
		collider.take_damage()
		Globals.add_points()
	else:
		SfxPlayer.play_sfx(SfxPlayer.AUDIO_TRACKS.KnifeHit)
		throw_away(colision.get_normal())
		Events.game_over.emit()

func add_knife_to_target(target: Target):
	get_parent().remove_child(self)
	global_position = target.KNIFE_POSITION
	rotation = 0
	target.add_object_with_pivot(self, - target.rotation)
