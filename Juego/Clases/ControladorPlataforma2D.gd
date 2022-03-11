extends KinematicBody2D

# Configúrelos con el nombre de su acción (en el mapa de entrada)
export var entrada_izquierda : String = "Izquierda"
export var entrada_derecha : String = "Derecha"
export var entrada_saltar : String = "Saltar"

export var fuerza_rebote_techo = 350
# La altura máxima del salto en píxeles (manteniendo el salto)
export var max_altura_salto = 150 setget establecer_max_altura_salto
# La altura mínima del salto (salto con golpecitos)
export var min_altura_salto = 40 setget establecer_min_altura_salto
# La altura de tu salto en el aire
export var altura_doble_salto = 100 setget establecer_altura_doble_salto
# Cuánto tiempo se tarda en llegar a la cima del salto en segundos
export var max_altura_duracion_salto = 0.3 setget establecer_max_altura_duracion_salto
# Multiplica la gravedad por esto mientras cae
export var multiplicador_gravedad_descendente = 1.5
# Establecer en 2 para salto doble
export var cantidad_max_saltos = 1
export var max_aceleracion = 4000
export var friccion = 8
export var puede_apretar_saltar : bool = false
# Todavía puedes saltar tantos segundos después de caerte de una repisa.
export var temporizador_saltar : float = 0.1
# Solo es necesario cuando puede_apretar_saltar esta desactivado
# Presionar saltar tantos segundos antes de golpear el suelo aún te hará saltar.
export var bufer_saltar : float = 0.1




# no usado
var velocidad_maxima = 100
var tiempo_aceleracion = 10
var ha_muerto = true
var salud = 3


# Estos se calcularán automáticamente
var gravedad_por_defecto : float
var velocidad_salto : float
var velocidad_doble_salto : float
# Multiplica la gravedad por esto cuando soltamos el salto
var lanzamiento_multiplicador_gravedad : float



var saltos_disponibles : int
var aprentando_saltar := false

var velocidad = Vector2()
var aceleracion = Vector2()

# ONREADY VARS
onready var animaciones = $Animaciones
onready var audio_salto = $Audio_Saltar
onready var audio_caida = $Audio_Caida
onready var camara = $Camara
onready var temporizador_saltando = Timer.new()
onready var temporizador_bufer_saltar = Timer.new()

func _ready():
	gravedad_por_defecto = calcular_gravedad(max_altura_salto, max_altura_duracion_salto)
	velocidad_salto = calcular_velocidad_salto(max_altura_salto, max_altura_duracion_salto)
	velocidad_doble_salto = calcular_velocidad_salto_doble(altura_doble_salto, gravedad_por_defecto)
	lanzamiento_multiplicador_gravedad = calcular_lanzamiento_multiplicador_gravedad(velocidad_salto, min_altura_salto)
	
	print("doble velocid4d de salto = ", velocidad_doble_salto)
	print("velocid4d de salto = ", velocidad_salto)
	
	add_child(temporizador_saltando)
	temporizador_saltando.wait_time = temporizador_saltar
	temporizador_saltando.one_shot = true
	
	add_child(temporizador_bufer_saltar)
	temporizador_bufer_saltar.wait_time = bufer_saltar
	temporizador_bufer_saltar.one_shot = true
	

func _physics_process(delta):
	aceleracion.x = 0
	
	if is_on_floor():
		temporizador_saltando.start()
	if not temporizador_saltando.is_stopped():
		saltos_disponibles = cantidad_max_saltos
	
	tomar_direccion()
	chocar_techo()
	# Compruebe si hay saltos en el suelo cuando podamos mantener el salto
	if puede_apretar_saltar:
		if Input.is_action_pressed(entrada_saltar):
			# No use doble salto cuando mantenga presionado
			if is_on_floor():
				saltar()
	
	# Compruebe si hay saltos en el suelo cuando no podemos mantener el salto.
	if not puede_apretar_saltar:
		if not temporizador_bufer_saltar.is_stopped() and is_on_floor():
			saltar()
	
	# Compruebe si hay saltos en el aire
	if Input.is_action_just_pressed(entrada_saltar):
		aprentando_saltar = true
		temporizador_bufer_saltar.start()
		
		# Solo salta en el aire cuando presionas el botón, el código anterior ya salta cuando estamos conectados a tierra
		if not is_on_floor():
			saltar()
		
	
	if Input.is_action_just_released(entrada_saltar):
		aprentando_saltar = false
	
	
	var gravedad = gravedad_por_defecto
	
	if velocidad.y > 0: # Si nosotros estamos cayendo
		gravedad *= multiplicador_gravedad_descendente
		
	if not aprentando_saltar and velocidad.y < 0: # Si lo soltamos saltamos y seguimos subiendo.
		if not saltos_disponibles < cantidad_max_saltos - 1: # Siempre salte a la altura máxima cuando estemos usando un salto doble
			gravedad *= lanzamiento_multiplicador_gravedad # multiplica la gravedad para que tengamos un salto más bajo
	
	aceleracion.y = -gravedad
	velocidad.x *= 1 / (1 + (delta * friccion))
	
	velocidad += aceleracion * delta
	velocidad = move_and_slide(velocidad, Vector2.UP)



