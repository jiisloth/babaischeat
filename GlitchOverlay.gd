extends ColorRect

var age = 0
var current_value = 1.0

func _process(delta):
    if not visible:
        return
    age += delta
    if age < 0.5:
        material.set_shader_param("shift", 10.0*(1.0-age))
        return
    if randf() > 0.6:
        if randf() > 0.95:
            current_value = 10.0 * randf()
        else:
            current_value = (0.5+sin(age*0.01)/2.0)
            if randf() > 0.9:
                age += 5*randf()
        
        material.set_shader_param("shift", current_value)
        
        
