extends Node2D

export(PackedScene) var Act
export(PackedScene) var Creature

var actions = []
var current = 0
var errors = 0

var bgcolors = [
    "#0b0a0f",
    "#15181f",
    "#080808",
   ]
var bgc = 0

var what = 0
var actions_done = 0
var starttime = 0

var ready_to_start = false
var saved = false

enum meter {
    ACTIONS,
    APM,     
    TIME,    
    STREAK,  
    FAILS,   
    HSTIME,  
    HSSTREAK,
    HSFAILS,
    LOOP,
    SHUT,
    LOOPBACK,
   }

var meters = {
    meter.ACTIONS:    {"value": 0, "leds": "10001"},
    meter.APM:        {"value": 0, "leds": "10010"},   
    meter.TIME:       {"value": 0, "leds": "10101"},    
    meter.STREAK:     {"value": 0, "leds": "10110"},  
    meter.FAILS:      {"value": 0, "leds": "10111"},   
    meter.HSTIME:     {"value": 0, "leds": "11001"},  
    meter.HSSTREAK:   {"value": 0, "leds": "11010"},
    meter.HSFAILS:    {"value": 0, "leds": "11011"},
    meter.LOOP:       {"value": -1, "leds": "11111"},
    meter.SHUT:       {"value": -2, "leds": "00000"},
   }
var current_meter = meter.ACTIONS

func _ready():
    SaveLoad.init_high_score()
    meters[meter.HSTIME]["value"] = SaveLoad.get_hs("time")
    meters[meter.HSSTREAK]["value"] = SaveLoad.get_hs("streak")
    meters[meter.HSFAILS]["value"] = SaveLoad.get_hs("fails")
    
    create_notes()
    
    
func animate_start():
    $Back.show()
    $What/Level.show()
    $What/Cheat.show()
    $What/Undo.show()
    $Scrolls/Errors.show()
    $Is.show()
    $Tween.interpolate_property($Scrolls/Scroll, "position:y", -16, 144, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.2)
    $Tween.start()
    $Scrolls/Scroll.show()
    $Ready.start(0.7)


func create_notes():
    meters[meter.ACTIONS]["value"] = len(actions)-current+errors
    var index = 0
    for action in actions:
        var a = Act.instance()
        a.value = action
        a.position.y = index*(-32)
        $Scrolls/Scroll.add_child(a)
        index += 1
    add_specials(index)
        
    var a = Act.instance()
    a.position.y = (errors+1)*(32)
    $Scrolls/Errors.add_child(a)
    

func add_specials(index):
    var a = Act.instance()
    a.value = 14
    a.position.y = index*(-32)
    a.special = true
    $Scrolls/Scroll.add_child(a)
    index += 1
    a = Creature.instance()
    a.spriteid = 22
    a.position.y = index*(-32)
    $Scrolls/Scroll.add_child(a)

func _process(delta):
    if Input.is_action_just_pressed("TAB"):
        current_meter += 1
        if current_meter == meter.LOOPBACK:
            current_meter = 0
    set_numbers()
    if not ready_to_start:
        return
    if current == len(actions):
        if not saved:
            do_save()
            saved = true
        return
    set_time_vars()
    if Input.is_action_just_pressed("UNDO"):
        if errors > 0:
            remove_error()
        elif len(actions[current]) != 2:
            move_up()
    for inp in [["UP", "W"],["LEFT", "A"],["DOWN", "S"],["RIGHT", "D"]]:
        if Input.is_action_just_pressed(inp[0]):
            if errors == 0 and actions[current] == inp[1]:
                move_down()
            elif len(actions[current]) != 2:
                add_error()
    if Input.is_action_just_pressed("ENTER"):
        if len(actions[current]) == 2:
            move_down()
    
    var scrollpos = int($Scrolls/Scroll.global_position.y)%32
    $What/Level.active = false
    $What/Cheat.active = false
    $What/Undo.active = false
    $Is.active = false
    if scrollpos < 20 and scrollpos > 12:
        $Is.active = true
        match what:
            0:
               $What/Level.active = true 
            1:
               $What/Cheat.active = true 
            2:
               $What/Undo.active = true 
        
