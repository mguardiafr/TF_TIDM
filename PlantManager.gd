extends Node
#Aquí anirà la generació de plantes
signal to_inventory

var Planta = preload("res://src/Actors/Plant.tscn")
# Diccionari = {"id" : ["nom planta", HP inicial, "tipus", "color"],...} 
var Ecosystem = {
	0:{name = "Bleda", hp = 70, type = "vegetable", color = "green"}, 
	1:{name = "Tomàquet", hp = 50, type = "vegetable", color = "red"}, 
	2:{name = "Col", hp = 60, type = "vegetable", color = "blue"}
}
# crear diccionari on s'emmagatzemin les plantes creades
var next_id = 0
var habitat = {} # List of plants currently onscreen
 # TODO randomitzar quin tipus de planta es crea
func _ready(): #TODO ara mateix aquesta func només s'executa UNA VEGADA. Canviar pq s'executi quan llegeix la senyal harvest
	create_plant()
	
	
func _process(delta):
	if Input.is_action_just_pressed("debug_plant"):
		create_plant()
	
# TODO Crear diferents tipus de plantes des del plant manager	
	
func create_plant():
	var nova_planta = Planta.instance() # Afegeix una nova planta a la llista de plantes existents
	var selected_plant = randi() % Ecosystem.size() #tria un numero random del 0 al (total de plantes existents)
	nova_planta.hp = Ecosystem[selected_plant]["hp"] #
	nova_planta.name_plant = Ecosystem[selected_plant]["name"] #
	nova_planta.num_crop = next_id #Es una script variable que cal exportar!
	habitat[next_id] = nova_planta #afegim la nova planta a la llista de plants
	add_child(nova_planta)
	nova_planta.connect("harvested", self, "on_plant_harvested", [next_id])
	next_id += 1
	
	
func on_plant_harvested(id):
	var plant = habitat[id]
	print("S'ESTA CRIDANT")
	# emit_signal("to_inventory", plant.tipus Arguments que diguin el tipus de la planta)
	plant.queue_free() # elimina la planta de pantalla
	habitat.erase(id) # elimina la planta del diccionari
	# gestionar inventari: aquí o en funció dedicada? -> Enviar signal a un altre script. 
	# Caldrà que manager i inventari siguin germans i hi hagi un pare que els gestioni
