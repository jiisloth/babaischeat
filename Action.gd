extends Node2D

var special = false
var number = false
var active = false
var undo = false
var creature = false
var value = ""
var age = 0
var fps = 3
var rand = randi()%3

const size = 32
const active_at = 4

func _ready():
    if special:
        set_special()
        return
    number = false
    undo = false
    if len(value) == 2:
        number = true
    if value == "":
        undo = true
    if special:
        set_special()
        return
    if undo:
        set_undo()
    elif number:
        set_up_number()
    else:
        set_up_arrow()


func _process(delta):
    age += delta * fps / 3
    if age >= 1:
        age -= 1

    if global_position.y > -size/2:
        var frame = int(rand + age*3)%3 

        $Control.frame_coords.x = frame
        $Number1.frame_coords.x = frame
        $Number2.frame_coords.x = 2-((frame+1)%3)
    if not active and global_position.y > size*active_at:
        activate()
    if active and (global_position.y < size*active_at or global_position.y > size*(active_at+1)):
        deactivate()
        
func set_up_number():
    $Control.hide()
    var tens = value[0]
    if tens.is_valid_integer():
        $Number1.frame_coords.y = int(tens)*2
    else:
        $Number1.frame_coords.y = 20
    var ones = value[1]
    if ones.is_valid_integer():
        $Number2.frame_coords.y = int(ones)*2
    else:
        $Number2.frame_coords.y = 20


func set_up_arrow():
    $Number1.hide()
    $Number2.hide()
    match value:
        "W":
            $Control.frame_coords.y = 0
        "A":
            $Control.frame_coords.y = 2
        "S":
            $Control.frame_coords.y = 4
        "D":
            $Control.frame_coords.y = 6
        
func set_undo():
    undo = true
    number = false
    $Number1.hide()
    $Number2.hide()
    $Control.show()
    $Control.frame_coords.y = 8
    
func activate():
    active = true
    $Control.frame_coords.y += 1
    $Number1.frame_coords.y += 1
    $Number2.frame_coords.y += 1
                
func deactivate():
    active = false
    $Control.frame_coords.y -= 1
    $Number1.frame_coords.y -= 1
    $Number2.frame_coords.y -= 1
    
        
func set_special():
    $Number1.hide()
    $Number2.hide()
    $Control.show()
    $Control.frame_coords.y = value
    if value >= 22:
        creature = true
