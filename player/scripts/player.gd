class_name Player extends CharacterBody2D
const JUMP_DEBUG_INDICATOR = preload("uid://murten2e607")


#region // export variables
@export var move_speed: float = 200
@export var jump_speed: float = 460
#endregion

#region //state machine vars
var states: Array[PlayerState]

var current_state: PlayerState:
	get: return states.front()
var previous_state: PlayerState:
	get: return states[1]
#endregion

#region /// standard vars
var direction: Vector2 = Vector2.ZERO
var gravity: float = 980
#endregion

func _ready() -> void:
	init_states()
	pass

func _unhandled_input(event: InputEvent) -> void:
	update_direction()
	change_states(current_state.handle_input(event))
	pass

func _process(delta: float) -> void:
	change_states(current_state.process(delta))
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
	change_states(current_state.physics_process(delta))
	pass

func init_states() -> void:
	states = []
	# Gather states
	for state in $States.get_children():
		if state is PlayerState:
			states.append(state)
			state.player = self
	
	if states.size() == 0:
		return
	
	# Init States
	for state in states:
		state.init()
	
	# Set first state
	change_states(current_state)
	current_state.enter()
	print(states)
	$Label.text = current_state.name
	pass

func change_states(new_state: PlayerState) -> void:
	if !new_state:
		return
	elif new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	states.push_front(new_state)
	current_state.enter()
	states.resize(3)
	$Label.text = current_state.name
	pass

func update_direction() -> void:
	var prev_direction: Vector2 = direction
	var x_axis = Input.get_axis("left", "right")
	var y_axis = Input.get_axis("up", "down")
	direction = Vector2(x_axis, y_axis)
	
	pass

func add_debug_indicator(color: Color = Color.RED) -> void:
	var d: Node2D = JUMP_DEBUG_INDICATOR.instantiate()
	get_tree().root.add_child(d)
	d.global_position = global_position
	d.modulate = color
	await get_tree().create_timer(3).timeout
	d.queue_free()
	pass