func calcular_gravedad(max_altura_salto2, max_altura_duracion_salto2):
	# Calcula la gravedad deseada observando la altura y la duración del salto.
	# La fórmula es de este video https://www.youtube.com/watch?v=hG9SzQxaCm8
	return (-2 * max_altura_salto2) / pow(max_altura_duracion_salto2, 2)


func calcular_velocidad_salto(max_altura_salto2, max_altura_duracion_salto2):
	# Calcula la velocidad de salto deseada mirando la altura y la duración del salto.
	return (2 * max_altura_salto2) / (max_altura_duracion_salto2)


func calcular_velocidad_salto_doble(max_altura_salto2, gravedad):
	# Calcula la velocidad del salto a partir de la altura del salto y la gravedad.
	# La fórmula es de
	# https://sciencing.com/acceleration-velocity-distance-7779124.html#:~:text=in%20every%20step.-,Starting%20from%3A,-v%5E2%3Du
	return sqrt(-2 * gravedad * max_altura_salto2)


func calcular_lanzamiento_multiplicador_gravedad(velocidad_salto2, min_altura_salto2):
	# Calcula la gravedad cuando se suelta la tecla en función de la altura mínima del salto y la velocidad del salto.
	# La fórmula es de https://sciencing.com/acceleration-velocity-distance-7779124.html
	var lanzamiento_gravedad = 0 - pow(velocidad_salto2, 2) / (2 * min_altura_salto2)
	return lanzamiento_gravedad / gravedad_por_defecto

"""
func calcular_friccion(tiempo_al_max):
	# La fórmula es de https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3
	# esta fricción alcanzará el 90% de la velocidad máxima después del tiempo de aceleración
	return 1 - (2.30259 / tiempo_al_max)


func calcular_velocidad(velocidad_maxima2, friccion2):
	# La fórmula es de https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3	
	return (velocidad_maxima2 / friccion2) - velocidad_maxima2
"""

func tomar_direccion():
	if Input.is_action_pressed(entrada_izquierda):
		aceleracion.x = -max_aceleracion
	if Input.is_action_pressed(entrada_derecha):
		aceleracion.x = max_aceleracion
		

func saltar():
	if saltos_disponibles == cantidad_max_saltos and temporizador_saltando.is_stopped():
		# Su primer salto debe usarse cuando esté en el suelo
		# Si te caes del suelo y luego saltas, estarás usando tu segundo salto.
		print("Usando segundo salto")
		saltos_disponibles -= 1
		
	if saltos_disponibles > 0:
		if saltos_disponibles < cantidad_max_saltos: # If we are double jumping
			velocidad.y = -velocidad_doble_salto
		else:
			velocidad.y = -velocidad_salto
		saltos_disponibles -= 1
	
	temporizador_saltando.stop()

func caida_al_vacio():
	if global_position.y-200 > camara.limit_bottom:
		reaparecer()

func chocar_techo():
	if is_on_ceiling():
		aceleracion.y = fuerza_rebote_techo

func reaparecer():
	get_tree().reload_current_scene()

func herir_jugador(herirMonto = 1):
	if salud == 3:
		salud -= herirMonto
		aceleracion.y = 0
		aceleracion.y -= min_altura_salto
		aceleracion.x *= -1
	elif salud == 2:
		salud -= herirMonto
		aceleracion.y = 0
		aceleracion.y -= min_altura_salto
		aceleracion.x *= -1
	else:
		ha_muerto = true

func establecer_max_altura_salto(valor):
	max_altura_salto = valor
	
	gravedad_por_defecto = calcular_gravedad(max_altura_salto, max_altura_duracion_salto)
	velocidad_salto = calcular_velocidad_salto(max_altura_salto, max_altura_duracion_salto)
	velocidad_doble_salto = calcular_velocidad_salto_doble(altura_doble_salto, gravedad_por_defecto)
	lanzamiento_multiplicador_gravedad = calcular_lanzamiento_multiplicador_gravedad(velocidad_salto, min_altura_salto)


func establecer_max_altura_duracion_salto(valor):
	max_altura_duracion_salto = valor
	
	gravedad_por_defecto = calcular_gravedad(max_altura_salto, max_altura_duracion_salto)
	velocidad_salto = calcular_velocidad_salto(max_altura_salto, max_altura_duracion_salto)
	velocidad_doble_salto = calcular_velocidad_salto_doble(altura_doble_salto, gravedad_por_defecto)
	lanzamiento_multiplicador_gravedad = calcular_lanzamiento_multiplicador_gravedad(velocidad_salto, min_altura_salto)


func establecer_min_altura_salto(valor):
	min_altura_salto = valor
	
	lanzamiento_multiplicador_gravedad = calcular_lanzamiento_multiplicador_gravedad(velocidad_salto, min_altura_salto)


func establecer_altura_doble_salto(valor):
	altura_doble_salto = valor
	
	velocidad_doble_salto = calcular_velocidad_salto_doble(altura_doble_salto, gravedad_por_defecto)
