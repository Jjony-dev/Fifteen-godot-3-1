extends Control

signal reiniciar
signal invertir_control

func _ready():
	$Reiniciar.grab_focus()#Hacer que el boton obtenga el foco

#Responde a la señal button_up del boton Reiniciar
func _on_Reiniciar_button_up():
	emit_signal("reiniciar")

#Responde a la señal toggled del boton Reiniciar
func _on_Invertir_toggled(button_pressed):
	emit_signal("invertir_control", button_pressed)