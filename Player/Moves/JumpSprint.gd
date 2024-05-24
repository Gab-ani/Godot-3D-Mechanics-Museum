extends Move

const SPEED = 5.0
const VERTICAL_SPEED_ADDED : float = 2.5

const TRANSITION_TIMING = 0.4
const JUMP_TIMING = 0.0657

var jumped : bool = false


func default_lifecycle(_input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		jumped = false
		return "midair"
	else: 
		return "okay"


func update(_input : InputPackage, _delta ):
	if works_longer_than(JUMP_TIMING):
		if not jumped:
			humanoid.velocity.y += VERTICAL_SPEED_ADDED
			jumped = true
	humanoid.move_and_slide()


func on_enter_state():
	humanoid.velocity = humanoid.velocity.normalized() * SPEED 
