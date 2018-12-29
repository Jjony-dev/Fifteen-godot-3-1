extends Control

signal reiniciar
signal invertir_control
onready var label_ganaste: Label = $Ganaste
onready var label_tiempo: Label = $Tiempo
onready var label_mejor: Label = $Horizontal/Mejor
onready var button_invertir: CheckButton = $Invertir
onready var button_reiniciar: BaseButton = $Horizontal/Reiniciar

func _ready():
	button_reiniciar.grab_focus()#Hacer que el boton obtenga el foco

#Responde a la señal button_up del boton Reiniciar
func _on_Reiniciar_button_up():
	emit_signal("reiniciar")

#Responde a la señal toggled del boton Invertir
func _on_Invertir_toggled(button_pressed):
	emit_signal("invertir_control", button_pressed)