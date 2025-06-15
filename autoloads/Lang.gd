extends Node

var current_lang = "es"
var text_vars = []

var TEXTS = {
	"ab_streng_es":"_@CT_FUERZA BRUTA_@C/_\n Aumenta en un punto un dado de _@CS_Fuerza_@C/_",
	
	"def_rat_name_es":"Rata",
	"def_bat_name_es":"Murcielago",
	"def_goblin_name_es":"Trasgo",
	
	"def_ab_aggressive_name_es":"AGRESIVO",
	"def_ab_aggressive_es":"Te atacara al finalizar el turno causando -#0HP.",
	"def_ab_counterattack_name_es":"CONTRATAQUE",
	"def_ab_counterattack_es":"Cada vez que colocas un dado en esta carta recibes entre 0 y #0 de golpe",
	"def_ab_activation_name_es":"ACTIVACION",
	"def_ab_activation_es":"Este temporizador avanza cada turno, al completarse se desencadenan sus efectos.",
	"def_ab_shield_name_es":"ESCUDO",
	"def_ab_shield_es":"Reduce hasta #2 puntos el valor de cualquier dado de @STR colocado en esta carta. Se restablece al inicio de cada turno.",
	"def_ab_drainer_name_es":"DRENADOR",
	"def_ab_drainer_es":"Cada vez que te ataque con exito, gana #0 de @STR.",

}

var REPLACES = {
	"@STR_es" = "[color="+DiceManager.COLORS["S"]+"]Fuerza[/color]",
}

func set_text_vars(vars):
	text_vars = vars

func get_text(code,styles=[]):
	code += "_"+current_lang
	if !code in TEXTS: return code
	var text = TEXTS[code]
	for k in REPLACES.keys(): 
		var fk = k.replace("_"+current_lang,"")
		text = text.replace(fk,REPLACES[k])
	for i in text_vars.size():
		text = text.replace("#"+str(i),str(text_vars[i]))
	if "UPPER" in styles: text = text.to_upper()
	if "TITLE" in styles: text = "[color=f0f050]"+text+"[/color]"
	return text
