extends Node
class_name State, "state.png"

# warning-ignore:unused_signal
signal finished(next_state_name)

# Iniciar el estado
func enter():
	pass

# Esto se ejecuta al cambiar de estado
func exit():
	pass

# Manejar entradas
func handleInput(_event):
	pass

# Bucle
func update(_delta):
	pass

# Cuando termina una animación, deberian llamar a esto
func _onAnimationFinished(_anim_name):
	pass
