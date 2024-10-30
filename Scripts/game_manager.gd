extends Node

var OnDice: bool = true #if false, displaying coins

var AddCoinButton: Button
var DiceButton1: Button
var DiceButton3: Button
var DiceButton6: Button
var SwapButton: Button
var CoinButton: Button
var DiceButtons: CanvasGroup
var list: Array[Node3D] = []
var coinList: Array[Node3D] = []
var total = 0
var die_scene = load("res://Objects/die.tscn")
var coin_scene = load("res://Objects/coin.tscn")
var text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = $"../Count"
	text.text = "Press Space To Spawn Dice!\n\nR To Reset!\n\nEnter to ReRoll!"
	DiceButton1 = $"../CanvasGroup/1 Dice"
	DiceButton3 = $"../CanvasGroup/3 Dice"
	DiceButton6 = $"../CanvasGroup/6 Dice"
	SwapButton = $"../CanvasGroup/Swap"
	CoinButton = $"../CanvasGroup/Flip"
	DiceButtons = $"../CanvasGroup/Dice Buttons"
	AddCoinButton = $"../CanvasGroup/Coin"
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("dice"):
		addDie(1)
	
	if Input.is_action_just_pressed("coin"):
		flipCoin()
	
	if Input.is_action_just_pressed("reroll"):
		reRollDice()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if (OnDice && total == 0):
		text.bbcode_text = "Roll the Dice!"
	pass

func addDie(x: int) -> void:
	removeCoin()
	for i in range(x):
		var die_instance = die_scene.instantiate()
		add_child(die_instance) 
		die_instance.Drop(0)
		list.append(die_instance)
	pass

func addCoin() -> void:
	removeDice()
	var coin_instance = coin_scene.instantiate()
	add_child(coin_instance) 
	coinList.append(coin_instance)
	pass

func flipCoin() -> void:
	if coinList.is_empty():
		addCoin()
	else:
		#coin.Flip(0)
		for element in coinList:
			element.Flip(0)
	pass

func reRollDice() -> void:
	for element in list:
		element.reRoll()
	pass

func addNum(x: int) -> void:
	total += x
	print("Adding: " + str(x) + "\n\tNew Total: " + str(total))
	var new_text = "Total: " + str(total)
	text.bbcode_text = new_text
	pass
	
func reportFlip(x: int) -> void:
	var new_text = "it broke"
	if (x == 1):
		print("Flip result is: HEADS!")
		new_text = "Flipped HEADS!"
	else:
		print("Flip result is: TAILS!")
		new_text = "Flipped TAILS!"
	text.bbcode_text = new_text
	pass
	
func removeNum(x: int) -> void:
	if total == 0:
		return
	total -= x
	print("Removing: " + str(x) + "\n\tNew Total: " + str(total))
	var new_text = "Total: " + str(total)
	text.bbcode_text = new_text
	pass

func removeDice() -> void:
	for element in list:
		element.queue_free()
	list.clear()
	removeNum(total)
	pass

func removeCoin() -> void:
	for element in coinList:
		element.queue_free()
	coinList.clear()
	pass

func _6_Dice_Pressed() -> void:
	addDie(6)
	pass # Replace with function body.


func _3_Dice_Pressed() -> void:
	addDie(3)
	pass # Replace with function body.


func _1_Dice_Pressed() -> void:
	addDie(1)
	pass # Replace with function body.


func _Swap_Button_Pressed() -> void:
	if OnDice:
		removeDice()
		AddCoinButton.visible = true
		DiceButtons.visible = false
		CoinButton.visible = true
		SwapButton.text = "Swap to Dice"
		text.bbcode_text = "Flip the Coin!"
		addCoin()
	else:
		removeCoin()
		AddCoinButton.visible = false
		DiceButtons.visible = true
		CoinButton.visible = false
		SwapButton.text = "Swap to Coin"
		text.bbcode_text = "Roll Some Dice!"
	OnDice = !OnDice
	pass # Replace with function body.



func _Coin_Pressed() -> void:
	addCoin()
	pass # Replace with function body.


func _Flip_Button_Pressed() -> void:
	flipCoin()
	pass # Replace with function body.
