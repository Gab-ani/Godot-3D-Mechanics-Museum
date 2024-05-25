extends Move

@export var SPEED = 3.0
@export var TURN_SPEED = 2
@export var VERTICAL_SPEED_ADDED : float = 2.5
@export var ANGULAR_SPEED = 7

@export var DELTA_VECTOR_LENGTH = 0.05
var jump_direction : Vector3

const TRANSITION_TIMING = 0.44  
const JUMP_TIMING = 0.1

var jumped : bool = false


func default_lifecycle(_input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		jumped = false
		return "midair"
	else: 
		return "okay"


func update(input : InputPackage, delta ):
	rotate_humanoid(input, delta)
	process_jump()
	humanoid.move_and_slide()


func rotate_humanoid(input : InputPackage, delta : float):
	var input_direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var face_direction = humanoid.basis.z
	var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	if abs(angle) >= ANGULAR_SPEED * delta:
		humanoid.velocity = humanoid.velocity.rotated(Vector3.UP, sign(angle) * ANGULAR_SPEED * delta)
		face_direction = face_direction.rotated(Vector3.UP, sign(angle) * ANGULAR_SPEED * delta)
	else:
		humanoid.velocity = humanoid.velocity.rotated(Vector3.UP, angle)
		face_direction = face_direction.rotated(Vector3.UP, angle)
	
	humanoid.look_at(humanoid.global_position - face_direction)


func process_jump():
	if works_longer_than(JUMP_TIMING):
		if not jumped:
			humanoid.velocity.y += VERTICAL_SPEED_ADDED
			jumped = true


func on_enter_state():
	humanoid.velocity = humanoid.velocity.normalized() * SPEED 
