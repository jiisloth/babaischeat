extends Sprite

var age = 0
var fps = 3
export(bool) var active = false
var spriteid = 0
export(int) var active_offset = 1
var rand = randi()%3
var do_woble = true

func _ready():
    spriteid = frame_coords.y

func _process(delta):
    age += delta * fps / 3
    if age >= 1:
        age -= 1
    if not do_woble:
        return
    var f = int(rand + age*3)%3
    frame_coords.x = f 
    frame_coords.y = spriteid
    if active:
        frame_coords.y += 1
