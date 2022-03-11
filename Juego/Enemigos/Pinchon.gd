extends KinematicBody2D

export var velocidad = 100.0
var movimiento = Vector2.ZERO
var gravedad = 400.0
onready var animaciones = $AnimatedSprite
onready var detector_vacio = $detector_vacio
onready var detector_pared = $detector_pared

func _physics_process(_delta):
	caer()
	caminar()
	var _advertencia = move_and_slide(movimiento, Vector2.UP)

func caer():
	if not is_on_floor():
		movimiento.y = gravedad

func caminar():
	if not animaciones.is_playing():
		animaciones.play("Correr")
	esta_por_colisionar()
	movimiento.x = velocidad

func esta_por_colisionar():
	if not detector_vacio.is_colliding() or detector_pared.is_colliding():
		velocidad *= -1
		detector_vacio.position *= -1
		detector_pared.position.x *= -1
		detector_pared.scale.x *= -1
		voltear(animaciones.flip_h)

func voltear(valor_actual):
	animaciones.flip_h = !valor_actual

func _on_DetectarJugador_body_entered(body):
	if body.is_in_group("Jugadores") and body.has_method("herir_jugador"):
		body.herir_jugador()
