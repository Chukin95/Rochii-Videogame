extends Node

var nivel_actual = ""
var nivel_actual_es_tutorial = false
var vidas = 3
var puntaje = 0
var contador_vidas = 0

func cual_es_nivel_actual():
	return nivel_actual

func este_nivel_es_tutorial():
	return nivel_actual_es_tutorial

func nueva_vida():
	vidas +=1
	contador_vidas += 1
	get_tree().call_group("GUI", "nueva_vida_anim")
	get_tree().call_group("Niveles", "actualizar_vidas", vidas)

func reiniciar_gamehandler():
	vidas = 3
	puntaje = 0

func sumar_puntos(nuevos_puntos):
	puntaje = nuevos_puntos

func perder_vida():
	Gamehandler.vidas -= 1
	get_tree().call_group("Niveles", "guardar_puntos")
	if Gamehandler.vidas <= 0:
		get_tree().call_group("Niveles", "actualizar_vidas", 0)
		perdiste_el_juego() # Game Over - Volver a empezar con 3 vidas
	else:
		yield(get_tree().create_timer(2),"timeout")
		get_tree().call_group("Niveles", "actualizar_vidas", vidas)
		var _var = get_tree().reload_current_scene()

func perdiste_el_juego():
	yield(get_tree().create_timer(2.0),"timeout")
	var _val = get_tree().change_scene("res://Juego/HUD/Perdiste.tscn")
