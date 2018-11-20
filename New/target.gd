extends StaticBody2D

var pos = Vector2()
var direction_from_player = Vector2()
var direction_to_player = Vector2()
var direction = Vector2()

func _ready():
	var Player = get_tree().get_root().get_node("./World/Player")
	direction_from_player = (position - get_parent().get_node("Player").position).normalized()
	direction = direction_from_player
	pos = position
	$AnimatedSprite.play("Idle")