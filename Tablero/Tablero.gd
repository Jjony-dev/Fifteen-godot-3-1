extends Node2D

signal ganar

var tamanio: Vector2 = Vector2(4, 4)
var posiciones = []
var vacio: Node2D
var gano = false
var control: int = -1

func _ready():
	randomize()
	#Defino las posiciones del tablero segun el tamaño 
	for j in tamanio.y:
		for i in tamanio.x:
			posiciones.append(Vector2( i, j))
	vacio = get_children()[get_child_count() - 1]
	iniciar()

func iniciar():
	gano = false#Controla si el juego continua
	var fichas = get_children()
	for f in get_children().size():
		fichas[f].set_pos(posiciones[f])
	mezclar()

#Desordeno las fichas realizando movimientos aleatorios
func mezclar() -> void:
	var movimientos = 400 + randi() % 100 * tamanio.x * tamanio.y #Para un tablero de 4x4 entre 400 y 2000 movimientos
	for m in movimientos:
		var vecino: Node2D
		var d = randi() % 4#Direccion aleatoria del movimiento
		vecino = vecino(vacio.DIRECCION[d])
		if vecino:
			permutar(vacio, vecino)

#Devuelve la ficha vecina en la direccion indicada o null si no tiene
func vecino(direccion: Vector2) -> Node2D:
	for f in get_children():
				if vacio.get_pos().x - f.get_pos().x == control * direccion.x && vacio.get_pos().y - f.get_pos().y == control * direccion.y:
					return f
	return null
	
#Intercambia las posiciones dos fichas 
func permutar(f1, f2) -> void:
	var temp = f1.get_pos()
	f1.set_pos(f2.get_pos())
	f2.set_pos(temp)
	
func _input(event):
	if  event is InputEventKey && !gano && event.is_pressed():#Responde a la entrada si no se gano
		var vecino: Node2D
		
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
			return true
		#Compruebo si una ficha no esta en el lugar que le corresponde
		if int(f.get_pos().x) != (f.numero - 1) % int(tamanio.x) || int(f.get_pos().y) != (f.numero - 1) / int(tamanio.x):
			return false
	return true
	
func invertir_control(var invertir: bool) -> void:
	if invertir:
		control = 1
	else:
		control = -1

#NO FUNCIONA:Puede provocar permutacion impar
#Asigna las posiciones al azar
#func asignar_celda(f: Node2D):
#	if posiciones.size() > 0 :
#		var aleatorio = randi() % posiciones.size()
#		f.set_pos(posiciones[aleatorio])
#		posiciones.remove(aleatorio)