extends KinematicBody2D

var movimiento = Vector2.ZERO
onready var colisionadores_volador = [$DetectorJugadorConCabeza/ColisionConCabeza,$DetectorJugadorConCuerpo/ColisionConJugador,$CollisionShape2D]
onready var animaciones = $AnimatedSprite
onready var sonido_saltar = $AudioStreamPlayer

func _ready():
	animaciones.play("Volando")

func _physics_process(_delta):
	var _advertencia = move_and_slide(movimiento, Vector2.UP)

func _on_DetectorJugadorConCabeza_body_entered(body):
	if body.is_in_group("Jugadores"):
		sonido_saltar.play()
		body.impulsar_jugador()
		desactivar_colisionadores(colisionadores_volador)
		animaciones.play("Muerte")

func _on_DetectorJugadorConCuerpo_body_entered(body):
	if body.is_in_group("Jugadores"):
		body.herir_jugador()

func desactivar_colisionadores(colisionadores):
	movimiento.y = 400
	for for1 in colisionadores:
		for1.set_deferred("disabled", true)
		for1.set_deferred("visible", false)


func _on_VisibilityNotifier2D_screen_exited():
	if movimiento.y == 400:
		queue_free()
