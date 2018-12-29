extends Node2D

export var numero: int#Numero de ficha
var pos: Vector2 setget set_pos, get_pos#Posicion dentro del tablero
const ARRIBA: Vector2 = Vector2(0, -1)
const ABAJO: Vector2 = Vector2(0, 1)
const DERECHA: Vector2 = Vector2(1, 0)
const IZQUIERDA:Vector2 = Vector2(-1, 0)
const DIRECCION = [ARRIBA, ABAJO, DERECHA, IZQUIERDA]
var texturas = [
				"ficha.png",
				"godotlogo.jpg",
				"godette.jpeg"
				]

func _ready():
	$Numero.text = str(numero) #Asigno del numero como texto del Label
	set_textura(texturas[0])
	if numero == 16 : #Para el numero 16 oculto la ficha
		visible = false
		$Numero.visible = false

func set_pos(valor: Vector2):#Asigno la posicion en el tablero
	pos = valor
	#Posiciono la ficha por el ancho del Sprite y la escala de la ficha
	if $Sprite.region_enabled:
		position = $Sprite.region_rect.size * scale * pos
	else:
		position = $Sprite.texture.get_size() * scale * pos
	
func get_pos() -> Vector2:#Obtengo la posicion en el tablero
	return pos

func set_textura(nombre_archivo: String) -> void:#Asigo la textura visible de la pieza
	$Numero.rect_scale = Vector2(2, 2)#Inicializo la escala del Label
	$Sprite.texture = ResourceLoader.load("res://Ficha/Imagenes/" + nombre_archivo)#Cargo el recurso de imagen
	if $Sprite.texture.get_size() > Vector2(64, 64):#Para texturas mayores a 64x64 px divido la imagen por regiones
		scale.x = 256 / $Sprite.texture.get_size().x#Asigno una escala en función del ancho de la textura
		scale.y = 256 / $Sprite.texture.get_size().y#Asigno una escala en función del alto de la textura
		$Sprite.region_rect.size.x = $Sprite.texture.get_size().x / 4#Asigno el ancho de la región en función del ancho de la textura 
		$Sprite.region_rect.size.y = $Sprite.texture.get_size().y / 4#Asigno el alto de la región en función del alto de la textura 
		$Sprite.region_enabled = true
		$Numero.rect_scale /= scale#Revierto la escala aplicada por el padre
	else:
		$Sprite.region_enabled = false
		scale = Vector2(1, 1)#Reestablesco la escala por si fue modificada
	if $Sprite.region_enabled:
		#Asigno la posición de la región en función del número de la ficha
		$Sprite.region_rect.position.x = $Sprite.region_rect.size.x * ((numero - 1) % 4)
		$Sprite.region_rect.position.y = $Sprite.region_rect.size.y * ((numero - 1) / 4)
	