extends Move

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var downcast = $"../../Downcast"
@onready var root_attachment = $"../../Root"

# way 1, brutal rotation
#@export var ANGULAR_SPEED = 10

# ways 2 and 3
@export var DELTA_VECTOR_LENGTH = 0.1
var jump_direction : Vector3

var landing_height : float = 1.163


func default_lifecycle(_input : InputPackage):
	var floor_point = downcast.get_collision_point()
	if root_attachment.global_position.distance_to(floor_point) < landing_height:
		var xz_velocity = humanoid.velocity
		xz_velocity.y = 0
		if xz_velocity.length_squared() >= 10:
			return "landing_sprint"
		return "landing_run"
	else:
		return "okay"


func update(input : InputPackage, delta ):
	rotate_humanoid(input, delta)
	humanoid.velocity.y -= gravity * delta
	humanoid.move_and_slide()

# way 3, divide velocity and look direction completely
func rotate_humanoid(input : InputPackage, delta : float):
	var input_direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	var input_delta_vector = input_direction * DELTA_VECTOR_LENGTH
	
	jump_direction = (jump_direction + input_delta_vector).limit_length(humanoid.velocity.length())
	humanoid.look_at(humanoid.global_position - jump_direction)
	
	var new_velocity = (humanoid.velocity + input_delta_vector).limit_length(humanoid.velocity.length())
	humanoid.velocity = new_velocity


# way 2, additive or additive-limited, but unpolished
#func rotate_velocity(input : InputPackage, delta : float):
	#var input_direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	#var input_delta_vector = input_direction * DELTA_VECTOR_LENGTH
	#var new_velocity = (humanoid.velocity + input_delta_vector).limit_length(humanoid.velocity.length())
	#humanoid.velocity = new_velocity
	#new_velocity.y = 0
	#humanoid.look_at(humanoid.global_position - input_direction)


# way 1, brutal rotation
#func update(input : InputPackage, delta ):
	#rotate_velocity(input, delta)
	#var new_face_direction = humanoid.velocity
	#new_face_direction.y = 0
	#humanoid.look_at(humanoid.global_position - new_face_direction)
	#
	#humanoid.velocity.y -= gravity * delta
	#humanoid.move_and_slide()

# way 1, brutal rotation
#func rotate_velocity(input : InputPackage, delta : float):
	#var input_direction = (humanoid.camera_mount.basis * Vector3(-input.input_direction.x, 0, -input.input_direction.y)).normalized()
	#var face_direction = humanoid.basis.z
	#var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	#if abs(angle) >= ANGULAR_SPEED * delta:
		#humanoid.velocity = humanoid.velocity.rotated(Vector3.UP, sign(angle) * ANGULAR_SPEED * delta)
	#else:
		#humanoid.velocity = humanoid.velocity.rotated(Vector3.UP, angle)


func on_enter_state():
	jump_direction = Vector3(humanoid.basis.z) * clamp(humanoid.velocity.length(), 1, 999999)
	jump_direction.y = 0
