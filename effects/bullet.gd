extends Area2D

var direction = -1
var speed = 500.0
var hit_count = 0

func _physics_process(delta: float) -> void:
	position.y += speed * direction * delta


func set_mode(dir):
	direction = dir


func _on_area_entered(area: Area2D) -> void:
	if hit_count < 1:
		if area.is_in_group("enemies"):
			area.hit()
		
	hit_count += 1
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if direction < 0 and body.is_in_group("player"):
		return
	queue_free()
