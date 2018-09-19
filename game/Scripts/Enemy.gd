extends KinematicBody2D

var speed = 350
var nav = null setget set_nav
var path = []
var goal = Vector2()
var life = 500
var damage = 50

var is_swordfish = false
var red_texture = preload("res://Assets/Art/UI/red_button00.png")

func _ready():
	damage = Global.platform_life / 10
	speed += (get_parent().get_node("Platform").producting_pits) * 10
	$HealthBar.max_value = self.life
	$HealthBar.value = $HealthBar.max_value
	if is_swordfish:
		life += (life / 3)
		speed -= 50
		damage *= 2
		$Sprite.animation = "swordfish"

func set_nav(new_nav):
	nav = new_nav
	path = nav.get_simple_path(global_position, goal, false)

func _physics_process(delta):
	# update healthbar
	$HealthBar.value = self.life
	# travel to the next point
	if path.size() > 1:
		var d = global_position.distance_to(path[0])
		if d > 6:
			global_position = global_position.linear_interpolate(path[0], 
					(speed * delta) / d)
		else:
			path.remove(0)
	else:
		queue_free()

func hit(damage):
	# check remaining life
	if life > damage:
		life -= damage
		Global.money += 2
	else:
		life = 0
		explode()

func explode():
	$CollisionShape2D.disabled = true
	speed = 0
	$AnimationPlayer.play("explode")
	Global.money += 100

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()

func _on_HealthBar_value_changed(value):
	if value <= $HealthBar.max_value / 4:
		$HealthBar.texture_progress = red_texture


