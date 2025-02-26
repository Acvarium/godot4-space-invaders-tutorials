extends Node2D
var effects = {
	"bullet" : preload("res://effects/bullet.tscn")
}

func get_player_position():
	return $Player.global_position
	

func spawn_effect(effect_name : String, pos : Vector2, mode_id = 0):
	var effect_instance = null
	if effect_name in effects.keys():
		effect_instance = effects[effect_name].instantiate()
	if effect_instance:
		$Effects.add_child(effect_instance, true)
		effect_instance.global_position = pos
		if effect_instance.has_method("set_mode"):
			effect_instance.set_mode(mode_id)
	return effect_instance
