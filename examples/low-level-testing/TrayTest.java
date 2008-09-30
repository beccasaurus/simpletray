// another test (less AWT, more Swing ...) ... grrr, uses JDIC< which is apparently pretty dead and i dunno howto use it

import java.awt.event.*;
import javax.swing.*;
import org.jdesktop.jdic.tray.*;
 
public class TrayTest {
 
	public static void main(String[] args) {
		
		// from the other example:
                // Image image = Toolkit.getDefaultToolkit().getImage("my_cool_app.jpg");

		// Icon icon = new ImageIcon(TrayTest.class.getResource("my_cool_app.jpg"));
		Icon icon = new ImageIcon("my_cool_app.jpg");
		
		JPopupMenu menu = new JPopupMenu();
		menu.add(new JMenuItem("Test 1"));
		
		menu.addSeparator();
		
		JMenu subMenu = new JMenu("Test 2");
		subMenu.add(new JMenuItem("Test 3"));
		
		menu.add(subMenu);
		
		menu.addSeparator();
		
		JMenuItem exit = new JMenuItem("Exit");
		
		exit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				System.exit(0);
			}
		});
		
		menu.add(exit);
		
		TrayIcon tray = new TrayIcon(icon, "My Caption", menu);
		
		SystemTray.getDefaultSystemTray().addTrayIcon(tray);
		
	}
}
