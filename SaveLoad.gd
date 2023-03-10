extends Node

var data_path = "user://data.dat"

var data = {
    "currentpath": "",
    "display": "",
    "highscores": {}
   }

var highscores = {
        "streak": 0,
        "time": 9999,
        "fails": 9999
       }


func set_high_scores(time, streak, fails):
    if not data["currentpath"] in data["highscores"].keys():
        data["highscores"] = highscores.duplicate()
    data["highscores"][data["currentpath"]]["streak"] = max(data["highscores"][data["currentpath"]]["streak"], streak)
    data["highscores"][data["currentpath"]]["time"] = min(data["highscores"][data["currentpath"]]["time"], time)
    data["highscores"][data["currentpath"]]["fails"] = min(data["highscores"][data["currentpath"]]["fails"], fails)
    save_data()
 
func init_high_score():
    if not data["currentpath"] in data["highscores"].keys():
        data["highscores"][data["currentpath"]] = highscores.duplicate()   

func get_hs(val):
    return data["highscores"][data["currentpath"]][val]
    
    
func load_data():
    var file = File.new()
    if file.file_exists(data_path):
        file.open(data_path, File.READ)
        var content = file.get_var()
        file.close()
        if content:
            for key in data.keys():
                if key in content.keys():
                    data[key] = content[key]
                else:
                    print(key + " not found!")
    
func save_data():
    var file = File.new()
    file.open(data_path, File.WRITE)
    file.store_var(data, true)
    file.close()
    
