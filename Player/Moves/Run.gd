extends Move


@export var SPEED = 3.0
@export var TURN_SPEED = 2
@export var ANGULAR_SPEED = 13

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
 

func default_lifecycle(input : InputPackage):
	if not humanoid.is_on_floor():
		return "midair" 
	
	return best_input_that_can_be_paid(input)


func update(input : InputPackage, delta : float):
	rotate_velocity(input, delta)
	humanoid.look_at(humanoid.global_position - humanoid.velocity)
	humanoid.move_and_slide()


func rotate_velocity(input : InputPackage, delta : float):
	var input_direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var face_direction = humanoid.basis.z
	var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	if abs(angle) >= ANGULAR_SPEED * delta:
		humanoid.velocity = face_direction.rotated(Vector3.UP, sign(angle) * ANGULAR_SPEED * delta) * TURN_SPEED
	else:
		humanoid.velocity = face_direction.rotated(Vector3.UP, angle) * SPEED
	animator.speed_scale = humanoid.velocity.length() / SPEED

# TODO implement better speed/animation behaviour in locomotion states
func on_exit_state():
	animator.speed_scale = 1


# old way
#func velocity_by_input(input : InputPackage, delta : float) -> Vector3:
	#var new_velocity = humanoid.velocity
	#
	#var direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	#new_velocity.x = direction.x * SPEED
	#new_velocity.z = direction.z * SPEED
	#
	#if not humanoid.is_on_floor():
		#new_velocity.y -= gravity * delta
	#
	##print(new_velocity)
	#return new_velocity
