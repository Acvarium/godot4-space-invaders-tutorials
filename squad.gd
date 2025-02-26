extends Node2D
var enemies = []
var direction = -1
var h_step = 15.0
var v_step = 20.0
var current_enemy_id = 0
var wall_dist = INF
var to_move_down = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	build_enemies_array()


func build_enemies_array():
	for enemy in $Enemies.get_children():
		var enemy_name = enemy.name
		enemies.append(weakref(enemy))


func _physics_process(delta: float) -> void:
	make_step()


func make_step():
	if enemies[current_enemy_id].get_ref():
		var move_direction = Vector2(0, 0)
		move_direction.x = direction * h_step
		if to_move_down:
			move_direction.y = v_step
		var current_dist = enemies[current_enemy_id].get_ref().make_step(move_direction)
		if wall_dist > current_dist:
			wall_dist = current_dist
	
	
	current_enemy_id += 1
	if current_enemy_id >= enemies.size():
		#кінець списку противників
		to_move_down = false
			
		if wall_dist < h_step:
			switch_direction()
		wall_dist = INF
		current_enemy_id = 0
		
		
func switch_direction():
	direction = -direction
	to_move_down = true
