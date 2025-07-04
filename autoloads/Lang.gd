extends Node

var current_lang = "es"
var text_vars = []

var TEXTS = {
	"ab_streng_name_es":"FUERZA BRUTA",
	"ab_streng_es":"Aumenta en +2 un dado de @STR",
	"ab_old_axe_name_es":"VIEJA HACHA",
	"ab_old_axe_es":"Duplica el valor de un dado de @STR.",
	
	"def_rat_name_es":"Rata",
	"def_bat_name_es":"Murcielago",
	"def_goblin_name_es":"Trasgo",
	
	"def_ab_aggressive_name_es":"AGRESIVO",
	"def_ab_aggressive_es":"Te atacara al finalizar el turno causando entre -#1HP y -#2HP.",
	"def_ab_counterattack_name_es":"CONTRATAQUE",
	"def_ab_counterattack_es":"Cada vez que colocas un dado en esta carta recibes entre -#1HP y -#2HP",
	"def_ab_activation_name_es":"ACTIVACION",
	"def_ab_activation_es":"Este temporizador avanza cada turno, al completarse se desencadenan sus efectos.",
	"def_ab_shield_name_es":"ESCUDO",
	"def_ab_shield_es":"Reduce hasta #2 puntos el valor de cualquier dado de @STR colocado en esta carta. Se restablece al inicio de cada turno.",
	"def_ab_drainer_name_es":"DRENADOR",
	"def_ab_drainer_es":"Cada vez que te ataque con exito, recupera +#0HP.",
	"def_ab_teasure_name_es":"TESORO",
	"def_ab_teasure_es":"Al resolver esta carta obtendras un objeto.",
	
	"tuto_welcome_es":"Bienvenidos aventureros! Les explicare las cosas basicas que todo aficionado deberia conocer antes de adentrarse en una mazmorra, hay muchos peligros alli.",
	"tuto_party_es":"En la parte inferior veras las estadisticas de tu grupo. En cada turno lanzas un dado por cada punto de caracteristica que tengas.",
	"tuto_dices_es":"Estos son tus dados para\n@PARTY_STR  @PARTY_DEX  @PARTY_MAG\n",
	"tuto_rat1_es":"Mira esa asquerosa rata! En la parte superior derecha veras sus @HP, debes reducirlos a cero para acabar con ella. Para eso toma tus dados y colocalos sobre ella.",
	"tuto_rat2_es":"Pero cuidado, la rata tambien tiene estadisticas, que se descuentan al valor de los dados que apliques.",
	"tuto_rat3_es":"Ademas, todos los enemigos tienen habilidades, verifica que hace cada una antes de hacer tu jugada!",
	"tuto_rat4_es":"Ahora si, elimina a esa rata de una vez..",
	"tuto_shield_es":"Casi lo olvido! Puedes usar dados para defenderte, los dados que te sobren al final del turno se transforman en escudo para mitigar ataques!",
	"tuto_good_work_es":"Buen trabajo! Ahora dejame mostrarte algunos trucos bajo la manga que te salvaran la vida mas de una vez.",
	"tuto_ability1_es":"Con este truco podras aumentar el valor de tus dados de @STR. Fundamental para no morir mordido por ratas!! jajaja!!",
	"tuto_power1_es":"Para usar habilidades como esta necesitas PODER!\n Hay muchas formas de conseguir poder, pero principalmente lo haras con tu foco de poder.",
	"tuto_power2_es":"Arroja algunos dados en tu foco y veras como se consigue el poder. Con eso podras usar tus habilidades.",
	"tuto_end_es":"Bueno bueno.. Mis labios se secan de tanto hablar, me voy a la taberna..",
	
	"tuto_tabern1_es":"Bien hecho, mereces un descanso en la taberna! Aqui podras reponerte y prepararte para tu proxima expedicion.",
	"tuto_tabern2_es":"Este es tu indicador de prestigio, cada vez que completes una expedicion aumentara tu reputacion!",
	"tuto_tabern3_es":"Esa reputacion te servira para determinar cuantos objetos se te permitira llevar a tu proxima expedicion.",
	"tuto_tabern4_es":"Siempre esta llegando gente nueva a la taberna, seguramente a algunos les gustaria ir contigo a las viejas ruinas.",
	"tuto_tabern5_es":"Combina tu grupo de tres aventureros como mas te convenga, cada personaje aporta sus propios stats y habilidades al grupo.",
	"tuto_tabern6_es":"Cuendo estes listo, puedes viajar a la ruina por este sendero.",
	"tuto_tabern7_es":"Muy bien!, Tengo mucho que limpiar alli atras, disfruta tu estadia!",

	"all_party_stats_es":"@PARTY_STR  @PARTY_DEX  @PARTY_MAG",
	"info_dungeon_level_es":"EXPEDICION #0    ROOM #1/#2",
	"some_stats_es":"@STR:#0  @DEX:#1  @MAG:#2",
	
	"rogue_es": "picaro"
}

var REPLACES = {
	"@STR_es" = "[color="+DiceManager.COLORS["S"]+"]Fuerza[/color]",
	"@DEX_es" = "[color="+DiceManager.COLORS["D"]+"]Destreza[/color]",
	"@MAG_es" = "[color="+DiceManager.COLORS["M"]+"]Magia[/color]",
	"@HP" = "[color=ff0000]HP[/color]",
	"@PARTY_STR_es" = "[color="+DiceManager.COLORS["S"]+"]Fuerza:"+str(PartyManager.STATS["S"])+"[/color]",
	"@PARTY_DEX_es" = "[color="+DiceManager.COLORS["D"]+"]Destreza:"+str(PartyManager.STATS["D"])+"[/color]",
	"@PARTY_MAG_es" = "[color="+DiceManager.COLORS["M"]+"]Magia:"+str(PartyManager.STATS["M"])+"[/color]",
	"@REQ_S" = "[color="+DiceManager.COLORS["S"]+"] @ [/color]",
	"@REQ_D" = "[color="+DiceManager.COLORS["D"]+"] @ [/color]",
	"@REQ_M" = "[color="+DiceManager.COLORS["M"]+"] @ [/color]",
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
