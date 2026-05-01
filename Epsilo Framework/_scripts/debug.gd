extends PanelContainer

@onready var property_container = $MarginContainer/VBoxContainer

var properties = {}
var frames_per_second : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_global.debug = self
	
	visible = false

	#add_debug_property("FPS", frames_per_second)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	# Toggle debug panel
	if event.is_action_pressed("debug"):
		visible = !visible

func add_property(title : String, value, order):
	var label
	
	if properties.has(title):
		label = properties[title]
	else:
		label = Label.new()
		property_container.add_child(label)
		label.name = title
		properties[title] = label
	label.text = title + ": " + str(value)
	property_container.move_child(label, order)
	#var label = Label.new()
	#property_container.add_child(label)
	#label.name = title
	#properties[title] = label

func _process(delta):
	if _global.debug != null:
		_global.debug.add_property("FPS: ", Engine.get_frames_per_second(), 0)
	
