class_name OrionPlayer
extends CharacterBody2D

signal struck(at: Vector2, heavy: bool)
signal hurt(source: String, amount: int)
signal died(source: String)
signal perfect_dodge

const SPEED := 240.0
const GRAVITY := 1200.0
const JUMP_SPEED := -480.0
const AIR_JUMP_SPEED := -416.0
const COYOTE := 0.100
const BUFFER := 0.120
const DODGE_DURATION := 0.250
const DODGE_IFRAMES := 0.150

var health := 100
var heal_charges := 2
var facing := 1.0
var hunter_oath := true
var coyote_left := 0.0
var jump_buffer := 0.0
var attack_buffer := 0.0
var air_jump_used := false
var air_dodge_used := false
var dodge_left := 0.0
var dodge_cooldown := 0.0
var dodge_direction := 1.0
var dodge_triggered := false
var empower_left := 0.0
var invulnerable_left := 0.0
var drop_left := 0.0
var healing_left := 0.0
var combo_index := 0
var combo_grace := 0.0
var attack: OrionAttack
var sword: Dictionary
var hurt_flash := 0.0
var last_ground := Vector2(100, 275)
var controls_enabled := true

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1 | 8
	var shape := CollisionShape2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = 9.0
	capsule.height = 34.0
	shape.shape = capsule
	add_child(shape)
	sword = JSON.parse_string(FileAccess.get_file_as_string("res://game/data/sword.json"))
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if not controls_enabled:
		return
	step(delta, {
		"axis": Input.get_axis("move_left", "move_right"),
		"jump": Input.is_action_just_pressed("jump"),
		"down": Input.is_action_pressed("move_down"),
		"dodge": Input.is_action_just_pressed("dodge"),
		"light": Input.is_action_just_pressed("light"),
		"heavy": Input.is_action_just_pressed("heavy"),
		"heal": Input.is_action_just_pressed("heal")
	})

func step(delta: float, controls: Dictionary) -> void:
	if health <= 0:
		return
	var grounded := is_on_floor()
	coyote_left = COYOTE if grounded else maxf(0.0, coyote_left - delta)
	if grounded:
		air_jump_used = false
		air_dodge_used = false
		last_ground = position
	jump_buffer = maxf(0.0, jump_buffer - delta)
	attack_buffer = maxf(0.0, attack_buffer - delta)
	dodge_left = maxf(0.0, dodge_left - delta)
	dodge_cooldown = maxf(0.0, dodge_cooldown - delta)
	empower_left = maxf(0.0, empower_left - delta)
	invulnerable_left = maxf(0.0, invulnerable_left - delta)
	hurt_flash = maxf(0.0, hurt_flash - delta)
	combo_grace = maxf(0.0, combo_grace - delta)
	drop_left = maxf(0.0, drop_left - delta)
	set_collision_mask_value(4, drop_left <= 0.0)
	if attack != null:
		attack.advance(delta)
		if attack.done():
			attack = null
			combo_grace = 0.20
	if controls.get("jump", false):
		jump_buffer = BUFFER
	if controls.get("light", false):
		attack_buffer = BUFFER
	if controls.get("heal", false):
		begin_heal()
	if healing_left > 0.0:
		healing_left = maxf(0.0, healing_left - delta)
		if healing_left <= 0.0:
			health = mini(100, health + 40)
			heal_charges -= 1
	if controls.get("dodge", false):
		begin_dodge()
	if dodge_left > 0.0:
		velocity = Vector2(dodge_direction * 384.0, 0.0)
	else:
		var axis_value: float = controls.get("axis", 0.0)
		var movement_locked := healing_left > 0.0
		if absf(axis_value) > 0.1 and attack == null and not movement_locked:
			facing = signf(axis_value)
		var speed_factor := 0.25 if attack != null else 1.0
		velocity.x = 0.0 if movement_locked else axis_value * SPEED * speed_factor
		velocity.y += GRAVITY * delta
		if jump_buffer > 0.0 and not movement_locked and attack == null:
			if controls.get("down", false) and grounded and on_one_way_platform():
				drop_left = 0.20
				set_collision_mask_value(4, false)
				position.y += 3.0
				jump_buffer = 0.0
				coyote_left = 0.0
			elif coyote_left > 0.0:
				velocity.y = JUMP_SPEED
				coyote_left = 0.0
				jump_buffer = 0.0
			elif not air_jump_used:
				velocity.y = AIR_JUMP_SPEED
				air_jump_used = true
				jump_buffer = 0.0
		if attack == null and healing_left <= 0.0:
			if controls.get("heavy", false):
				begin_attack(true)
			elif attack_buffer > 0.0:
				begin_attack(false)
	move_and_slide()
	resolve_attack()
	if position.y > 440.0:
		position = last_ground - Vector2(0, 8)
		velocity = Vector2.ZERO
		receive_hit(10, "çukur", true)
	queue_redraw()

