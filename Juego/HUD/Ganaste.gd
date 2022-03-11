extends Control

onready var arbol_padre = get_tree()
onready var animacion = $AnimationPlayer
onready var label = $Panel/VBoxContainer/MenuGanador

func _ready():
	label.text = "PUNTOS: %s" % Gamehandler.puntaje

func _input(_event):
	if Input.is_action_pressed("Salir"):
		animacion.play("Oscurecer")
		yield(get_tree().create_timer(0.5),"timeout")
		var _ret = arbol_padre.change_scene("res://Juego/HUD/MenuPrincipal.tscn")

func _boton_VolverAJugar():
	Gamehandler.reiniciar_gamehandler()
	animacion.play("Oscurecer")
	$Panel.set_deferred("visible",false)
	$TimerJugarDeNuevo.start(1.0)

func _Boton_MenuPrincipal_Ganaste():
	Gamehandler.reiniciar_gamehandler()
	animacion.play("Oscurecer")
	$Panel.set_deferred("visible",false)
	$TimerMenuPrincipal.start(1.0)

func _Boton_Salir_Ganaste():
	animacion.play("Oscurecer")
	$Panel.set_deferred("visible",false)
	$TimerSalir.start(1.0)

func _Timer_JugarDeNuevo():
	var _ret = arbol_padre.change_scene("res://Juego/Niveles/Nivel 1.tscn")

func _Timer_MenuPrincipal():
	var _ret = arbol_padre.change_scene("res://Juego/HUD/MenuPrincipal.tscn")

func _Timer_Salir():
	arbol_padre.quit()


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
