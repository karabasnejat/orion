extends SceneTree
## Run: godot --headless --path . --fixed-fps 60 --script tests/run_tests.gd
var failures := 0
var checks := 0
var arena: OrionArena
const DT := 1.0 / 60.0

func _initialize() -> void:
	call_deferred("run")

func expect(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures += 1
		push_error("FAIL: " + message)
	else:
		print("PASS: " + message)

func fresh() -> void:
	paused = false
	if is_instance_valid(arena):
		arena.queue_free()
		await process_frame
	arena = OrionArena.new()
	arena.test_mode = true
	root.add_child(arena)
	arena.player.controls_enabled = false
	arena.audio.enabled = false
	await physics_frame

func steps(count: int, controls: Dictionary = {}) -> void:
	for i in count:
		await physics_frame
		arena.player.step(DT, controls)

func run() -> void:
	test_attack()
	await test_movement()
	await test_dodge()
	await test_combat()
	await test_healing()
	await test_projectiles()
	await test_loop()
	print("ORION TEST RESULT: %d checks, %d failures" % [checks, failures])
	paused = false
	if is_instance_valid(arena):
		arena.queue_free()
	await process_frame
	quit(1 if failures > 0 else 0)

func test_attack() -> void:
	var sword: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://game/data/sword.json"))
	var strike := OrionAttack.new(sword.light[0])
	expect(not strike.claim_hit(1), "Windup cannot deal damage")
	strike.advance(0.1)
	expect(strike.claim_hit(1), "Active frame hits target")
	expect(not strike.claim_hit(1), "COM-01: same attack cannot hit target twice")
	expect(strike.claim_hit(2), "Cleave can hit a different target once")
	expect(strike.damage() == 20, "First sword strike uses configured damage")
	strike.elapsed = 0.25
	expect(not strike.can_cancel(), "Light recovery is committed before cancel window")
	strike.elapsed = 0.28
	expect(strike.can_cancel(), "Light attack cancels in final 100 ms")
	strike.elapsed = 1.0
	expect(strike.done() and not strike.claim_hit(3), "Completed attacks cannot hit")
	var heavy := OrionAttack.new(sword.heavy, true)
	expect(heavy.can_cancel(), "Heavy can cancel during windup")
	heavy.elapsed = 0.31
	expect(not heavy.can_cancel(), "Heavy active/recovery cannot cancel")

func test_movement() -> void:
	await fresh()
	await steps(15)
	var p := arena.player
	expect(p.is_on_floor(), "Character settles onto world floor")
	var origin := p.position.x
	await steps(60, {"axis": 1.0})
	expect(absf(p.position.x - origin - 240.0) < 2.0, "MOV: 240 px/s movement independent of render")
	await steps(1, {"jump": true})
	expect(p.velocity.y < -450 and not p.air_jump_used, "Ground jump keeps air jump available")
	await steps(5)
	await steps(1, {"jump": true})
	expect(p.air_jump_used and p.velocity.y < -400, "Second jump consumes air jump")
	await steps(1, {"jump": true})
	expect(p.velocity.y > -410, "Third jump cannot reset vertical velocity")
	await fresh()
	p = arena.player
	p.position = Vector2(100, 100)
	p.coyote_left = 0.08
	await steps(1, {"jump": true})
	expect(not p.air_jump_used and p.velocity.y == -480.0, "MOV-01: coyote jump uses ground jump")
	await fresh()
	p = arena.player
	p.position = Vector2(100, 100)
	p.coyote_left = 0.001
	await steps(1, {"jump": true})
	expect(p.air_jump_used, "Expired coyote window uses air jump")
	await fresh()
	p = arena.player
	p.position = Vector2(100, 278)
	p.air_jump_used = true
	p.velocity.y = 150
	await steps(1, {"jump": true})
	await steps(4)
	expect(p.velocity.y < -400, "Buffered jump fires after landing")
	await fresh()
	p = arena.player
	p.position = Vector2(275, 180)
	await steps(25)
	expect(p.is_on_floor() and p.on_one_way_platform(), "One-way platform supports landing")
	await steps(1, {"jump": true, "down": true})
	await steps(10)
	expect(p.position.y > 226, "Down+jump passes through one-way platform")
	await steps(30)
	expect(p.is_on_floor() and p.position.y < 300, "Dropping cannot pass through solid floor")

func test_dodge() -> void:
	await fresh()
	await steps(15)
	var p := arena.player
	var origin := p.position.x
	await steps(1, {"dodge": true})
	expect(p.dodge_cooldown == 0.8, "Hunter oath extends dodge cooldown to 800 ms")
	expect(not p.receive_hit(12, "test"), "COM-02: early dodge avoids attack")
	expect(p.empower_left == 2.0, "Early overlap grants Hunter empowerment")
	p.empower_left = 1.5
	p.receive_hit(12, "test")
	expect(p.empower_left == 1.5, "OAT-02: multiple overlaps do not refresh empowerment")
	await steps(14)
	expect(absf(p.position.x - origin - 96.0) < 2.0, "Dodge covers 96 px in 250 ms")
	p.dodge_left = 0.05
	expect(p.receive_hit(12, "test") and p.health == 88, "Late dodge can be punished")
	expect(not p.begin_dodge(), "Cooldown blocks repeated dodge")
	p.empower_left = 0.01
	await steps(1)
	expect(p.empower_left == 0.0, "Empowerment expires on simulation clock")
	await fresh()
	await steps(15)
	p = arena.player
	p.position.x = 1780
	p.hunter_oath = false
	await steps(1, {"dodge": true})
	expect(p.dodge_cooldown == 0.65, "No oath retains base 650 ms cooldown")
	await steps(14)
	expect(p.position.x <= 1791.5, "Dodge cannot pass world wall")
	await fresh()
	p = arena.player
	p.position.y = 120
	expect(p.begin_dodge(), "First air dodge allowed")
	p.dodge_left = 0
	p.dodge_cooldown = 0
	expect(not p.begin_dodge(), "Second air dodge blocked before landing")
	p.dodge_left = 0.25
	expect(p.receive_hit(10, "pit", true) and p.empower_left == 0.0, "Environment ignores dodge and never triggers oath")

func test_combat() -> void:
	await fresh()
	await steps(15)
	var p := arena.player
	p.facing = 1
	var e := arena.spawn_enemy("guard", p.position + Vector2(35, 0))
	e.controls_enabled = false
	p.begin_attack(false)
	p.attack.elapsed = 0.11
	p.resolve_attack()
	p.resolve_attack()
	expect(e.health == 40, "Real melee overlap applies 20 only once")
	p.attack = null
	p.combo_grace = 0.2
	p.begin_attack(false)
	expect(p.attack.data.damage == 22, "Second chained strike uses 22 damage")
	p.attack = null
	p.combo_grace = 0.2
	p.begin_attack(false)
	expect(p.attack.data.damage == 30, "Third chained strike uses 30 damage")
	p.attack.elapsed = 0.16
	p.empower_left = 2.0
	p.resolve_attack()
	expect(e.health == 0 and p.empower_left == 0.0, "Empowered 30 damage becomes 45 and consumes buff")
	p.attack = null
	p.begin_attack(true)
	expect(p.attack.damage() == 45, "Heavy sword damage is 45")
	p.attack.elapsed = 0.31
	expect(not p.begin_dodge(), "Active heavy attack cannot be dodge-cancelled")
	p.attack.elapsed = 0.1
	expect(p.begin_dodge(), "Heavy windup can be dodge-cancelled")
	await fresh()
	await steps(15)
	p = arena.player
	e = arena.spawn_enemy("guard", p.position + Vector2(35, 0))
	await steps(3)
	expect(e.state == OrionEnemy.State.WINDUP, "Guard visibly prepares before striking")
	await steps(10)
	expect(p.health == 100, "Guard cannot damage during windup")
	await steps(30)
	expect(p.health == 88, "Guard attack hits once after telegraph")

func test_healing() -> void:
	await fresh()
	await steps(15)
	var p := arena.player
	expect(not p.begin_heal(), "Full health cannot spend a heal")
	p.health = 40
	expect(p.begin_heal(), "Injured grounded player can heal")
	await steps(20)
	expect(p.health == 40 and p.heal_charges == 2, "Heal does not apply before 700 ms")
	p.receive_hit(12, "interrupt")
	expect(p.healing_left == 0 and p.heal_charges == 2, "Damage interrupts without consuming charge")
	p.invulnerable_left = 0
	p.begin_heal()
	await steps(43)
	expect(p.health == 68 and p.heal_charges == 1, "Completed heal restores 40 and consumes one charge")
	p.heal_charges = 0
	expect(not p.begin_heal(), "Empty heal inventory is blocked")

func test_projectiles() -> void:
	await fresh()
	await steps(15)
	var p := arena.player
	arena.spawn_projectile(p.position + Vector2(50, 0), Vector2.LEFT)
	await steps(20)
	expect(p.health == 90, "Archer projectile applies 10 damage")
	await fresh()
	await steps(15)
	p = arena.player
	p.position = Vector2(610, 280)
	arena.spawn_projectile(Vector2(510, 280), Vector2.RIGHT)
	await steps(35)
	expect(p.health == 100 and get_nodes_in_group("projectiles").is_empty(), "Solid obstacle blocks projectile before player")
	await fresh()
	await steps(15)
	var e := arena.spawn_enemy("archer", Vector2(1200, 280))
	await steps(60)
	expect(e.state == OrionEnemy.State.APPROACH and get_nodes_in_group("projectiles").is_empty(), "Offscreen archer cannot initiate attack")

func test_loop() -> void:
	await fresh()
	arena.begin_run()
	expect(get_nodes_in_group("enemies").size() == 5, "Arena starts with exactly five enemies")
	arena.player.receive_hit(100, "test_death")
	expect(paused and arena.hud.mode == "dead", "Death pauses arena and exposes restart")
	arena.hud.primary_action()
	expect(not paused and arena.player.health == 100 and arena.player.heal_charges == 2, "Restart resets player and unpauses")
	expect(get_nodes_in_group("enemies").size() == 5 and arena.defeated_count == 0, "Restart replaces rather than duplicates encounter")
	arena.on_controller_changed(0, false)
	expect(paused and arena.hud.mode == "pause", "Controller disconnection pauses play")
	arena.hud.resume()
	for e in get_nodes_in_group("enemies"):
		e.receive_hit(e.health, 0, false)
	await process_frame
	expect(arena.defeated_count == 5, "Each enemy death updates progress once")
	arena.player.position = Vector2(1740, 280)
	await physics_frame
	await process_frame
	expect(paused and arena.hud.mode == "clear", "Exit opens victory after all guards defeated")
