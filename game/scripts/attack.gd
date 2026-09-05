class_name OrionAttack
extends RefCounted
## An attack instance owns its hit ledger. Presentation never decides damage.
var data: Dictionary
var elapsed := 0.0
var heavy := false
var victims: Dictionary = {}
var multiplier := 1.0

func _init(spec: Dictionary, is_heavy: bool = false) -> void:
	data = spec
	heavy = is_heavy

func advance(delta: float) -> void:
	elapsed += delta

func active() -> bool:
	return elapsed >= float(data.windup) and elapsed < float(data.windup) + float(data.active)

func done() -> bool:
	return elapsed >= duration()

func duration() -> float:
	return float(data.windup) + float(data.active) + float(data.recovery)

func can_cancel() -> bool:
	if heavy:
		return elapsed < float(data.windup)
	return elapsed >= duration() - float(data.cancel_tail)

func claim_hit(target_id: int) -> bool:
	if not active() or victims.has(target_id):
		return false
	victims[target_id] = true
	return true

func damage() -> int:
	return roundi(float(data.damage) * multiplier)
