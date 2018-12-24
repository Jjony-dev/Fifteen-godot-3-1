extends Node2D

export var numero: int#Numero de ficha
var _pos: Vector2#Posicion dentro del tablero
const ARRIBA: Vector2 = Vector2(0, -1)
const ABAJO: Vector2 = Vector2(0, 1)
const DERECHA: Vector2 = Vector2(1, 0)
const IZQUIERDA:Vector2 = Vector2(-1, 0)
const DIRECCION = [ARRIBA, ABAJO, DERECHA, IZQUIERDA]

func _ready():
	$Numero.text = str(numero) #Asigno del numero como texto del Label
	if numero == 0 : #Para el numero 0 oculto la ficha
		visible = false

func set_pos(valor: Vector2):#Asigno la posicion en el tablero
	_pos = valor
	#Posiciono la ficha por el ancho del Sprite y la escala de la ficha
	position.x = $Sprite.texture.get_size().x * scale.x * _pos.x
	position.y = $Sprite.texture.get_size().y * scale.y * _pos.y
	
func move(direccion: Vector2):#Muevo la ficha por unidades en el tablero
	position += direccion * $Sprite.texture.get_size()
	
func get_pos() -> Vector2:#Obtengo la posicion en el tablero
	return _pos