extends Node2D


var age = 0
var fps = 3
export(bool) var active = false
var spriteid
export(int) var active_offset = 1
var rand = randi()%3
var pos_was = 0

func _ready():
    
    pos_was = global_position.y
    if not spriteid:
        spriteid = $Sprite.frame_coords.y
    else:
        $Sprite.frame_coords.y = spriteid

func _process(delta):
    age += delta * fps / 3
    if age >= 1:
        age -= 1
    if pos_was != global_position.y:
        $Timer.start()
        pos_was = global_position.y
        active = true
    var f = int(rand + age*3)%3
    $Sprite.frame_coords.x = f 
    $Sprite.frame_coords.y = spriteid
    if active:
        $Sprite.frame_coords.y += 1


func _on_Timer_timeout():
    active = false
