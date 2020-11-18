extends Panel

# Resource types
onready var resources := load_resources()

# Resources layout
onready var res_container := $CenterContainer/Panel/MarginContainer/VBoxContainer/VBoxContainer

# Resource Tabs
const RESOURCE_TAB := preload("res://scenes/ResourceTab.tscn")

# Close signal
signal close


func load_resources() -> Dictionary:
	var file := File.new()
	if file.open("res://config/resources.json", File.READ) != OK:
		print("nou resources")

	var dict := {}
	for res in JSON.parse(file.get_as_text()).result:
		var name: String = res["name"]
		dict[name] = res.duplicate(true)
		dict[name]["name"] = name.capitalize()
		dict[name]["count"] = 0

	return dict


func add_resources(new_resources: Dictionary):
	for res_name in new_resources:
		resources[res_name]["count"] += new_resources[res_name]


func resource_ordering(res1: String, res2: String) -> bool:
	return resources[res1]["order"] < resources[res2]["order"]


func show():
	var res_names := resources.keys()
	res_names.sort_custom(self, "resource_ordering")
	for res_name in res_names:
		var res: Dictionary = resources[res_name]

		if res["count"] == 0:
			continue

		var tab := RESOURCE_TAB.instance()
		tab.set_info(res["sprite"], res["name"], res["count"])
		res_container.add_child(tab)

	.show()


func hide():
	for tab in res_container.get_children():
		tab.queue_free()

	.hide()


func _on_Button_pressed():
	emit_signal("close")
