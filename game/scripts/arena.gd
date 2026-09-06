class_name OrionArena
extends Node2D

var player: OrionPlayer
var camera: Camera2D
var hud: OrionHUD
var audio: OrionAudio
var telemetry := OrionTelemetry.new()
var defeated_count := 0
var test_mode := false
var started := false
var shake_left := 0.0
var particles: Array[Dictionary] = []
var camera_base := Vector2(320, 180)
var platforms: Array[Rect2] = [Rect2(230, 226, 115, 10), Rect2(710, 212, 120, 10), Rect2(1190, 218, 115, 10)]
var blocks: Array[Rect2] = [Rect2(550, 256, 44, 44), Rect2(1120, 258, 38, 42)]

func _ready() -> void:
	OrionInput.setup()
	process_mode = Node.PROCESS_MODE_PAUSABLE
	build_world()
	player = OrionPlayer.new()
	player.position = Vector2(95, 278)
	add_child(player)
	player.hurt.connect(on_hurt)
	player.died.connect(on_death)
	player.struck.connect(on_struck)
	player.perfect_dodge.connect(on_perfect)
	camera = Camera2D.new()
	camera.position = camera_base
	camera.position_smoothing_enabled = false
	add_child(camera)
	audio = OrionAudio.new()
	add_child(audio)
	hud = OrionHUD.new()
	hud.arena = self
	add_child(hud)
	Input.joy_connection_changed.connect(on_controller_changed)
	if not test_mode:
		hud.show_menu("start")

func build_world() -> void:
	add_solid(Rect2(-30, 300, 1860, 100))
	add_solid(Rect2(-30, -200, 30, 600))
	add_solid(Rect2(1800, -200, 30, 600))
	for rect in platforms:
		add_solid(rect, true)
	for rect in blocks:
		add_solid(rect)

func add_solid(rect: Rect2, one_way: bool = false) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.position = rect.get_center()
	body.collision_layer = 8 if one_way else 1
	body.collision_mask = 0
	var collider := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	collider.shape = shape
	collider.one_way_collision = one_way
	body.add_child(collider)
	add_child(body)
	return body

func begin_run() -> void:
	started = true
	telemetry.begin("hunter" if player.hunter_oath else "none")
	spawn_enemy("guard", Vector2(428, 280))
	spawn_enemy("archer", Vector2(905, 280))
	spawn_enemy("guard", Vector2(1032, 280))
	spawn_enemy("guard", Vector2(1430, 280))
	spawn_enemy("archer", Vector2(1600, 280))

func spawn_enemy(kind: String, at: Vector2) -> OrionEnemy:
	var enemy := OrionEnemy.new()
	enemy.kind = kind
	enemy.player = player
	enemy.position = at
	enemy.defeated.connect(on_defeated)
	enemy.fire.connect(spawn_projectile)
	add_child(enemy)
	return enemy

func spawn_projectile(at: Vector2, direction: Vector2) -> void:
	var projectile := OrionProjectile.new()
	projectile.position = at
	projectile.direction = direction
	projectile.add_to_group("projectiles")
	add_child(projectile)

func reset_run() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.free()
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		projectile.free()
	var oath := player.hunter_oath
	player.free()
	player = OrionPlayer.new()
	player.hunter_oath = oath
	player.position = Vector2(95, 278)
	add_child(player)
	player.hurt.connect(on_hurt)
	player.died.connect(on_death)
	player.struck.connect(on_struck)
	player.perfect_dodge.connect(on_perfect)
	defeated_count = 0
	particles.clear()
	camera_base = Vector2(320, 180)
	camera.position = camera_base
	begin_run()

func _physics_process(delta: float) -> void:
	if started:
		telemetry.elapsed += delta
	var lookahead := player.facing * 30.0
	var target := Vector2(clampf(player.position.x + lookahead, 320, 1480), 180)
	camera_base = camera_base.lerp(target, minf(1, delta * 8.0))
	shake_left = maxf(0.0, shake_left - delta)
	camera.position = camera_base
	if shake_left > 0.0 and hud.screen_shake:
		camera.position += Vector2(sin(shake_left * 300) * 2, cos(shake_left * 220))
	for particle in particles:
		particle.life -= delta
		particle.at += particle.velocity * delta
		particle.velocity.y += 180.0 * delta
	particles = particles.filter(func(p: Dictionary) -> bool: return p.life > 0.0)
	if started and defeated_count >= 5 and player.position.x > 1720 and player.health > 0:
		started = false
		telemetry.record("run_completed", {"health": player.health})
		hud.show_menu("clear")
	queue_redraw()

func on_struck(at: Vector2, heavy: bool) -> void:
	burst(at, Color("ffd29a"), 9 if heavy else 5)
	shake_left = 0.09 if heavy else 0.045
	audio.cue("hit")

func on_hurt(source: String, amount: int) -> void:
	telemetry.record("damage_taken", {"source": source, "amount": amount, "health": player.health})
	burst(player.position, Color("ee8090"), 9)
	shake_left = 0.1
	audio.cue("hurt")

