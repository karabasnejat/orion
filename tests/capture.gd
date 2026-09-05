extends SceneTree
## Real renderer smoke test; requires a display (or xvfb-run on Linux).
func _initialize() -> void:
	call_deferred("capture")

func capture() -> void:
	var scene := load("res://game/scenes/main.tscn") as PackedScene
	var arena := scene.instantiate() as OrionArena
	root.add_child(arena)
	for i in 5:
		await process_frame
	await RenderingServer.frame_post_draw
	DirAccess.make_dir_recursive_absolute("res://artifacts")
	var popup_rect := arena.hud.popup.get_global_rect()
	if popup_rect.end.y > 334 or popup_rect.end.x > 640:
		push_error("Menu does not fit the logical viewport: " + str(popup_rect))
		quit(1)
		return
	if arena.hud.bar.get_global_rect().end.y > 48:
		push_error("Health bar overlaps the arena")
		quit(1)
		return
	root.get_texture().get_image().save_png("res://artifacts/menu.png")
	arena.hud.primary_action()
	arena.player.position = Vector2(790, 280)
	for i in 20:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("res://artifacts/arena.png")
	print("RENDER SMOKE: menu and arena captured")
	arena.queue_free()
	await process_frame
	quit()
