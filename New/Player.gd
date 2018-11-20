tool
extends KinematicBody2D

const RUN_SPEED = 200
const JUMP_SPEED = -600
const GRAVITY = 1100

const DETECT_RADIUS = 200
const FOV = 80

var detect_count = 0
var angle = 0
var direction = Vector2()

var inRange = false
var velocity = Vector2()
var jumping = false

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed("ui_up")
	
	if right:
		velocity.x += RUN_SPEED
		$sprite.flip_h = false
		$sprite.play("Run")

	elif left:
		velocity.x -= RUN_SPEED
		$sprite.flip_h = true
		$sprite.play("Run")	
	elif !jumping and is_on_floor():
		if detect_count:
			$sprite.play("IdleSword")
		else:
			$sprite.play("Idle")
		
	if jump and is_on_floor():
		$sprite.play("Jump")
		jumping = true
		velocity.y = JUMP_SPEED
		
		
func _physics_process(delta):
	
	get_input()
				
	velocity.y += GRAVITY * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity , Vector2(0,-1))
	
	#Field of view
	var pos = position
	direction = (get_global_mouse_position() - pos).normalized()
	angle = 90 - rad2deg(direction.angle())

	detect_count = 0
	for node in get_tree().get_nodes_in_group('detectable'):
		if pos.distance_to(node.position) < DETECT_RADIUS:
			inRange = true
			var angle_to_node = rad2deg(direction.angle_to(node.direction_from_player))
			if abs(angle_to_node) < FOV/2:
				detect_count += 1
		else:
			inRange = false
#	# DRAWING
	if detect_count > 0:
		draw_color = RED
	else:
		draw_color = GREEN
	update()

const RED = Color(1.0, 0, 0, 0.4)
const GREEN = Color(0, 1.0, 0, 0.4)

var draw_color = GREEN


#func _draw():
#	draw_circle_arc_poly(Vector2(), DETECT_RADIUS, angle - FOV/2, angle + FOV/2, draw_color)
#
#func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
#	var nb_points = 32
#	var points_arc = PoolVector2Array()
#	points_arc.push_back(center)
#	var colors = PoolColorArray([color])
#
#	for i in range(nb_points+1):	
#		var angle_point = angle_from + i*(angle_to-angle_from)/nb_points
#		points_arc.push_back(center + Vector2( cos( deg2rad(-angle_point+90) ), sin( deg2rad(-angle_point+90) ) ) * radius)
#	draw_polygon(points_arc, colors)