func on_perfect() -> void:
	telemetry.record("perfect_dodge")
	burst(player.position, Color("8dd6ec"), 10)
	audio.cue("perfect")

func on_defeated(at: Vector2) -> void:
	defeated_count += 1
	telemetry.record("enemy_defeated", {"count": defeated_count})
	burst(at, Color("cf8aaa"), 12)

func on_death(source: String) -> void:
	started = false
	telemetry.record("player_died", {"source": source, "defeated": defeated_count})
	hud.show_menu("dead", source)

func burst(at: Vector2, tint: Color, count: int) -> void:
	for i in count:
		var angle := TAU * float(i) / count
		particles.append({"at": at, "velocity": Vector2.from_angle(angle) * (48 + i * 5), "life": 0.35, "color": tint})

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT and is_instance_valid(hud) and hud.mode == "" and not test_mode:
		hud.show_menu("pause")

func on_controller_changed(_device: int, connected: bool) -> void:
	if not connected and is_instance_valid(hud) and hud.mode == "":
		hud.show_menu("pause")

func _draw() -> void:
	draw_rect(Rect2(-40, -100, 1880, 500), Color("0c1120"))
	# Architectural silhouettes and original geometric placeholders; no external assets.
	for x in range(40, 1800, 150):
		draw_rect(Rect2(x, 58, 64, 242), Color("131b2e"))
		draw_arc(Vector2(x + 32, 100), 32, PI, TAU, 16, Color("253047"), 4)
		draw_rect(Rect2(x + 5, 101, 54, 112), Color("0a1020"))
		for offset in [18, 34, 50]:
			draw_line(Vector2(x + offset, 86), Vector2(x + offset, 213), Color("202940"), 2)
		draw_rect(Rect2(x - 8, 52, 8, 248), Color("252c3d"))
		draw_rect(Rect2(x - 12, 52, 16, 9), Color("333a4a"))
	for x in [150, 660, 1230, 1680]:
		draw_circle(Vector2(x, 247), 33, Color(0.9, 0.4, 0.18, 0.04))
		draw_circle(Vector2(x, 247), 19, Color(0.9, 0.4, 0.18, 0.07))
		draw_rect(Rect2(x - 8, 249, 16, 6), Color("8d6c5a"))
		draw_line(Vector2(x - 5, 255), Vector2(x - 7, 297), Color("65565a"), 3)
		draw_line(Vector2(x + 5, 255), Vector2(x + 7, 297), Color("65565a"), 3)
		draw_colored_polygon(PackedVector2Array([Vector2(x - 5, 248), Vector2(x - 2, 232), Vector2(x + 2, 241), Vector2(x + 5, 236), Vector2(x + 6, 248)]), Color("ed9b5c"))
	var font := ThemeDB.fallback_font
	for i in 3:
		var x := float(i * 600 + 45)
		draw_string(font, Vector2(x, 94), ["I / OCAK", "II / KÜL GEÇİDİ", "III / DOĞU MÜHRÜ"][i], HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("8d8790"))
	draw_string(font, Vector2(200, 190), "ÇİFT ZIPLAMA", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color("827b89"))
	draw_rect(Rect2(-30, 300, 1860, 100), Color("202638"))
	draw_line(Vector2(0, 300), Vector2(1800, 300), Color("7e6d6e"), 2)
	for x in range(0, 1800, 32):
		draw_line(Vector2(x, 304), Vector2(x, 326), Color("30384c"), 1)
		draw_line(Vector2(x + 16, 328), Vector2(x + 16, 360), Color("171e30"), 1)
	draw_line(Vector2(0, 327), Vector2(1800, 327), Color("171e30"), 2)
	for rect in platforms:
		draw_rect(rect, Color("535160"))
		draw_line(rect.position, rect.position + Vector2(rect.size.x, 0), Color("b08c73"), 2)
		for offset in [14, int(rect.size.x) - 14]:
			draw_line(rect.position + Vector2(offset, 10), rect.position + Vector2(offset + 12, 27), Color("3d3544"), 4)
	for rect in blocks:
		draw_rect(rect, Color("454051"))
		draw_rect(rect.grow(-5), Color("2b2b3c"))
		draw_line(rect.position, rect.position + Vector2(rect.size.x, 0), Color("89747a"), 2)
	var portal_tint := Color("ffc894") if defeated_count >= 5 else Color("655373")
	draw_arc(Vector2(1747, 264), 28, PI, TAU, 20, portal_tint, 3)
	draw_line(Vector2(1719, 264), Vector2(1719, 298), portal_tint, 3)
	draw_line(Vector2(1775, 264), Vector2(1775, 298), portal_tint, 3)
	draw_string(font, Vector2(1688, 221), "ÇIKIŞ" if defeated_count >= 5 else "5 MUHAFIZ", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, portal_tint)
	for particle in particles:
		draw_circle(particle.at, 2, particle.color)
