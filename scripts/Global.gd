extends Node

var resources := {}


func add_resources(new_resources: Dictionary):
	for res_name in new_resources:
		if res_name in resources:
			resources[res_name].count += new_resources[res_name].count
		else:
			resources[res_name] = {"count": new_resources[res_name].count}
