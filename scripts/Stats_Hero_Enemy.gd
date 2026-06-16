extends Resource 

class_name Stats



@export var name : String
@export var health : int
@export var max: int
@export var dmg : int
@export var attack: bool
@export var explosion: bool


func damage(amount: int):
		health-=amount
		
func restore():
	health = max
		
