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
	"def_ab_drainer_es":"Cada vez que te ataque con exito, recupera +#0@HP.",
	
	"tuto_welcome_es":"Bienvenidos aventureros! Les explicare las cosas basicas que todo aficionado deberia conocer antes de adentrarse en una mazmorra, hay muchos peligros alli.",
	"tuto_party_es":"En la parte inferior veras las estadisticas de tu grupo.\n@PARTY_STR  @PARTY_DEX  @PARTY_MAG\nTambien estan tus @HP, si se reducen a cero finalizara tu expedicion.",
	"tuto_dices_es":"Por cada estadistica que tengas lanzaras un dado de ese tipo en cada turno, estos son tus dados para\n@PARTY_STR  @PARTY_DEX  @PARTY_MAG\n",
	"tuto_rat1_es":"Mira esa asquerosa rata! En la parte superior derecha veras sus HP, deber reducirlos a cero para acabar con ella. Para eso toma tus dados y colocalos sobre ella.",
	"tuto_rat2_es":"Pero cuidado, la rata tambien tiene estadisticas, que se descontaran al valor de los dados que apliques.",
	"tuto_rat3_es":"Ademas, todos los enemigos tienen habilidades, verifica que hace cada una antes de hacer tu jugada!",
	"tuto_rat4_es":"Ahora si, elimina a esa rata de una vez..",
	"tuto_good_work_es":"Buen trabajo! Ahora dejame mostrarte algunos trucos bajo la manga que te salvaran la vida mas de una vez.",
	"tuto_ability1_es":"Con este truco podras aumentar el valor de tus dados de @STR. Fundamental para no morir mordido por ratas!! jajaja!!",
	"tuto_power1_es":"Para usar habilidades como esta necesitas PODER!\n Hay muchas formas de conseguir poder, pero principalmente lo haras con tu foco de poder.",
	"tuto_power2_es":"Arroja algunos dados en tu foco y veras como se consigue el poder. Con eso podras usar tus habilidades.",
	"tuto_end_es":"Mis labios se secan de tanto hablar, me voy a la taberna, consigue un buen botin!",
}

var REPLACES = {
	"@STR_es" = "[color="+DiceManager.COLORS["S"]+"]Fuerza[/color]",
	"@HP" = "[color=ff0000]HP[/color]",
	"@PARTY_STR_es" = "[color="+DiceManager.COLORS["S"]+"]Fuerza:"+str(PartyManager.STATS["S"])+"[/color]",
	"@PARTY_DEX_es" = "[color="+DiceManager.COLORS["D"]+"]Destreza:"+str(PartyManager.STATS["D"])+"[/color]",
	"@PARTY_MAG_es" = "[color="+DiceManager.COLORS["M"]+"]Magia:"+str(PartyManager.STATS["M"])+"[/color]",
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
