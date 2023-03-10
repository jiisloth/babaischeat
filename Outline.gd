extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    texture = load(get_parent().texture.resource_path.split(".")[0] + "outline.png")
    vframes = get_parent().vframes
    hframes = get_parent().hframes
    frame = get_parent().frame


func _process(delta):
    frame = get_parent().frame
