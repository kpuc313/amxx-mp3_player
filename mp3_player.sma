/*****************************************************************
*                            MADE BY
*
*   K   K   RRRRR    U     U     CCCCC    3333333      1   3333333
*   K  K    R    R   U     U    C     C         3     11         3
*   K K     R    R   U     U    C               3    1 1         3
*   KK      RRRRR    U     U    C           33333   1  1     33333
*   K K     R        U     U    C               3      1         3
*   K  K    R        U     U    C     C         3      1         3
*   K   K   R         UUUUU U    CCCCC    3333333      1   3333333
*
******************************************************************
*                       AMX MOD X Script                         *
*     You can modify the code, but DO NOT modify the author!     *
******************************************************************
*
* Description:
* ============
* This plugin allows you to play uploaded online mp3 files to one or all players in the server though MOTD.
*
*****************************************************************/

#include <amxmodx>
#include <amxmisc>

#define VERSION "1.0"
#define FLAG ADMIN_IMMUNITY

new Player[200] ,Name[200], File[200], stop[32];

// Menu keys
const KEYSMENU = MENU_KEY_1|MENU_KEY_2

public plugin_init() {
	register_plugin("MP3 Player", VERSION, "kpuc313")
	
	register_clcmd("amx_play", "cmd1", FLAG, "^"Name of the song^" ^"http://site.com/filename.mp3^"")
	register_clcmd("amx_play2", "cmd2", FLAG, "^"Name of the player^" ^"Name of the song^" ^"http://site.com/filename.mp3^"")
	register_clcmd("say /play", "cmd3")
	register_clcmd("say /stop", "cmdCloseMP3")
	
	register_menu("Menu", KEYSMENU, "MenuCmd2")
}

public cmd1(id, level, cid) {
	if (!cmd_access(id, level, cid, 3))
		return PLUGIN_HANDLED;
		
	read_argv(1, Name, charsmax(Name));
	read_argv(2, File, charsmax(File));
	remove_quotes(Name)
	
	MenuCmd(0)
	
	return PLUGIN_HANDLED;
}

public cmd2(id, level, cid) {
	if (!cmd_access(id, level, cid, 3))
		return PLUGIN_HANDLED;
		
	read_argv(1, Player, charsmax(Player));
	read_argv(2, Name, charsmax(Name));
	read_argv(3, File, charsmax(File));
	remove_quotes(Name)
	
	new Target = cmd_target(id, Player, 2);
	
	if (!Target) return PLUGIN_HANDLED;
	MenuCmd(Target)
	
	return PLUGIN_HANDLED;
}

public cmd3(id) {
	if(stop[id]) {
		cmdShowMP3P(id)
		stop[id] = false
	}
}

public MenuCmd(id) {
	static menu[250], len
	len = 0
	
	// Title
	len += formatex(menu[len], charsmax(menu) - len, "\yDo you want to listen: \r%s^n^n", Name)
	
	// 1. Yes
	len += formatex(menu[len], charsmax(menu) - len, "\r1.\w Yes^n")
	
	// 2. No
	len += formatex(menu[len], charsmax(menu) - len, "\r2.\w No")
	
	show_menu(id, KEYSMENU, menu, -1, "Menu")
}

public MenuCmd2(id, key) {
	switch (key)
	{
		case 0:
		{
			cmdShowMP3P(id)
		}
		case 1:
		{
			stop[id] = true
			return PLUGIN_HANDLED;
		}
	}
	
	return PLUGIN_HANDLED;
}

public cmdShowMP3P(id) {
	static motd[1501], len;
    
	len = format(motd, 1500,"<body bgcolor=^"#202020^">");
	len += format(motd[len], 1500-len,"<center><img src=^"http://mp3p.hit.bg/header.png^"></center>");
	len += format(motd[len], 1500-len,"<table align=^"center^">");
	len += format(motd[len], 1500-len,"<tr><td align=^"center^" style=^"border: 1px #000 solid; background: #151515; color: red^">For stop the MP3 Player write /stop</td></tr>");
	len += format(motd[len], 1500-len,"<tr><td align=^"center^" style=^"border: 1px #000 solid; background: #151515^">");
	len += format(motd[len], 1500-len,"<object classid=CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6 codebase=http://www.microsoft.com/ntserver/netshow/download/en/nsmp2inf.cab#Version=5,1,51,415 type=application/x-oleobject name=msplayer width=256 height=65 align=^"middle^" id=msplayer>");
	len += format(motd[len], 1500-len,"<param name=^"enableContextMenu^" value=^"0^"><param name=^"stretchToFit^" value=^"1^">");
	len += format(motd[len], 1500-len,"<param name=^"AutoRewind^" value=^"1^">");
	len += format(motd[len], 1500-len,"<param name=^"Volume^" value=^"100^">");
	len += format(motd[len], 1500-len,"<param name=^"AutoStart^" value=^"1^">");
	len += format(motd[len], 1500-len,"<param name=^"URL^" value=^"%s^">", File);
	len += format(motd[len], 1500-len,"<param name=^"uiMode^" value=^"full^">");
	len += format(motd[len], 1500-len,"<param name=^"width^" value=^"256^">");
	len += format(motd[len], 1500-len,"<param name=^"height^" value=^"65^">");
	len += format(motd[len], 1500-len,"<param name=^"TransparentAtStart^" value=^"1^"></object>");
	len += format(motd[len], 1500-len,"</tr></td>");
	len += format(motd[len], 1500-len,"<tr><td align=^"center^" style=^"border: 1px #000 solid; background: #151515; color: green^">MP3 Player %s made by kpuc313</td></tr>", VERSION);
	len += format(motd[len], 1500-len,"</table>");
	
	show_motd(id, motd, "MP3 Player");
	stop[id] = false

	return 0;
}

public cmdCloseMP3(id) {
	static motd[1501], len;
    
	len = format(motd, 1500,"<body bgcolor=^"#202020^">");
	len += format(motd[len], 1500-len,"<center><img src=^"http://mp3p.hit.bg/header.png^"></center>");
	len += format(motd[len], 1500-len,"<table align=^"center^">");
	len += format(motd[len], 1500-len,"<tr><td align=^"center^" style=^"border: 1px #000 solid; background: #151515; color: red^">You stop the MP3 Player</td></tr>");
	len += format(motd[len], 1500-len,"<tr><td align=^"center^" style=^"border: 1px #000 solid; background: #151515; color: white^">If you want to listen again write /play</td></tr>");
	len += format(motd[len], 1500-len,"<tr><td align=^"center^" style=^"border: 1px #000 solid; background: #151515; color: green^">MP3 Player %s made by kpuc313</td></tr>", VERSION);
	len += format(motd[len], 1500-len,"</table>");
	
	show_motd(id, motd, "MP3 Player");

	if(!stop[id]) {	
		stop[id] = true
	}
		
	return 0;
}
