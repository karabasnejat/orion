class_name OrionAudio
extends Node
## Tiny original synthesized cues. Final sound production belongs to phase 2.
var enabled := true
var voices: Array[AudioStreamPlayer] = []
var sounds: Dictionary = {}
var next_voice := 0

func _ready() -> void:
	for i in 4:
		var voice := AudioStreamPlayer.new()
		voice.volume_db = -17
		add_child(voice)
		voices.append(voice)
	sounds.hit = tone(180.0, 0.075)
	sounds.hurt = tone(75.0, 0.13)
	sounds.perfect = tone(620.0, 0.16)

func tone(frequency: float, duration: float) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	var count := int(22050 * duration)
	var bytes := PackedByteArray()
	bytes.resize(count * 2)
	for i in count:
		var phase := float(i) / 22050.0
		var envelope := pow(1.0 - float(i) / count, 2)
		bytes.encode_s16(i * 2, int(sin(TAU * frequency * phase) * envelope * 16000))
	stream.data = bytes
	return stream

func cue(id: String) -> void:
	if not enabled or not sounds.has(id):
		return
	var voice := voices[next_voice]
	next_voice = (next_voice + 1) % voices.size()
	voice.stream = sounds[id]
	voice.play()
