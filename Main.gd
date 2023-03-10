extends CanvasLayer

var actions = []
var windowsize = OS.get_window_size()

export(PackedScene) var Run

var running

func _ready():
    SaveLoad.load_data()
    if SaveLoad.data["currentpath"] != "":
        read_file(SaveLoad.data["currentpath"])

func _on_Start_pressed():
    running = Run.instance()
    running.actions = actions
    $Scroll/Run.add_child(running)
    $Menu.hide()
    $AnimationPlayer.play("Move stuff")


func _on_Record_pressed():
    pass # Replace with function body.


func _on_SelectFile_pressed():
    windowsize = OS.get_window_size()
    get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,SceneTree.STRETCH_ASPECT_KEEP, Vector2(320,160))
    OS.set_window_size(Vector2(320, 160)*2)
    $FileDialog.popup_centered(Vector2(320, 160))

    
func _on_FileDialog_popup_hide():
    get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,SceneTree.STRETCH_ASPECT_KEEP, Vector2(32*3,160))
    OS.set_window_size(windowsize)


func _on_FileDialog_file_selected(path):
    read_file(path)



func read_file(p):
    $Menu/Namehodl/Filename.text = "No file"
    $Menu/Start.disabled = true
    
    var file = File.new()
    var content = null
    if file.file_exists(p):
        file.open(p, File.READ)
        content = file.get_as_text()
        file.close()
    else:
        return false
        
    if not content:
        error_in_file("all")
        return false
    
    actions = []
    var lines = content.split("\n")
    
    for line in lines:
        if len(line) > 1:
            if line[0] in "1234567890*" and line[1] in "1234567890*":
                actions.append(line[0] + line[1])
            else:
                for c in line:
                    if c.to_upper() in "WASD":
                        actions.append(c)
                    elif c != " ":
                        error_in_file(" " + c)
                        return false
    $Menu/Namehodl/Filename.text = p.get_file()
    $Menu/Start.disabled = false
    SaveLoad.data["currentpath"] = p
    SaveLoad.save_data()
    return true


func error_in_file(c):
    $AcceptDialog.dialog_text = "FILE IS ERROR\n          IS\n :'(       " + c
    $AcceptDialog.popup_centered()


func _on_AcceptDialog_confirmed():
    windowsize = OS.get_window_size()
    get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,SceneTree.STRETCH_ASPECT_KEEP, Vector2(320,160))
    OS.set_window_size(Vector2(320, 160)*2)
    $FileDialog.popup_centered(Vector2(320, 160))



func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Move stuff":
        running.animate_start()
        $Scroll/Back.hide()
        $Scroll/Is.hide()
        $Scroll/Level.hide()
