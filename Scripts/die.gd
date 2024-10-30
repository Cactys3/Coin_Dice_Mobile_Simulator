extends Node3D
var manager
var body: RigidBody3D
var gen = RandomNumberGenerator.new()

var Dropping = false
var value: int = 0

const MAX_X = 2
const MAX_Z = 2
const MIN_X = -2
const MIN_Z = -2
const MIN_ROT = 0
const MAX_ROT = TAU

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	manager = $"../../Game Manager"
	body = $RigidBody3D
	pass # Replace with function body.

# Called by Game Manager when game is started
func Drop(y: float) -> void:
	var x = gen.randf_range(MIN_X, MAX_X)
	var z = gen.randf_range(MIN_Z, MAX_Z)
	var angle1 = gen.randf_range(MIN_ROT, MAX_ROT)
	var angle2 = gen.randf_range(MIN_ROT, MAX_ROT)
	var angle3 = gen.randf_range(MIN_ROT, MAX_ROT)
	
	body.rotate_x(angle1)
	body.rotate_y(angle2)
	body.rotate_z(angle3)
	
	body.position.x = x
	body.position.y = y
	body.position.z = z
	Dropping = true
	pass

func _process(_delta: float) -> void:
	if !Dropping:
		body.linear_velocity = Vector3.ZERO
	if (body.position.y < -1 && body.linear_velocity.length() < 0.1 && Dropping): #if the die is more than 1 unit below starting position, barely moving, and we are dropping
		value = getValue()
		manager.addNum(value)
		Dropping = false
	pass

func getValue() -> int:
	var up_direction = Vector3.UP # (0, 1, 0)
	var directions = [
	body.transform.basis.z,  #1
	body.transform.basis.x,  #2
	body.transform.basis.y,  #3
	-body.transform.basis.x, #4
	-body.transform.basis.z, #5
	-body.transform.basis.y  #6
	]
	var max_dot_product = -1
	var upward_face_index = -1
	for i in range(directions.size()):
		var dot_product = directions[i].dot(up_direction)
		if dot_product > max_dot_product:
			max_dot_product = dot_product
			upward_face_index = i
			
	return upward_face_index + 1


func reRoll() -> void:
	if !Dropping:
		manager.removeNum(value)
		Dropping = true
	Drop(0)
	pass
