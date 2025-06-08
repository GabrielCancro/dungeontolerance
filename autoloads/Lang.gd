extends Node

var current_lang = "es"
var TEXTS = {
	"ab_streng_es":"@CTFUERZA BRUTA@C/\n Aumenta en un punto un dado de @CSFuerza@C/",
	"def_ab_counterattack_name_es":"CONTRATAQUE",
	"def_ab_counterattack_es":"@CTCONTRATAQUE@C/\n Cada vez que colocas un dado en esta carta hay 50% de que recibas -1pv.",
}

var REPLACES = {
	"@C/" = "[/color]",
	"@CT" = "[color=#f0f050]",
	"@CS" = "[color="+DiceManager.COLORS["S"]+"]",
}

func get_text(code):
	code += "_"+current_lang
	if !code in TEXTS: return code
	var text = TEXTS[code]
	for k in REPLACES.keys(): 
		var fk = k.replace("_"+current_lang,"")
		text = text.replace(fk,REPLACES[k])
	return text