func set_time_vars():
    if current == 0:
        starttime = OS.get_ticks_msec()
    var duration =  OS.get_ticks_msec()-starttime
    if duration <= 0:
        return
    meters[meter.TIME]["value"] = int(duration/1000)
    meters[meter.APM]["value"] = int(actions_done/(duration/60000.0))
    
    
func add_error():
    if errors >= $Scrolls/Errors.get_child_count():
        var a = Act.instance()
        a.position.y = (errors+1)*(32)
        $Scrolls/Errors.add_child(a)
    
    actions_done += 1
    $Tween.interpolate_property($Scrolls, "position:y", -(errors)*32, -(errors+1)*32, 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
    $Tween.start()
    meters[meter.FAILS]["value"] += 1
    meters[meter.STREAK]["value"] = 0
    errors += 1
    update_ui()


func remove_error():
    if errors < $Scrolls/Errors.get_child_count()-1:
        $Scrolls/Errors.get_children()[-1].queue_free()
    actions_done += 1
    $Tween.interpolate_property($Scrolls, "position:y", -(errors)*32, -(errors-1)*32, 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
    $Tween.start()
    errors -= 1
    update_ui()


func clear_errors():
    meters[meter.STREAK]["value"] = 0
    while $Scrolls/Errors.get_child_count() > 0:
        $Scrolls/Errors.get_children()[-1].queue_free()
    $Scrolls.position.y = 0
    errors = 0
    update_ui(true)


func move_down(f=false):
    if not f:
        $Tween.interpolate_property($Scrolls/Scroll, "position:y", (4.5+current)*32, (4.5+current+1)*32, 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
        $Tween.start()
        meters[meter.STREAK]["value"] += 1
        actions_done += 1
    else:
        $Scrolls/Scroll.position.y = (4.5+current+1)*32
    current += 1
    if current < len(actions):
        if len(actions[current]) == 2:
            bgc += 1
            if bgc >= len(bgcolors):
                bgc = 0
            $BG.color = Color(bgcolors[bgc])
            
    update_ui(f)


func move_up(f=false):
    if current <= 0:
        return
    if not f:
        if len(actions[current-1]) == 2:
            return
        actions_done += 1
        $Tween.interpolate_property($Scrolls/Scroll, "position:y", (4.5+current)*32, (4.5+current-1)*32, 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
        $Tween.start()
    current -= 1
    update_ui(f)


func update_ui(f=false):
    meters[meter.ACTIONS]["value"] = len(actions)-current+errors
    var what_to = what
    if current == len(actions):
        what_to = 1
    else:
        if errors:
            what_to = 2
        elif len(actions[current]) == 2:
            what_to = 0
        else:
            what_to = 1
    if what != what_to:
        if not f:
            $Tween.interpolate_property($What, "position:y", -(what)*32, -(what_to)*32, 0.1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
            $Tween.start()
        else:
            $What.position.y = -(what_to)*32
        what = what_to
        $What/Level.active = false
        $What/Cheat.active = false
        $What/Undo.active = false
            

func set_numbers():
    if meters[current_meter]["value"] == -1:
        var loop = int(OS.get_ticks_msec()/2000) % (len(meters.keys())-2)
        $Numbers.set_number(meters[loop]["value"])
    elif meters[current_meter]["value"] == -2:
        $Numbers.set_number(-1)
    else:
        $Numbers.set_number(meters[current_meter]["value"])
    var l = 0
    for led in meters[current_meter]["leds"]:
        if led == "1":
            $Leds.get_child(l).show()
        else:
            $Leds.get_child(l).hide()
        l += 1

func _on_Ready_timeout():
    ready_to_start = true

func do_save():
    SaveLoad.set_high_scores(meters[meter.TIME]["value"], meters[meter.STREAK]["value"], meters[meter.FAILS]["value"])
