class_name OrionHUD
extends CanvasLayer
var arena: Node2D
var bar: ProgressBar
var stats: Label
var oath_label: Label
var progress_label: Label
var hint: Label
var popup: PanelContainer
var mode := ""
var gamepad := false
var screen_shake := true
var menu_title: Label
var menu_copy: Label
var start_button: Button
var second_button: Button
var oath_choice: CheckBox
var log_choice: CheckBox
var sound_choice: CheckBox
var shake_choice: CheckBox

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	var top := ColorRect.new()
	top.color = Color(0.04, 0.05, 0.09, 0.92)
	top.position = Vector2(0, 0)
	top.size = Vector2(640, 48)
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(top)
	stats = label(root, Vector2(16, 6), "", 12)
	bar = ProgressBar.new()
	bar.position = Vector2(16, 27)
	bar.show_percentage = false
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("e9936c")
	bar.add_theme_stylebox_override("fill", fill)
	var track := StyleBoxFlat.new()
	track.bg_color = Color("302b35")
	bar.add_theme_stylebox_override("background", track)
	bar.size = Vector2(180, 8)
	root.add_child(bar)
	oath_label = label(root, Vector2(220, 9), "", 11)
	progress_label = label(root, Vector2(466, 9), "", 11)
	hint = label(root, Vector2(16, 337), "", 10)
	popup = PanelContainer.new()
	popup.position = Vector2(102, 53)
	popup.size = Vector2(436, 266)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("111624")
	style.border_color = Color("8e614d")
	style.set_border_width_all(1)
	style.content_margin_left = 22
	style.content_margin_right = 22
	style.content_margin_top = 14
	style.content_margin_bottom = 14
	popup.add_theme_stylebox_override("panel", style)
	root.add_child(popup)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 3)
	popup.add_child(column)
	menu_title = Label.new()
	menu_title.add_theme_font_size_override("font_size", 25)
	menu_title.add_theme_color_override("font_color", Color("ffd6a6"))
	column.add_child(menu_title)
	menu_copy = Label.new()
	menu_copy.add_theme_font_size_override("font_size", 11)
	menu_copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	menu_copy.custom_minimum_size.x = 388
	column.add_child(menu_copy)
	oath_choice = CheckBox.new()
	oath_choice.text = "Avcı Yemini · kaçış 0,8 sn / karşı darbe ×1,5"
	oath_choice.button_pressed = true
	oath_choice.add_theme_font_size_override("font_size", 11)
	column.add_child(oath_choice)
	log_choice = CheckBox.new()
	log_choice.text = "Yerel oyun testi günlüğü (ağ bağlantısı yok)"
	log_choice.add_theme_font_size_override("font_size", 11)
	column.add_child(log_choice)
	sound_choice = CheckBox.new()
	sound_choice.text = "Ses efektleri"
	sound_choice.button_pressed = true
	sound_choice.add_theme_font_size_override("font_size", 11)
	sound_choice.toggled.connect(func(value: bool) -> void: arena.audio.enabled = value)
	var effects_row := HBoxContainer.new()
	column.add_child(effects_row)
	effects_row.add_child(sound_choice)
	shake_choice = CheckBox.new()
	shake_choice.text = "Kamera sarsıntısı"
	shake_choice.button_pressed = true
	shake_choice.add_theme_font_size_override("font_size", 11)
	shake_choice.toggled.connect(func(value: bool) -> void: screen_shake = value)
	effects_row.add_child(shake_choice)
	start_button = Button.new()
	start_button.text = "Ocağı terk et"
	start_button.add_theme_font_size_override("font_size", 13)
	start_button.pressed.connect(primary_action)
	var actions := HBoxContainer.new()
	column.add_child(actions)
	start_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	actions.add_child(start_button)
	second_button = Button.new()
	second_button.text = "Çıkış"
	second_button.add_theme_font_size_override("font_size", 11)
	second_button.pressed.connect(func() -> void: get_tree().quit())
	actions.add_child(second_button)
	popup.hide()

