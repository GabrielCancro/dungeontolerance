extends Node

var current_lang = "es"
var text_vars = []

var TEXTS = {
	"ab_streng_es":"_@CT_FUERZA BRUTA_@C/_\n Aumenta en un punto un dado de _@CS_Fuerza_@C/_",
	"def_ab_counterattack_name_es":"CONTRATAQUE",
	"def_ab_counterattack_es":"_@CT_CONTRATAQUE_@C/_\n Cada vez que colocas un dado en esta carta recibes entre 0 y #0 de golpe",
	"def_ab_activation_name_es":"ACTIVACION",
	"def_ab_activation_es":"_@CT_ACTIVACION_@C/_\n Este temporizador avanza cada turno, al completarse se desencadenan sus efectos.",
	"def_ab_shield_name_es":"ESCUDO",
	"def_ab_shield_es":"_@CT_ESCUDO_@C/_\n Reduce hasta #2 puntos el valor de cualquier dado de _@CS_Fuerza_@C/_ colocado en esta carta. Se restablece al inicio de cada turno.",
}

var REPLACES = {
	"_@C/_" = "[/color]",
	"_@CT_" = "[color=#f0f050]",
	"_@CS_" = "[color="+DiceManager.COLORS["S"]+"]",
}

func set_text_vars(vars):
	text_vars = vars

func get_text(code):
	code += "_"+current_lang
	if !code in TEXTS: return code
	var text = TEXTS[code]
	for k in REPLACES.keys(): 
		var fk = k.replace("_"+current_lang,"")
		text = text.replace(fk,REPLACES[k])
	for i in text_vars.size():
		text = text.replace("#"+str(i),str(text_vars[i]))
	return text
