extends Node

var current_lang = "es"
var text_vars = []

var TEXTS = {
	"ab_streng_es":"@CTFUERZA BRUTA@C/\n Aumenta en un punto un dado de @CSFuerza@C/",
	"def_ab_counterattack_name_es":"CONTRATAQUE",
	"def_ab_counterattack_es":"@CTCONTRATAQUE@C/\n Cada vez que colocas un dado en esta carta hay 50% de que recibas -#0pv.",
	"def_ab_activation_name_es":"ACTIVACION",
	"def_ab_activation_es":"@CTACTIVACION@C/\n Este temporizador avanza cada turno, al completarse se desencadenan sus efectos.",
}

var REPLACES = {
	"@C/" = "[/color]",
	"@CT" = "[color=#f0f050]",
	"@CS" = "[color="+DiceManager.COLORS["S"]+"]",
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
