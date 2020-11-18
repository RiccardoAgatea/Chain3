extends Node

var resources := {}


func add_resources(new_resources: Dictionary):
	for res in new_resources:
		if res in resources:
			resources[res] += new_resources[res]
		else:
			resources[res] = new_resources[res]
