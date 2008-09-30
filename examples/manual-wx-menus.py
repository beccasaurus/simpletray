#! /usr/bin/env python
import wx

class App(wx.App):
	def OnInit(self):
		frame = wx.Frame(parent=None, title='Hello from wxPython App')
		frame.Show()
		self.tbIcon = MyIcon(self)
		return True

	def showLogin():
		print('show login!');

	def onExit(self,event):
		self.Destroy()
		self.tbIcon.Destroy()
		raise SystemExit # or import sys + call sys.exit()

class AnItem(wx.MenuItem):
	def __init__(self, parent, *args, **kwargs):
		print("hello from AnItem __init__")
		wx.MenuItem.__init__(self, parent, *args, **kwargs)
		self.parent = parent
		submenu = wx.Menu()
		submenu.Append(wx.NewId(), 'Hello')
		submenu.Append(wx.NewId(), 'There')
		self.SetSubMenu(submenu)
		self.parent.Bind(wx.EVT_MENU_HIGHLIGHT, self.OnMenuHighlight)

	def OnMenuHighlight(self,event):
		print('hello from OnMenuHighlight in AnItem')

	def __onWxMenuHighlight(self,event):
		print("haha!  overriding default __onWxMenuHighlight ... muhahahaha!")

class MyIcon(wx.TaskBarIcon):
	ID_LOGIN = wx.NewId()
	ID_CONFIG = wx.NewId()
	ID_MUTE = wx.NewId()

	def __init__(self, parent, *args, **kwargs):
		wx.TaskBarIcon.__init__(self, *args, **kwargs)
		self.parent = parent
		icon = wx.Icon("my_cool_app.png", wx.BITMAP_TYPE_PNG)
		self.SetIcon(icon, "Hello from wxPython Icon")

	def showMenu(self, event):
		self.PopupMenu(self.menu)

	def CreatePopupMenu(self):
		self.Bind(wx.EVT_TASKBAR_RIGHT_UP, self.showMenu)
		self.menu = wx.Menu()
		self.menu.Append(MyIcon.ID_LOGIN, "&Login/Change user")
		self.Bind(wx.EVT_MENU, self.parent.showLogin, id=MyIcon.ID_LOGIN)
		self.menu.AppendSeparator()
		self.menu.Append(wx.ID_EXIT, "E&xit")

		new_id = 12345
		new = AnItem(self.menu, new_id, '&New\tCtrl+N', 'Creates a new document')
		self.menu.AppendItem(new)
    		# menu.evt_menu_highlight(an_item){ puts "highlighted an_item!" } # <--- ruby
		# self.Bind(wx.EVT_MENU_HIGHLIGHT, ...
		self.Bind(wx.EVT_MENU_HIGHLIGHT, self.OnHighlightAnItem) #, id=new_id)

		#self.menu.AppendItem(wx.NewId(), AnItem(self, wx.NewId(), 'SomeTextForAnItem__init__'))
		self.Bind(wx.EVT_MENU, self.parent.onExit, id=wx.ID_EXIT)
		self.Bind(wx.EVT_MENU_HIGHLIGHT, self.onHighlightExit, id=wx.ID_EXIT)
		self.Bind(wx.EVT_CLOSE, self.parent.onExit)
		return self.menu

	def OnHighlightAnItem(self,event):
		print("OnHighlightAnItem!!!!!")

	def onHighlightExit(self,event):
		print("highlighted EXIT")

print "starting ..."
app = App()
app.MainLoop()
