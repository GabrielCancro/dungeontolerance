extends Node

var current_lang = "es"
var text_vars = []

var TEXTS = {
	"ab_streng_name_es":"FUERZA BRUTA",
	"ab_streng_es":"Aumenta en +3 un dado de @STR",
	"ab_subtlety_name_es":"SUTILEZA",
	"ab_subtlety_es":"Aumenta +3 a un dado de @DEX",
	"ab_atletic_name_es":"ATLETISMO",
	"ab_atletic_es":"Cambia un dado @STR->@DEX o @DEX->@STR y suma +2",
	"ab_protector_name_es":"PROTECTOR",
	"ab_protector_es":"Obtienes 3 de escudo.",
	"ab_bendition_name_es":"BENDICION",
	"ab_bendition_es":"Aumenta +2 a un dado al azar (debes tener al menos dos dados)",
	
	"ab_old_axe_name_es":"VIEJA HACHA",
	"ab_old_axe_es":"Bonifica entre 1 y 6 el valor de un dado de @STR.",
	"ab_sword_name_es":"GRAN ESPADA",
	"ab_sword_es":"Lanza un dado extra de @STR.",
	"ab_dage_name_es":"DAGA",
	"ab_dage_es":"Aplica -2HP directo a un enemigo.",
	"ab_crossbow_name_es":"BALLESTA",
	"ab_crossbow_es":"Aplica -4HP directo a un enemigo.",
	"ab_gold_ring_name_es":"ANILLO DORADO",
	"ab_gold_ring_es":"Otorga 3 de poder magico.",
	"ab_bread_name_es":"PAN DE VIAJE",
	"ab_bread_es":"Sana +3HP.",
	"ab_speed_bots_name_es":"BOTAS DE AGILIDAD",
	"ab_speed_bots_es":"Otorga un dado de @DEX.",
	"ab_rope_name_es":"CAPA",
	"ab_rope_es":"Otorga +2 de escudo y +1 a todos tus dados de destreza.",
	"ab_iron_helm_name_es":"YELMO DE HIERRO",
	"ab_iron_helm_es":"Otorga +5 de escudo.",
	
	"def_tuto_rat_name_es":"Rata",
	"def_rat_name_es":"Rata",
	"def_bat_name_es":"Murcielago",
	"def_goblin_name_es":"Trasgo",
	"def_arrow_trap_name_es":"Trampa de Flechas",
	"def_chest_name_es":"Cofre",
	"def_slime_name_es":"Slime",
	"def_ghost_name_es":"Espectro",
	"def_spider_name_es":"Aracnido",
	"def_rune_trap_name_es":"Trampa Runica",
	
	"def_ab_aggressive_name_es":"AGRESIVO",
	"def_ab_aggressive_es":"Te atacara al finalizar el turno causando entre -#1HP y -#2HP.",
	"def_ab_counterattack_name_es":"CONTRATAQUE",
	"def_ab_counterattack_es":"Una vez por turno, cuando coloques un dado en esta carta recibes entre -#1HP y -#2HP",
	"def_ab_activation_name_es":"ACTIVACION",
	"def_ab_activation_es":"Este temporizador avanza cada turno, al completarse se desencadenan sus efectos.",
	"def_ab_trap_damage_name_es":"DANIO MASIVO",
	"def_ab_trap_damage_es":"Al activarse aplica entre -#1HP y -#2HP.",
	"def_ab_shield_name_es":"ESCUDO",
	"def_ab_shield_es":"Reduce hasta #2 puntos el valor de cualquier dado de @STR colocado en esta carta. Se restablece al inicio de cada turno.",
	"def_ab_drainer_name_es":"DRENADOR",
	"def_ab_drainer_es":"Cada vez que te ataque con exito, recupera +#0HP.",
	"def_ab_teasure_name_es":"TESORO",
	"def_ab_teasure_es":"Al resolver esta carta obtendras un objeto.",
	"def_ab_necrotic_name_es":"NECROTICO",
	"def_ab_necrotic_es":"Te atacara al finalizar el turno ignorando tu escudo entre -#1HP y -#2HP.",
	"def_ab_poison_name_es":"VENENO",
	"def_ab_poison_es":"Cada vez que te ataque con exito pierdes un punto de cordura.",
	"def_ab_absorb_name_es":"ABSORBER",
	"def_ab_absorb_es":"Absorbe el primer dado que apliques cada turno ignorando su valor.",
	"def_ab_trap_sanity_name_es":"LOCURA",
	"def_ab_trap_sanity_es":"Al activarse reduce -#0 tu cordura.",
	
	"destine_campfire_title_es":"Campamento",
	"destine_campfire_desc_es":"Tras explorar pasillos oscuros y sortear trampas oxidadas, tu grupo encuentra un respiro, una pequeña sala iluminada por brasas apagadas y el aroma tenue de hierbas quemadas. Alguien acampó aquí antes... pero ya no están.  Un círculo de piedras guarda las cenizas de una fogata, y un tronco musgoso invita a sentarse. Este es un lugar seguro, al menos por ahora. El aire es más templado, y el silencio no parece hostil.",
	"destine_campfire_op1_es":"Ganas 5 puntos de cordura.",
	"destine_campfire_op2_es":"Restaura hasta 7 HP.",
	"destine_campfire_op3_es":"Obtienes una racion de comida que rastaura 3 HP al final de cada combate durante 3 combates.",
	
	"tuto_welcome_es":"Bienvenidos aventureros! Les explicare las cosas basicas que todo aficionado deberia conocer antes de adentrarse en una mazmorra, hay muchos peligros alli.",
	"tuto_party_es":"En la parte inferior veras las estadisticas de tu grupo. En cada turno lanzas un dado por cada punto de caracteristica que tengas.",
	"tuto_dices_es":"Estos son tus dados para",
	"tuto_rat1_es":"Mira esa asquerosa rata! En la parte superior derecha veras sus @HP, debes reducirlos a cero para acabar con ella. Para eso toma tus dados y colocalos sobre ella.",
	"tuto_rat2_es":"Pero cuidado, la rata tambien tiene estadisticas, que se descuentan al valor de los dados que apliques.",
	"tuto_rat3_es":"Ademas, todos los enemigos tienen habilidades, verifica que hace cada una antes de hacer tu jugada!",
	"tuto_rat4_es":"Ahora si, elimina a esa rata de una vez..",
	"tuto_shield_es":"Casi lo olvido! Puedes usar dados para mitigar ataques colocandolos aqui! Si te sobran dados al final del turno se asignaran automaticamente.",
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
	
	"new_hero_1_es":"Un nuevo aventurero llego a la taberna.\nParece dispuesto a ayudarte en las ruinas.",
	
	"tx_end_expedition_es":"Muy bien aventureros! Han completado la expedicion!\nEs hora de volver a la taberna a descansar y contar tus logros!",
	"tx_game_over_es":"Este lugar es mas peligroso de lo que pensabas.\nReagrupate, descansa y vuelve a intentarlo.",
	"tx_intro1_es":"Entrada del diario del Explorador Gerran Velmor,",
	"tx_intro2_es":"“Han pasado tres días desde que los pastores encontraron esa extraña entrada de piedra tras las rocas. No tardaron en llegar los rumores... y con ellos, los buscadores de fortuna. Yo fui uno de los primeros en entrar. Aunque solo eche un vistazo.”",
	"tx_intro3_es":"“Las ruinas no son naturales. Los pasillos cambian. Las cámaras no están hechas por manos humanas… o al menos, no por manos de este tiempo. Hay símbolos que nadie ha podido traducir y ecos que parecen susurrar cuando uno se queda solo.”",
	"tx_intro4_es":"“Intentare reunir un grupo. Tres aventureros dispuestos a desafiar la oscuridad por oro, poder… o redención. Les dare un mapa de como llegar, algunas provisiones, y pagare por la informacion, podria estar relacionado con las historias de mi Orden.”",
	"tx_intro5_es":"“Cada expedicion sera una nueva oportunidad. Cada descubrimiento, una soga tendida sobre el abismo. Los peligros rebosan la cueva y esas ruinas no parecen perdonar la imprudencia.”",
	"tx_intro6_es":"– Gerran Velmor, Explorador de la Orden del Ojo Silente",
	
	"tx_sanity_es":"Tu nivel de cordura bajara en cada turno, cada vez que destruyas un enemigo o completes una habitacion recuperas un poco de ella. Ten cuidado, si llegas a cero los espectros de la ruina vendran por ti!",
	
	
	"all_party_stats_es":"@PARTY_STR  @PARTY_DEX  @PARTY_MAG",
	"info_dungeon_level_es":"EXPEDICION #0    ROOM #1/#2",
	"some_stats_es":"[color="+DiceManager.COLORS["S"]+"]@STR:#0[/color]  [color="+DiceManager.COLORS["D"]+"]@DEX:#1[/color]  [color="+DiceManager.COLORS["M"]+"]@MAG:#2[/color]",
	
	"rogue_es": "picaro",
	"sorcerer_es": "hechicero",
	"explorer_es": "explorador",
	"barbarian_es": "barbaro",
	"warrior_es": "guerrero",
	
	"stat_S_es":"Fuerza",
	"stat_D_es":"Destreza",
	"stat_M_es":"Magia",
	"stat_hp_es":"Vitalidad",
	"stat_sanity_es":"Cordura",
	"max_power_es":"Carga maxima",
}

var REPLACES = {
	"@STR_es" = "[color="+DiceManager.COLORS["S"]+"]Fuerza[/color]",
	"@DEX_es" = "[color="+DiceManager.COLORS["D"]+"]Destreza[/color]",
	"@MAG_es" = "[color="+DiceManager.COLORS["M"]+"]Magia[/color]",
	"@HP" = "[color=ff0000]HP[/color]",
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

func get_req_string(req={}):
	var result = ""
	for k in req.keys():
		var c = DiceManager.COLORS[k]
		if k in req: for i in req[k]: result += "[img=14 color="+c+"]res://assets/full_white_point.png[/img]" 
	return result
