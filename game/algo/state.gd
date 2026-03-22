@abstract
class_name State
extends Node

signal state_changed(new_state: State)

var parent: Node2D


func enter() -> void:
	pass


func exit() -> void:
	pass


func process_input(_event: InputEvent) -> State:
	return null


func process_frame(_delta: float) -> State:
	return null


func process_physics(_delta: float) -> State:
	return null
