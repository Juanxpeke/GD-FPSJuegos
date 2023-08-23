class_name TemplateClass
extends Node
# Clase template para tener un consenso de como mantener el codigo consistente
# y ordenadito. En particular, esta es una descripcion de clase (muy omitible xd)
# Cualquier cosa que quieran cambiar u omitir (ej: cambiar el case de las funciones,
# el orden en que se ponen las cosas como signals o enums, u omitir el static typing 
# para funciones), sientanse libres de comentarlo

# Cases tentativos
# ================
# Folders: PascalCase
# Files: snake_case
# Nodes: PascalCase
# Signals: snake_case
# Enums names: PascalCase
# Enums values y consts: CONSTANT_CASE
# Functions y variables: snake_case

# Orden tentativo de declaraciones
# ================================

# Signals
signal my_signal(first_argument, second_argument);

# Enums
enum MyEnum { FIRST_CASE, SECOND_CASE , THIRD_CASE }

# Constantes
const MY_CONSTANT_VALUE = 200

# Export variables (tentativo tenerlas con static typing, es decir, especificando
# el tipo)
@export var my_exported_variable: int = 200

# Variables cualquieras
var my_variable = 200

# Variables onready
@onready var my_onready_variable = 200

# Funciones (tentativo tenerlas con static typing, es decir, especificando el tipo)
# Para activar el static typing automatico de funciones built-in como _ready o
# _process ir a Editor -> Editor Settings... -> Text Editor -> Completion -> Add Type Hints

# Funciones que se sabe que seran privadas (llamadas unicamente por esta clase)
# 1. Primero las built-in como _ready o _process
# 2. Luego las creadas por nosotros

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Called for private stuff
func _my_private_function(my_private_argument: float) -> String:
	return "my_private_returned_value"

# Funciones disenhadas para ser publicas (llamadas por clases amigas)

# Called for public stuff
func my_public_function(my_private_argument: float) -> String:
	return "my_private_returned_value"
