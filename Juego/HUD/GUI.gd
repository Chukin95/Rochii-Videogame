extends CanvasLayer

onready var animaciones = $AnimationPlayer

var contador_salud = 0
var contador_vidas = 0

func _ready():
	add_to_group("GUI")
	contador_salud = 0
	contador_vidas = 0

func nueva_salud_anim():
	contador_salud += 1
	if contador_salud == 1:
		animaciones.play("nueva_salud")
	else:
		animaciones.queue("nueva_salud")

func nueva_vida_anim():
	contador_vidas += 1
	if contador_vidas == 1:
		animaciones.play("nueva_vida")
	else:
		animaciones.queue("nueva_vida")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "nueva_salud":
		contador_salud -= 1
	elif anim_name == "nueva_vida":
		contador_vidas -= 1
