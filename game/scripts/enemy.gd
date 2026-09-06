class_name OrionEnemy
extends CharacterBody2D

signal defeated(at: Vector2)
signal fire(at: Vector2, direction: Vector2)

enum State { APPROACH, WINDUP, ACTIVE, RECOVER, STAGGER, DEAD }
var kind := "guard"
var health := 60
var max_health := 60
var player: OrionPlayer
var state := State.APPROACH
var state_left := 0.0
var state_duration := 0.0
var facing := -1.0
var hit_claimed := false
var target_position := Vector2.ZERO
var flash_left := 0.0
var stagger := 0
var stagger_immunity := 0.0
var push := 0.0
var controls_enabled := true

func _ready() -> void:
	max_health = 40 if kind == "archer" else 60
	health = max_health
	collision_layer = 4
	collision_mask = 1 | 8
	var shape := CollisionShape2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = 9
	capsule.height = 32
	shape.shape = capsule
	add_child(shape)
	add_to_group("enemies")

func set_state(value: State, duration: float) -> void:
	state = value
	state_left = duration
	state_duration = duration

func visible_to_player() -> bool:
	var screen := get_global_transform_with_canvas().origin
	return Rect2(18, 32, 604, 290).has_point(screen)

func has_line_of_sight() -> bool:
	var query := PhysicsRayQueryParameters2D.create(global_position, player.global_position, 1 | 8)
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func _physics_process(delta: float) -> void:
	if not controls_enabled or state == State.DEAD:
		return
	flash_left = maxf(0.0, flash_left - delta)
	stagger_immunity = maxf(0.0, stagger_immunity - delta)
	state_left = maxf(0.0, state_left - delta)
	velocity.y += 1200.0 * delta
	velocity.x = 0.0
	if not is_instance_valid(player) or player.health <= 0:
		move_and_slide()
		return
	var distance := player.global_position - global_position
	match state:
		State.APPROACH:
			if absf(distance.x) > 1.0:
				facing = signf(distance.x)
			if visible_to_player() and absf(distance.y) < 50.0:
				if kind == "archer":
					if absf(distance.x) < 260.0 and has_line_of_sight():
						target_position = player.global_position
						set_state(State.WINDUP, 0.65)
				elif absf(distance.x) < 48.0:
					set_state(State.WINDUP, 0.45)
				elif absf(distance.x) < 260.0:
					velocity.x = facing * 66.0
		State.WINDUP:
			if state_left <= 0.0:
				hit_claimed = false
				if kind == "archer":
					fire.emit(global_position, (target_position - global_position).normalized())
					set_state(State.RECOVER, 1.1)
				else:
					set_state(State.ACTIVE, 0.12)
		State.ACTIVE:
			if not hit_claimed and attack_rect().intersects(player.hurt_rect()):
				hit_claimed = true
				player.receive_hit(12, "nöbetçi kılıcı")
			if state_left <= 0.0:
				set_state(State.RECOVER, 0.6)
		State.RECOVER, State.STAGGER:
			if state_left <= 0.0:
				set_state(State.APPROACH, 0.0)
	velocity.x += push
	push = move_toward(push, 0.0, 600.0 * delta)
	# Do not walk off a ledge while chasing the player.
	if is_on_floor() and absf(velocity.x) > 0.0:
		var foot := global_position + Vector2(signf(velocity.x) * 16, 10)
		var query := PhysicsRayQueryParameters2D.create(foot, foot + Vector2(0, 30), 1 | 8)
		if get_world_2d().direct_space_state.intersect_ray(query).is_empty():
			velocity.x = 0.0
	move_and_slide()
	if global_position.y > 440:
		receive_hit(health, 0, false)
	queue_redraw()

func attack_rect() -> Rect2:
	return Rect2(global_position + Vector2(0 if facing > 0 else -52, -17), Vector2(52, 34))

func hurt_rect() -> Rect2:
	return Rect2(global_position - Vector2(9, 16), Vector2(18, 32))

func receive_hit(amount: int, direction: float, heavy: bool) -> void:
	if health <= 0:
		return
	health = maxi(0, health - amount)
	flash_left = 0.12
	push = direction * (120.0 if heavy else 35.0)
	if health == 0:
		state = State.DEAD
		defeated.emit(global_position)
		queue_free()
		return
	if stagger_immunity <= 0.0:
		stagger += 60 if heavy else 25
		if stagger >= 100:
			stagger = 0
			stagger_immunity = 1.0
			set_state(State.STAGGER, 0.3)

func _draw() -> void:
	var base := Color("a1a9b8") if kind == "guard" else Color("9a7da8")
	if flash_left > 0:
		base = Color.WHITE
	draw_circle(Vector2(0, 16), 11, Color(0, 0, 0, 0.25))
	draw_colored_polygon(PackedVector2Array([Vector2(-8, -9), Vector2(8, -9), Vector2(13, 15), Vector2(-12, 15)]), Color("393143") if kind == "archer" else Color("424c60"))
	draw_rect(Rect2(-7, -12, 14, 23), base)
	draw_circle(Vector2(0, -20), 8, Color("c7b9bc"))
	draw_line(Vector2(-5, -20), Vector2(5, -20), Color("f4779e"), 2)
	if kind == "archer":
		draw_arc(Vector2(facing * 12, -6), 13, -PI / 2, PI / 2, 9, Color("bc87b4"), 2)
	else:
		draw_line(Vector2(facing * 10, -2), Vector2(facing * (45 if state == State.ACTIVE else 12), -30 if state == State.WINDUP else -7), Color("e0c6dc"), 3)
	if state == State.WINDUP:
		draw_circle(Vector2(0, -39), 6, Color("ff749b"))
		draw_line(Vector2(0, -43), Vector2(0, -38), Color("302133"), 2)
		draw_circle(Vector2(0, -35), 1, Color("302133"))
		draw_arc(Vector2(0, -5), 26, -PI / 2, -PI / 2 + TAU * (1.0 - state_left / state_duration), 20, Color("f5a1c2"), 1)
		if kind == "archer":
			draw_line(Vector2.ZERO, target_position - global_position, Color(1, 0.5, 0.7, 0.35), 1)
	if health < max_health:
		draw_rect(Rect2(-15, -31, 30, 3), Color("292538"))
		draw_rect(Rect2(-15, -31, 30.0 * health / max_health, 3), Color("f086a3"))
