extends Node2D

export var rayo: PackedScene
export (String,"nivel1","nivel2","nivel3","nivel4") var nubon_nivel = "nivel1"

onready var sonido = $AudioStreamPlayer
onready var Temporizador = $Timer
onready var colisionador1 = $Sprite/RayCastNivel1
onready var colisionadores5 = [$Sprite/RayCastNivel2y3a,$Sprite/RayCastNivel2y3b]
onready var colisionadores7 = [$Sprite/RayCastNivel4a,$Sprite/RayCastNivel4b]
onready var posiciones_disparo1 = $Sprite/PosicionesDisparo3
onready var posiciones_disparo5 = $Sprite/PosicionesDisparo5
onready var posiciones_disparo7 = $Sprite/PosicionesDisparo7

var puede_disparar = true

func _ready():
	match nubon_nivel:
		"nivel1":
			colisionador1.enabled = true
		"nivel2","nivel3":
			for for1 in colisionadores5:
				for1.enabled = true
		"nivel4":
			for for1 in colisionadores7:
				for1.enabled = true

func _process(_delta):
	match nubon_nivel:
		"nivel1":
			if colisionador1.is_colliding() and puede_disparar:
				disparar_rayo()
				puede_disparar = false
				Temporizador.start()
		"nivel2","nivel3":
			for for1 in colisionadores5:
				if for1.is_colliding() and puede_disparar:
					disparar_rayo()
					puede_disparar = false
					Temporizador.start()
		"nivel4":
			for for1 in colisionadores7:
				if for1.is_colliding() and puede_disparar:
					disparar_rayo()
					puede_disparar = false
					Temporizador.start()

func disparar_rayo():
	sonido.play()
	match nubon_nivel:
		"nivel1":
			for for1 in posiciones_disparo1.get_children():
				var nuevo_rayo = rayo.instance()
				nuevo_rayo.crear(for1.global_position)
				owner.get_node("Rayos").add_child(nuevo_rayo)
		"nivel2","nivel3":
			for for1 in posiciones_disparo5.get_children():
				var nuevo_rayo = rayo.instance()
				nuevo_rayo.crear(for1.global_position)
				owner.get_node("Rayos").add_child(nuevo_rayo)
		"nivel4":
			for for1 in posiciones_disparo7.get_children():
				var nuevo_rayo = rayo.instance()
				nuevo_rayo.crear(for1.global_position)
				owner.get_node("Rayos").add_child(nuevo_rayo)

func _on_Timer_timeout():
	puede_disparar = true
