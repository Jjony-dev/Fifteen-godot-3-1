extends Node

var mejor_tiempo: float
var tiempo: float

func _ready():
	cargar()
	$UI/Mejor.text = "Mejor Tiempo: " + str(mejor_tiempo).substr(0, 4)
	tiempo = 0

func _process(delta):
	if !$UI/Ganaste.visible:#Si el label Ganaste no es visible se esta jugando
		tiempo += delta
		$UI/Tiempo.text = str(tiempo).substr(0, 4)

#Funcion que responde a la señal reiniciar que emite UI
func _on_UI_reiniciar() -> void:
	$UI/Ganaste.visible = false
	tiempo = 0
	$Tablero.iniciar()

#Funcion que responde a la señal ganar que emite Tablero
func _on_Tablero_ganar() -> void:
	$UI/Ganaste.visible = true#Hace visible el Label de Ganar
	if tiempo < mejor_tiempo:#Comprueba si se mejoro el tiempo
		mejor_tiempo = tiempo
		guardar(mejor_tiempo)
		$UI/Mejor.text = "Mejor Tiempo: " + str(tiempo).substr(0, 4)

#Guarda en un archivo el valor pasado como "mejor_tiempo" con estructura json
func guardar(menor_tiempo: float) -> void:
    var archivo = File.new()
    archivo.open("user://highscore.sav", File.WRITE)
    var datos: Dictionary = {"mejor_tiempo": menor_tiempo}
    archivo.store_line(to_json(datos))
    archivo.close()

#Carga el archivo que guarda el mejor tiempo
func cargar() -> void:
	var archivo = File.new()
	if not archivo.file_exists("user://highscore.sav"):#Si el archivo no existe asigno un valor por defecto
		mejor_tiempo = 999
		return
	archivo.open("user://highscore.sav", File.READ)
	var dato = parse_json(archivo.get_line())
	if dato && float(dato["mejor_tiempo"]):#Si el dato no es nulo y se puede convertir en float
		mejor_tiempo = dato["mejor_tiempo"]
	else:
		mejor_tiempo = 999
	archivo.close()

func _on_UI_invertir_control(invertir: bool) -> void:
	$Tablero.invertir_control(invertir)
