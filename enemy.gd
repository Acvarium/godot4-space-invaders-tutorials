extends Area2D
const MIX_X_POS = 30.0
const MAX_X_POS = 770.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func make_step(step_direction : Vector2) -> float:
	position += step_direction
	var wall_distance = INF
	if step_direction.x < 0:
		#ліворуч
		wall_distance = position.x - MIX_X_POS
	else:
		#праворуч
		wall_distance = MAX_X_POS - position.x
	
	return wall_distance


func fire():
	$FirePoint.fire()


func hit():
	queue_free()
