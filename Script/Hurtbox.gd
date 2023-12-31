extends Area2D

const HitEffect = preload("res://HitEffect.tscn")

onready var timer = $Timer
var invincible = false setget set_invincible

signal invinvibility_started
signal invincibility_ended


func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invinvibility_started")
	else:
		emit_signal("invincibility_ended")
		
	
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	
	
func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position 


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_ended():
	monitorable = true


func _on_Hurtbox_invinvibility_started():
	set_deferred("monitorable",false)
