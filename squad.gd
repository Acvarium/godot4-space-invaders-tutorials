extends Node2D
var enemies = []
var direction = -1
var h_step = 15.0
var v_step = 20.0
var current_enemy_id = 0
var wall_dist = INF
var to_move_down = false
var enemy_prefab = preload("res://enemy.tscn")
var columns = 11
var rows = 5
var enemy_columns = []
const MIN_FIRE_TIME = 0.8
const MAX_FIRE_TIME = 2.6

@onready var main_node = get_tree().get_root().get_node("Main")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_enemies()
	build_enemies_array()

func generate_enemies():
	var start_pos = $EnemyBasePos.position
	var x_step = abs(start_pos.x - $EnemyXOffset.position.x)
	var y_step = abs(start_pos.y - $EnemyYOffset.position.y)
	var new_pos = start_pos
	
	for k in range(columns):
		enemy_columns.append([])
	
	for i in range(rows):
		new_pos.x = start_pos.x
		for j in range(columns):
			var new_enemy = spawn_enemy(new_pos)
			enemy_columns[j].append(weakref(new_enemy))
			new_pos.x += x_step
		new_pos.y -= y_step


func list_lowest_enemies():
	var lowest_enemies = []
	for c in enemy_columns:
		var current_lowest = get_lowest_from_column(c)
		if current_lowest:
			lowest_enemies.append(current_lowest)
	return lowest_enemies


func get_lowest_from_column(col : Array):
	for i in range(col.size()):
		if col[i] and col[i].get_ref():
			return col[i].get_ref()
	return null
	
	
func spawn_enemy(pos):
	var new_enemy = enemy_prefab.instantiate()
	$Enemies.add_child(new_enemy, true)
	new_enemy.position = pos
	return new_enemy


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


func enemy_fire():
	var list_of_lowest = list_lowest_enemies()
	if list_of_lowest.size() == 0:
		return
	var fire_enemy_id = get_closest_enemy_id(list_of_lowest)
	if randf() > 0.4:
		fire_enemy_id = randi_range(0, list_of_lowest.size() - 1)
	list_of_lowest[fire_enemy_id].fire()


func get_closest_enemy_id(enemy_list : Array) -> int:
	var closest_id = 0
	if enemy_list.size() == 1:
		return 0
	var current_x_dist = get_x_dist_to_player(enemy_list[0].global_position)
	for i in range(1, enemy_list.size()):
		var next_x_dist = get_x_dist_to_player(enemy_list[i].global_position)
		if next_x_dist < current_x_dist:
			current_x_dist = next_x_dist
			closest_id = i
	return closest_id


func get_x_dist_to_player(pos : Vector2) -> float:
	return abs(pos.x - main_node.get_player_position().x)


func _on_fire_timer_timeout() -> void:
	if $Enemies.get_child_count() == 0:
		return
	$FireTimer.wait_time = remap(randf(), 0, 1, MIN_FIRE_TIME, MAX_FIRE_TIME)
	$FireTimer.start()
	enemy_fire()