func label(parent: Node, at: Vector2, text_value: String, size_value: int) -> Label:
	var item := Label.new()
	item.position = at
	item.text = text_value
	item.add_theme_font_size_override("font_size", size_value)
	item.add_theme_color_override("font_color", Color("d7cfca"))
	parent.add_child(item)
	return item

func _process(_delta: float) -> void:
	if not is_instance_valid(arena.player):
		return
	var p: OrionPlayer = arena.player
	bar.value = p.health
	stats.text = "CAN %d/100   ·   ŞİFA %d/2" % [p.health, p.heal_charges]
	oath_label.text = "AVCI YEMİNİ" if p.hunter_oath else "YEMİNSİZ"
	if p.empower_left > 0.0:
		oath_label.text += "  •  ×1,5 HAZIR"
	elif p.dodge_cooldown > 0.0:
		oath_label.text += "  ·  %.1f sn" % p.dodge_cooldown
	progress_label.text = "KÜL ZİNDANLARI\n%d / 5 yenildi" % arena.defeated_count
	hint.text = "A/D Hareket · Space Zıpla · J/K Vur · Shift Kaç · E Şifa · Esc Menü"
	if gamepad:
		hint.text = "Sol çubuk Hareket · A Zıpla · X/Y Vur · B Kaç · LB Şifa · Menu"
	if arena.telemetry.write_failed:
		hint.text = "Test günlüğü yazılamadı. Oynanış devam ediyor."

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		gamepad = true
	elif event is InputEventKey:
		gamepad = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if mode == "pause":
			resume()
		elif mode == "":
			show_menu("pause")
		get_viewport().set_input_as_handled()

func show_menu(value: String, detail: String = "") -> void:
	mode = value
	get_tree().paused = true
	popup.show()
	oath_choice.visible = mode == "start"
	log_choice.visible = mode == "start"
	sound_choice.visible = mode in ["start", "pause"]
	shake_choice.visible = mode in ["start", "pause"]
	match mode:
		"start":
			menu_title.text = "KÜL YEMİNİ"
			menu_copy.text = "ORION / DÖVÜŞ PROTOTİPİ\nÜç salonu geç, beş muhafızı yen, doğudaki mühre ulaş.\nSon anda kaç: ilk 100 ms'de saldırıdan sıyrıl, sonraki\nisabeti 2 sn içinde güçlendir. Kaçış bedeli: +0,15 sn."
			start_button.text = "Ocağı terk et"
		"pause":
			menu_title.text = "ATEŞ BEKLİYOR"
			menu_copy.text = "Oyun duraklatıldı.\nAşağı + zıplama: ince platformdan in.\nİyileşme 0,7 sn sürer; darbe alırsan kesilir.\nBu prototipte sefer kaydı bulunmuyor."
			start_button.text = "Devam et"
		"dead":
			menu_title.text = "KÜLE DÖNDÜN"
			menu_copy.text = "Son darbe: %s\nYenilen muhafız: %d / 5\nHer saldırının bir açıklığı var. Yeniden dene." % [detail, arena.defeated_count]
			start_button.text = "Yeniden doğ"
		"clear":
			menu_title.text = "MÜHÜR KIRILDI"
			menu_copy.text = "Prototip arenasını tamamladın.\nSüre: %.1f sn · Yemin: %s\nFarklı bir yaklaşım denemek için yeniden doğ." % [arena.telemetry.elapsed, "Avcı" if arena.player.hunter_oath else "Yok"]
			start_button.text = "Yeni sefer"
	start_button.grab_focus()

func primary_action() -> void:
	if mode == "start":
		arena.player.hunter_oath = oath_choice.button_pressed
		arena.telemetry.enabled = log_choice.button_pressed
		arena.begin_run()
	elif mode in ["dead", "clear"]:
		arena.reset_run()
	resume()

func resume() -> void:
	mode = ""
	popup.hide()
	get_tree().paused = false
