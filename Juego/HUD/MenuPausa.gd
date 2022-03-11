extends Control

onready var animacion = $AnimationPlayer

var nivel_reintentar = ""
var es_tutorial = false

func _ready():
	visible = false
	get_tree().paused = false
	nivel_reintentar = Gamehandler.cual_es_nivel_actual()
	es_tutorial = Gamehandler.este_nivel_es_tutorial()
	if es_tutorial:
		$Panel/VBoxContainer/Reintentar.text = "Reintentar"


func _input(event):
	if event.is_action_pressed("Pausa"):
		visible = not visible
		get_tree().paused = not get_tree().paused
	if event.is_action_pressed("Salir"):
		visible = not visible
		get_tree().quit()

func _Boton_Continuar():
	visible = not visible
	get_tree().paused = not get_tree().paused


func _Boton_Reintentar():
	animacion.play("Oscurecer")
	$TimerReintentar.start(1.0)


func _Boton_Salir():
	animacion.play("Oscurecer")
	$TimerSalir.start(1.0)


func _Timer_Reintentar():
	visible = false
	get_tree().paused = false
	if es_tutorial:
		var _ret = get_tree().change_scene(nivel_reintentar)
	else:
		var _ret = get_tree().change_scene("res://Juego/Niveles/Nivel 1.tscn")


func _Timer_Salir():
	visible = false
	get_tree().paused = false
	var _ret = get_tree().change_scene("res://Juego/HUD/MenuPrincipal.tscn")
