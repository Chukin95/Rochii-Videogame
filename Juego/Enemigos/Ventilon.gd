extends KinematicBody2D

export var puede_morir = true

var movimiento = Vector2.ZERO

onready var colisionadores_ventilon = [$ColisionHerir/ColisionHerir,$ColisionCuerpo,$MatarVentilon/ColisionMatar]
onready var animaciones = $AnimatedSprite


func _ready():
	animaciones.play("Volando")
	if puede_morir == false:
		$MatarVentilon/ColisionMatar.set_deferred("disabled", true)
		$MatarVentilon/ColisionMatar.set_deferred("visible", false)


func _physics_process(_delta):
	var _advertencia = move_and_slide(movimiento, Vector2.UP)


func _on_ColisionHerir_body_entered(body):
	if body.is_in_group("Jugadores") and body.has_method("herir_jugador"):
		body.herir_jugador()

func _on_MatarVentilon_body_entered(body):
	if body.is_in_group("Jugadores") and body.has_method("impulsar_jugador"):
		animaciones.play("Muerte")
		desactivar_colisionadores(colisionadores_ventilon)

func desactivar_colisionadores(colisionadores):
	movimiento.y = 400
	for for1 in colisionadores:
		for1.set_deferred("disabled", true)
		for1.set_deferred("visible", false)

func _on_VisibilityNotifier2D_screen_exited():
	if movimiento.y == 400:
		queue_free()
