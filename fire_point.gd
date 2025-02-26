extends Node2D
@onready var main_node = get_tree().get_root().get_node("Main")
@export var direction = -1

func fire():
	return main_node.spawn_effect("bullet", global_position, direction)
