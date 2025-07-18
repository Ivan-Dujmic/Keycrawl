extends CharacterBody2D
class_name Entity

@onready var range_area = $RangeArea
@onready var navigation_agent = $NavigationAgent
@onready var animated_sprite = $AnimatedSprite

signal update_stat(stat: String, value)

# Stats
var max_health: int:
	set(value):
		max_health = value
		update_health()
		if health > max_health:
			health = max_health
var health: int:	# Current health
	set(value):
		health = clamp(value, 0, max_health)
		update_health()
		if health == 0:
			die()
var health_regen: int:	# Health regen per second
	set(value):
		health_regen = value
		if self is Player:
			update_stat.emit("health_regen", value)
var attack: int:	# Attack power
	set(value):
		attack = value
		if self is Player:
			update_stat.emit("attack", value)
var max_action_range: int = 240
var action_range: int:	# Pixel range in which the player can performs actions
	set(value):
		action_range = clamp(value, 0, max_action_range)
		update_action_range(value)
var speed: float:	# Movement speed
	set(value):
		speed = value
		if self is Player:
			update_stat.emit("speed", value)

func update_health():
	return
	
func update_action_range(_value: int):
	return

func take_damage(damage: int):
	health -= damage
	
func heal(healing: int):
	health += healing
	
func die():
	return	

func _on_health_regen_timeout():
	health += health_regen

func _on_range_area_body_entered(_body: Node2D):
	return

func _on_range_area_body_exited(_body: Node2D):
	return
	
func _on_range_area_area_entered(_area: Area2D):
	pass 

func _on_range_area_area_exited(_area: Area2D):
	pass

func _ready():
	return

func _physics_process(_delta):
	return
