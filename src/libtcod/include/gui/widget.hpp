/*
* libtcod 1.6.0
* Copyright (c) 2008,2009,2010,2012,2013 Jice & Mingos
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * The name of Jice or Mingos may not be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY JICE AND MINGOS ``AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL JICE OR MINGOS BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
class TCODLIB_GUI_API Widget {
public :
	int x,y,w,h;
	void *userData;
	static Widget *focus;
	static Widget *keyboardFocus;

	Widget();
	Widget(int x, int y);
	Widget(int x, int y, int w, int h);
	virtual ~Widget();
	virtual void render() {}
	virtual void update(const TCOD_key_t k);
	void move(int x,int y);
	void setTip(const char *tip);
	virtual void setVisible(bool val) { visible=val; }
	bool isVisible() { return visible; }
	virtual void computeSize() {}
	static void setBackgroundColor(const TCODColor col,const TCODColor colFocus);
	static void setForegroundColor(const TCODColor col,const TCODColor colFocus);
	static void setConsole(TCODConsole *con);
	static void updateWidgets(const TCOD_key_t k,const TCOD_mouse_t mouse);
	static void renderWidgets();
	static TCOD_mouse_t mouse;
	static TCODColor fore;
	virtual void expand(int width, int height) {}
protected :
	friend class StatusBar;
	friend class ToolBar;
	friend class VBox;
	friend class HBox;

	virtual void onMouseIn() {}
	virtual void onMouseOut() {}
	virtual void onButtonPress() {}
	virtual void onButtonRelease() {}
	virtual void onButtonClick() {}

	static void updateWidgetsIntern(const TCOD_key_t k);

	static float elapsed;
	static TCODColor back;
	static TCODColor backFocus;
	static TCODColor foreFocus;
	static TCODConsole *con;
	static TCODList <Widget *>widgets;
	char *tip;
	bool mouseIn:1;
	bool mouseL:1;
	bool visible:1;
};

typedef void (*widget_callback_t) ( Widget *w, void *userData );

