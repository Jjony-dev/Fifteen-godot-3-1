extends Node

const UI =  preload("res://UI/UI.gd")
const Tablero =  preload("res://Tablero/Tablero.gd")
onready var ui: UI = $UI
onready var tablero: Tablero = $Fondo/Tablero
var mejor_tiempo: float
var tiempo: float

func _ready():
	cargar()
	ui.label_mejor.text = "Mejor Tiempo: " + str(mejor_tiempo).substr(0, 4)
	tiempo = 0

func _process(delta):
	if !ui.label_ganaste.visible:#Si el label Ganaste no es visible se esta jugando
		tiempo += delta
		ui.label_tiempo.text = str(tiempo).substr(0, 4)

#Funcion que responde a la señal reiniciar que emite UI
func _on_UI_reiniciar() -> void:
	ui.label_ganaste.visible = false
	tiempo = 0
	tablero.iniciar()

#Funcion que responde a la señal ganar que emite Tablero
func _on_Tablero_ganar() -> void:
	ui.label_ganaste.visible = true#Hace visible el Label de Ganar
	if tiempo < mejor_tiempo:#Comprueba si se mejoro el tiempo
		mejor_tiempo = tiempo
		guardar(mejor_tiempo)
		ui.label_mejor.text = "Mejor Tiempo: " + str(tiempo).substr(0, 4)

#Guarda en un archivo el valor pasado como "mejor_tiempo" con estructura json
func guardar(menor_tiempo: float) -> void:
	var archivo: File = File.new()
	archivo.open("user://highscore.sav", File.WRITE)
	var datos: Dictionary = {"mejor_tiempo": menor_tiempo}
	archivo.store_line(to_json(datos))
	archivo.close()

#Carga el archivo que guarda el mejor tiempo
func cargar() -> void:
	var archivo: File = File.new()
	if not archivo.file_exists("user://highscore.sav"):#Si el archivo no existe asigno un valor por defecto
		mejor_tiempo = 999
		return
	archivo.open("user://highscore.sav", File.READ)
	var dato: Dictionary = parse_json(archivo.get_line())
	if dato && float(dato["mejor_tiempo"]):#Si el dato no es nulo y se puede convertir en float
		mejor_tiempo = dato["mejor_tiempo"]
	else:
		mejor_tiempo = 999
	archivo.close()

#Funcion que responde a la señal invertir_control que emite UI
func _on_UI_invertir_control(invertir: bool) -> void:
	tablero.invertir_control(invertir)
