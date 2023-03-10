extends Node2D


func set_number(num):
    if num < 0:
        $Number1.do_woble = false
        $Number2.do_woble = false
        $Number3.do_woble = false
        $Number4.do_woble = false
        get_parent().get_node("MonitorMask").do_woble = false
        modulate.a = 0.2
        num = 0
    else:
        $Number1.do_woble = true
        $Number2.do_woble = true
        $Number3.do_woble = true
        $Number4.do_woble = true
        get_parent().get_node("MonitorMask").do_woble = true
        modulate.a = 1
        
    if num > 9999:
        num = 9999
    var thou = int(num/1000)
    var hund = int(num/100)%10
    var tens = int(num/10)%10
    var ones = int(num)%10
    $Number1.spriteid = thou*2
    $Number2.spriteid = hund*2
    $Number3.spriteid = tens*2
    $Number4.spriteid = ones*2
    if thou == 0:
        $Number1.active = false
        if hund == 0:
            $Number2.active = false
            if tens == 0:
                $Number3.active = false
                if ones == 0:
                    $Number4.active = false
                else:
                    $Number4.active = true
            else:
                $Number3.active = true
                $Number4.active = true
        else:
            $Number2.active = true
            $Number3.active = true
            $Number4.active = true
    else:
        $Number1.active = true
        $Number2.active = true
        $Number3.active = true
        $Number4.active = true
        
