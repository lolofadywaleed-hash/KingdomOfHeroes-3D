extends CanvasLayer

var coins = 0

func _ready():
	add_to_group("hud")

func add_coin():
	coins += 1
	var coin_label = $Coins/CoinCount
	if coin_label:
		coin_label.text = str(coins)
