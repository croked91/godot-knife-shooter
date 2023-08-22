extends AudioStreamPlayer

enum AUDIO_TRACKS { KnifeHit, TargetExplosion, WoodHit }

const AUDIO_TRACKS_DIC := {
	AUDIO_TRACKS.KnifeHit: preload("res://assets/audio/knife_hit.wav"),
	AUDIO_TRACKS.TargetExplosion: preload("res://assets/audio/target_explosion.wav"),
	AUDIO_TRACKS.WoodHit: preload("res://assets/audio/wood_hit.wav")
}

func play_sfx(sfx: AUDIO_TRACKS):
	stream = AUDIO_TRACKS_DIC.get(sfx)
	play()
