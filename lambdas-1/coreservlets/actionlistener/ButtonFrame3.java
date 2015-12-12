package coreservlets.actionlistener;

import java.awt.*;

/** The third of a series of examples that look at different
 *  ways to set up a button handler, which must be an instance
 *  of a class that implements ActionListener.
 *  Example 1: named inner classes 
 *  Example 2: anonymous inner classes 
 *  Example 3: lambda expressions (this example)
 *  Example 4: lambda expressions that refer to effectively final
 *             local variables.
 *  <p>
 *  From <a href="http://courses.coreservlets.com/Course-Materials/">the
 *  coreservlets.com tutorials on JSF 2, PrimeFaces, Ajax, JavaScript, jQuery, GWT, Android,
 *  Spring, Hibernate, JPA, RESTful Web Services, Hadoop, Spring MVC,
 *  servlets, JSP, Java 8 lambdas and streams (for those that know Java already), 
 *  and Java 8 programming (for those new to Java)</a>.
 */
public class ButtonFrame3 extends JFrameBase {
  private static final long serialVersionUID = 1L;

  public ButtonFrame3() {
    super("Lambdas");
    button1.addActionListener(event -> setBg(Color.BLUE));  // Notice omitting parens since there is exactly one parameter
    button2.addActionListener(event -> setBg(Color.GREEN));
    button3.addActionListener(event -> setBg(Color.RED));
    setVisible(true);
  } 
}
