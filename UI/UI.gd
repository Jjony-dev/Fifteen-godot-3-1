extends Control

signal reiniciar

func _ready():
	$Reiniciar.grab_focus()#Hacer que el boton obtenga el foco

#Responde a la señal del boton Reiniciar
func _on_Reiniciar_button_up():
	emit_signal("reiniciar")
