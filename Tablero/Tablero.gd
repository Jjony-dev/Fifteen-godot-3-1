extends Node2D

signal ganar

const Ficha = preload("res://Ficha/Ficha.gd")
var tamanio: Vector2 = Vector2(4, 4)
var posiciones = []
var vacio: Ficha
var gano = false
var control: int = -1

func _ready():
	randomize()
	#Defino las posiciones del tablero segun el tamaño 
	for j in tamanio.y:
		for i in tamanio.x:
			posiciones.append(Vector2( i, j))
	vacio = get_children()[get_child_count() - 1] as Ficha
	iniciar()

func iniciar():
	var textura: int = randi() % vacio.texturas.size()
	gano = false#Controla si el juego continua
	var fichas = get_children()
	for f in get_children().size():
		fichas[f].set_textura(fichas[f].texturas[textura])
		fichas[f].set_pos(posiciones[f])
	vacio.visible = false
	mezclar()

#Desordeno las fichas realizando movimientos aleatorios
func mezclar() -> void:
	var movimientos = 400 + randi() % 100 * tamanio.x * tamanio.y #Para un tablero de 4x4 entre 400 y 2000 movimientos
	for m in movimientos:
		var vecino: Ficha
		var d = randi() % 4#Direccion aleatoria del movimiento
		vecino = vecino(vacio.DIRECCION[d])
		if vecino:
			permutar(vacio, vecino)

#Devuelve la ficha vecina en la direccion indicada o null si no tiene
func vecino(direccion: Vector2) -> Ficha:
	for f in get_children():
				if vacio.pos.x - f.pos.x == control * direccion.x && vacio.pos.y - f.pos.y == control * direccion.y:
					return f
	return null
	
#Intercambia las posiciones dos fichas 
func permutar(f1: Ficha, f2: Ficha) -> void:
	var temp: Vector2 = f1.pos
	f1.pos = f2.pos
	f2.pos = temp
	
func _input(event):
	if OS.get_name() == "Android" || OS.get_name() == "iOS":
		if event as InputEventScreenTouch && !gano && event.is_pressed():
			var vecino: Ficha
			
			if event.position.y > global_position.y && event.position.y < global_position.y + 256:
				if event.position.y > vacio.global_position.y && event.position.x > vacio.global_position.x && event.position.x < vacio.global_position.x + 64:
					vecino = vecino(vacio.ABAJO)
					if vecino:
						permutar(vacio, vecino)
				if event.position.y < vacio.global_position.y && event.position.x > vacio.global_position.x && event.position.x < vacio.global_position.x + 64 :
					vecino = vecino(vacio.ARRIBA)
					if vecino:
						permutar(vacio, vecino)
				if event.position.x > vacio.global_position.x && event.position.y > vacio.global_position.y && event.position.y < vacio.global_position.y + 64:
					vecino = vecino(vacio.DERECHA)
					if vecino:
						permutar(vacio, vecino)
				if event.position.x < vacio.global_position.x && event.position.y > vacio.global_position.y && event.position.y < vacio.global_position.y + 64:
					vecino = vecino(vacio.IZQUIERDA)
					if vecino:
						permutar(vacio, vecino)
		if ha_ganado():#Compruba si el jugador gano
			gano = true
			emit_signal("ganar")#Emite la señal de que gano
	else:
		if  event is InputEventKey && !gano && event.is_pressed():#Responde a la entrada si no se gano
			var vecino: Ficha
			
			if Input.is_action_just_pressed("ui_down"):
				vecino = vecino(vacio.ABAJO)
				if vecino:
					permutar(vacio, vecino)
			if Input.is_action_just_pressed("ui_up"):
				vecino = vecino(vacio.ARRIBA)
				if vecino:
					permutar(vacio, vecino)
			if Input.is_action_just_pressed("ui_right"):
				vecino = vecino(vacio.DERECHA)
				if vecino:
					permutar(vacio, vecino)
			if Input.is_action_just_pressed("ui_left"):
				vecino = vecino(vacio.IZQUIERDA)
				if vecino:
					permutar(vacio, vecino)
		if ha_ganado():#Compruba si el jugador gano
			gano = true
			emit_signal("ganar")#Emite la señal de que gano
	
#Devuevo verdadero si todas las fichas estan en su posicion
func ha_ganado() -> bool:
	var fichas = get_children()
	for f in fichas:
		if f.numero == vacio.numero:#Si llega a la ultima ficha
			vacio.visible = true
			return true
		#Compruebo si una ficha no esta en el lugar que le corresponde
		if int(f.pos.x) != (f.numero - 1) % int(tamanio.x) || int(f.pos.y) != (f.numero - 1) / int(tamanio.x):
			return false
	return true
	
#Cambia el sentido en que se mueven las fichas
func invertir_control(var invertir: bool) -> void:
	control = 1 if invertir	else -1
