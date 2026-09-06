class_name OrionProjectile
extends Node2D
var direction := Vector2.LEFT
var speed := 230.0
var life := 4.0

func _physics_process(delta: float) -> void:
	life -= delta
	if life <= 0.0:
		queue_free()
		return
	var destination := global_position + direction * speed * delta
	var query := PhysicsRayQueryParameters2D.create(global_position, destination, 1 | 2 | 8)
	query.hit_from_inside = true
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		if hit.collider is OrionPlayer:
			hit.collider.receive_hit(10, "okçu oku")
		queue_free()
		return
	global_position = destination
	queue_redraw()

func _draw() -> void:
	draw_line(-direction * 10, direction * 4, Color("f8a0c1"), 2)
	draw_circle(direction * 5, 2, Color("fff0ed"))
