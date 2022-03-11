extends Control

onready var nubes1 = $ParallaxBackground/ParallaxLargaDistancia
onready var nubes2 = $ParallaxBackground/ParallaxLargaDistancia2
onready var nubes3 = $ParallaxBackground/ParallaxLargaDistancia3
onready var nubes4 = $ParallaxBackground/ParallaxLargaDistancia4
onready var animacion = $AnimationPlayer

func _ready():
	animacion.play("Aclarar")
	Gamehandler.reiniciar_gamehandler()

func _input(_event):
	if Input.is_action_pressed("Salir"):
		animacion.play("Oscurecer")
		yield(get_tree().create_timer(0.5),"timeout")
		get_tree().quit()

func _process(delta):
	nubes1.motion_offset.x -= 9*delta
	nubes2.motion_offset.x -= 7*delta
	nubes3.motion_offset.x -= 5*delta
	nubes4.motion_offset.x -= 3*delta


func _Boton_Tutorial():
	animacion.play("Oscurecer")
	$Panel.set_deferred("visible",false)
	$Tutorial_MenuPrincipal.start(1.0)


func _Boton_NuevaPartida():
	animacion.play("Oscurecer")
	$Panel.set_deferred("visible",false)
	$NuevaPartida_MenuPrinciapal.start(1.0)


func _Boton_Salir():
	animacion.play("Oscurecer")
	$Panel.set_deferred("visible",false)
	$Salir_MenuPrincipal.start(1.0)


func _Timer_NuevaPartida_MenuPrinciapal():
	var _ret = get_tree().change_scene("res://Juego/Niveles/Nivel 1.tscn")


func _Boton_Tutorial_MenuPrincipal():
	var _ret = get_tree().change_scene("res://Juego/Niveles/Nivel 0-1.tscn")


func _Timer_Salir_MenuPrincipal():
	get_tree().quit()


func _AnimationPlayer_Animacion_Terminada(anim_name):
	if anim_name == "Aclarar":
		animacion.play("CuteGirl")


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()

