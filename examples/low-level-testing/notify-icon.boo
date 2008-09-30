#! /usr/bin/env booi

# Implementation of a System Tray Icon in Boo (.NET)
#
# After getting it working here, I'll redo the implementation in IronRuby
#
# NOTE: there's a bug in mono and NotifyIcons don't currently appear on 64bit machines
# 	... need to test this on Windows (32bit) to finish the implementation ...
#
# NotifyIcon events: http://msdn.microsoft.com/en-us/library/system.windows.forms.notifyicon_events(VS.80).aspx
# MenuItem events: http://msdn.microsoft.com/en-us/library/system.windows.forms.menuitem_events(VS.80).aspx
# 	^ .Popup is likely what we want ... "Occurs before a menu item's list of menu items is displayed."
# 	  .Select is a potential, too: "Occurs when the user places the pointer over a menu item."

import System.Drawing
import System.Windows.Forms

class MyForm(Form):

	[Property(MyIcon)]
	_my_icon as NotifyIcon = NotifyIcon()

	[Property(MyMenu)]
	_my_menu as ContextMenu = ContextMenu()

	def constructor():
		item = MenuItem()
		item.Text = 'Some Item'
		item.Click += def(s,e):
			print "You clicked Some Item!"

		#MyMenu.MenuItems.AddRange((item) as (MenuItem))

		#MyIcon.Icon = Icon("my_cool_app.ico")
		MyIcon.Icon = Icon(SystemIcons.Exclamation, 40, 40);
		MyIcon.ContextMenu = MyMenu
		MyIcon.Text = "My App!"
		MyIcon.Visible = true
		MyIcon.DoubleClick += def(s,e):
			print "You double clicked!"

Application.Run( MyForm() )
