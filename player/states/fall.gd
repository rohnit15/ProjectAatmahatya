class_name PlayerStateFall extends PlayerState

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(_event: InputEvent) -> PlayerState:
	return next_state
	
func process(_delta: float) -> PlayerState:
	return next_state

func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor():
		player.add_debug_indicator(Color.RED)
		return idle
	return next_state
	
