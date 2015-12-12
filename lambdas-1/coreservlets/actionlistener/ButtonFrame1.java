package coreservlets.actionlistener;

import java.awt.*;
import java.awt.event.*;

/** The first of a series of examples that look at different
 *  ways to set up a button handler, which must be an instance
 *  of a class that implements ActionListener.
 *  Example 1: named inner classes (this example)
 *  Example 2: anonymous inner classes
 *  Example 3: lambda expressions
 *  Example 4: lambda expressions that refer to effectively final
 *             local variables.
 *  <p>
 *  From <a href="http://courses.coreservlets.com/Course-Materials/">the
 *  coreservlets.com tutorials on JSF 2, PrimeFaces, Ajax, JavaScript, jQuery, GWT, Android,
 *  Spring, Hibernate, JPA, RESTful Web Services, Hadoop, Spring MVC,
 *  servlets, JSP, Java 8 lambdas and streams (for those that know Java already), 
 *  and Java 8 programming (for those new to Java)</a>.
 */
public class ButtonFrame1 extends JFrameBase {
  private static final long serialVersionUID = 1L;

  public ButtonFrame1() {
    super("Named Inner Classes");
    button1.addActionListener(new ColorChanger(Color.BLUE));
    button2.addActionListener(new ColorChanger(Color.GREEN));
    button3.addActionListener(new ColorChanger(Color.RED));
    setVisible(true);
  }
  
  private class ColorChanger implements ActionListener {
    private Color bgColor;
    
    public ColorChanger(Color bgColor) {
      this.bgColor = bgColor;
    }

    @Override
    public void actionPerformed(ActionEvent event) {
      setBg(bgColor);
    }
  }
}
