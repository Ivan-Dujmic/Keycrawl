extends Entity
class_name Player

@onready var text_controller = get_node("/root/Game/TextController")
@onready var health_bar = get_node("/root/Game/UI/HealthBar")

var target = Vector2(2.5 * Constants.TILE_SIZE, 5.5 * Constants.TILE_SIZE)	# Target location
var last_position = target	# For inputs that try to go through obstacles (if no position change then stop trying)

var luck: float

func update_health():
	health_bar.update_health(float(health) / max_health)

func move(move_amount: Vector2):
	target += move_amount * speed
	
func _on_range_area_body_entered(body: Node2D):
	if body is Enemy:
		text_controller.unblock(body.typing_text)

func _on_range_area_body_exited(body: Node2D):
	if body is Enemy:
		text_controller.block(body.typing_text)

func _on_range_area_area_entered(area: Area2D):
	if area is ItemDrop:
		text_controller.unblock(area.typing_text)

func _on_range_area_area_exited(area: Area2D):
	if area is ItemDrop:
		text_controller.block(area.typing_text)

func initialize(class_init: PlayerClass, difficulty_init: int, position_init: Vector2):
	difficulty = difficulty_init
	
	max_health = class_init.max_health
	health = max_health
	health_regen = class_init.health_regen
	attack = class_init.attack
	action_range = class_init.action_range
	speed = class_init.speed / difficulty
	luck = class_init.luck
	
	range_area.set_range(action_range)
	
	animated_sprite.sprite_frames = class_init.animation_frames
	
	target = position_init
	last_position = position_init
	global_position = position_init

func _ready():
	return

func _physics_process(_delta):
	if target:
		navigation_agent.target_position = target
		
		if not navigation_agent.is_navigation_finished():
			animated_sprite.play("moving")
			
			var next_path_point = navigation_agent.get_next_path_position()
			var direction = (next_path_point - global_position).normalized()
			velocity = direction * max(8, 2 * global_position.distance_to(target))
			move_and_slide()
			
			var current_tile_x = global_position.x / 16
			dungeon_generator.generate_to_x_line(current_tile_x + 20)
			dungeon_generator.erase_to_x_line(current_tile_x - 10)

			animated_sprite.scale.x = - 1 if velocity.x < 0 else 1	# Looking direction
			
			if last_position == global_position:
				target = global_position
				
			last_position = global_position
		else:
			animated_sprite.play("idle")
			velocity = Vector2.ZERO
			animated_sprite.scale.x = 1
