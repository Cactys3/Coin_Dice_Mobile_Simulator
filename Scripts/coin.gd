extends Node3D
var manager
var body: RigidBody3D
var gen = RandomNumberGenerator.new()

var Flipping = false
var value: int = 0

const MIN_ROT = 6
const MAX_ROT = 23
const MIN_VEL = 5
const MAX_VEL = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	manager = $"../../Game Manager"
	body = $RigidBody3D
	if gen.randi_range(0, 1) == 1:
		body.rotate_x(TAU/2)
	body.position = Vector3(gen.randf_range(-5, 5), 0, gen.randf_range(-5, 5))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Flipping && body.position.y < 0 && body.angular_velocity.length() < 0.1):
		Flipping = false
		value = getValue()
		manager.reportFlip(value)
		pass

func getValue() ->  int:
	var dotHeads = body.basis.y.dot(Vector3.UP)
	var dotTails = body.basis.y.dot(Vector3.DOWN)
	print(dotHeads)
	print(dotTails)
	if dotTails > dotHeads:
		return 1
	else:
		return 0

func Flip(y: int) -> void:
	Flipping = true
	var rotation1: int = gen.randf_range(MIN_ROT, MAX_ROT)
	var rotation2: int = gen.randf_range(MIN_ROT, MAX_ROT)
	var velocity:  int = gen.randf_range(MIN_VEL, MAX_VEL)
	if gen.randi_range(0, 1) == 0:
		rotation2 = rotation2 * -1
	if gen.randi_range(0, 1) == 0:
		rotation1 = rotation1 * -1
	body.angular_velocity = Vector3(rotation1, 0, rotation2)
	body.apply_impulse(Vector3(0, velocity, 0), Vector3.ZERO)
	pass