func on_one_way_platform() -> bool:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as CollisionObject2D
		if body != null and body.get_collision_layer_value(4) and collision.get_normal().y < -0.5:
			return true
	return false

func begin_attack(is_heavy: bool) -> void:
	if attack != null or dodge_left > 0.0 or healing_left > 0.0 or health <= 0:
		return
	if is_heavy:
		attack = OrionAttack.new(sword.heavy, true)
		combo_index = 0
	else:
		if combo_grace <= 0.0:
			combo_index = 0
		attack = OrionAttack.new(sword.light[combo_index])
		combo_index = (combo_index + 1) % 3
	attack_buffer = 0.0

func begin_dodge() -> bool:
	if health <= 0 or dodge_cooldown > 0.0 or dodge_left > 0.0:
		return false
	if not is_on_floor() and air_dodge_used:
		return false
	if attack != null and not attack.can_cancel():
		return false
	attack = null
	healing_left = 0.0
	combo_index = 0
	combo_grace = 0.0
	dodge_left = DODGE_DURATION
	dodge_cooldown = 0.8 if hunter_oath else 0.65
	dodge_direction = facing
	dodge_triggered = false
	if not is_on_floor():
		air_dodge_used = true
	return true

func begin_heal() -> bool:
	if health <= 0 or health >= 100 or heal_charges <= 0 or healing_left > 0.0:
		return false
	if attack != null or dodge_left > 0.0 or not is_on_floor():
		return false
	healing_left = 0.7
	return true

func receive_hit(amount: int, source: String, environmental: bool = false) -> bool:
	if health <= 0:
		return false
	if not environmental and dodge_left > DODGE_DURATION - DODGE_IFRAMES:
		if hunter_oath and not dodge_triggered and dodge_left > DODGE_DURATION - 0.100:
			dodge_triggered = true
			empower_left = 2.0
			perfect_dodge.emit()
		return false
	if not environmental and invulnerable_left > 0.0:
		return false
	health = maxi(0, health - amount)
	invulnerable_left = 0.7
	hurt_flash = 0.15
	healing_left = 0.0
	attack = null
	hurt.emit(source, amount)
	if health == 0:
		died.emit(source)
	return true

func hurt_rect() -> Rect2:
	return Rect2(global_position - Vector2(9, 17), Vector2(18, 34))

func attack_rect() -> Rect2:
	if attack == null:
		return Rect2()
	var reach := float(attack.data.reach)
	return Rect2(global_position + Vector2(3 if facing > 0 else -reach - 3, -20), Vector2(reach, 38))

func resolve_attack() -> void:
	if attack == null or not attack.active():
		return
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.health <= 0 or not attack_rect().intersects(enemy.hurt_rect()):
			continue
		if attack.claim_hit(enemy.get_instance_id()):
			# Consume on the first landed target, not a missed swing or every victim.
			var damage := attack.damage()
			if empower_left > 0.0:
				damage = roundi(damage * 1.5)
				empower_left = 0.0
			enemy.receive_hit(damage, facing, attack.heavy)
			struck.emit(enemy.global_position, attack.heavy)

func _draw() -> void:
	var tint := Color("e8ddd0")
	if hurt_flash > 0:
		tint = Color.WHITE
	elif dodge_left > 0:
		tint = Color("91cde0")
	draw_circle(Vector2(0, 16), 11, Color(0, 0, 0, 0.3))
	draw_colored_polygon(PackedVector2Array([Vector2(-10, -9), Vector2(7, -9), Vector2(12, 15), Vector2(-14, 15)]), Color("a44838"))
	draw_rect(Rect2(-7, -11, 14, 20), tint)
	draw_rect(Rect2(-7, -24, 14, 13), Color("626d82"))
	draw_rect(Rect2(1 if facing > 0 else -7, -19, 6, 3), Color("ffb661"))
	draw_line(Vector2(-4, 8), Vector2(-5, 17), tint, 4)
	draw_line(Vector2(4, 8), Vector2(5, 17), tint, 4)
	if attack != null:
		var reach := float(attack.data.reach)
		var sword_end := Vector2(facing * (reach if attack.active() else 16.0), -5 if attack.active() else -30)
		draw_line(Vector2(facing * 8, -2), sword_end, Color("ffe0ad"), 4)
		if attack.active():
			draw_arc(Vector2.ZERO, reach, -0.7 if facing > 0 else PI - 0.7, 0.7 if facing > 0 else PI + 0.7, 12, Color("ffc47e"), 3)
	else:
		draw_line(Vector2(facing * 9, -1), Vector2(facing * 22, -21), Color("acb5c5"), 3)
	if empower_left > 0.0:
		draw_arc(Vector2(0, -5), 23, 0, TAU, 20, Color("71d1ea"), 1.5)
	if healing_left > 0.0:
		draw_arc(Vector2(0, -5), 22, -PI / 2, -PI / 2 + TAU * (1.0 - healing_left / 0.7), 20, Color("b4e7ac"), 2)
