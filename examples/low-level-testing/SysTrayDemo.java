// Implementation of a System Tray Icon in Java
//
// After getting it working here, I'll redo the implementation in JRuby
//
// This works fine on Ubuntu ***WITH COMPIZ DISABLED*** ... won't work with Compiz turned on
//
// That's fine, tho, cause we want this for better Windows / OS X support anyway
//
// This is actually a great example ... http://www.javalobby.org/java/forums/m91830439.html


import java.awt.*;
import java.awt.event.*;

import javax.swing.*;

public class SysTrayDemo
{
    protected static TrayIcon trayIcon;

    private static PopupMenu createTrayMenu()
    {
        ActionListener exitListener = new ActionListener()
        {
            public void actionPerformed(ActionEvent e)
            {
                System.out.println("Bye from the tray");
                System.exit(0);
            }
        };

        ActionListener executeListener = new ActionListener()
        {
            public void actionPerformed(ActionEvent e)
            {
                JOptionPane.showMessageDialog(null, "Nothing here, press the button!",
                    "User action", JOptionPane.INFORMATION_MESSAGE);
                trayIcon.displayMessage("Done", "Bravo!", TrayIcon.MessageType.INFO);
            }
        };

        PopupMenu menu = new PopupMenu();
        MenuItem execItem = new MenuItem("Execute...");
        execItem.addActionListener(executeListener);
        menu.add(execItem);

        MenuItem exitItem = new MenuItem("Exit");
        exitItem.addActionListener(exitListener);
        menu.add(exitItem);
        return menu;
    }

    private static TrayIcon createTrayIcon()
    {
        Image image = Toolkit.getDefaultToolkit().getImage("my_cool_app.jpg");
        PopupMenu popup = createTrayMenu();
        TrayIcon ti = new TrayIcon(image, "Java System Tray Demo", popup);
        ti.setImageAutoSize(true);
        return ti;
    }

    public static void main(String[] args)
    {
        //if (! SystemTray.isSupported())
        //{
        //    System.out.println("System tray not supported on this platform");
        //    System.exit(1);
        //}

        try
        {
            SystemTray sysTray = SystemTray.getSystemTray();
            trayIcon = createTrayIcon();
            sysTray.add(trayIcon);
            trayIcon.displayMessage("Ready",
                "Tray icon started and tready", TrayIcon.MessageType.INFO);
        }
        catch (AWTException e)
        {
            System.out.println("Unable to add icon to the system tray");
            System.exit(1);
        }
    }
}
