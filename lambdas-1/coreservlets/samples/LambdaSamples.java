package coreservlets.samples;

import coreservlets.integrable.*;

import java.awt.event.*;
import java.io.*;
import java.net.*;
import java.util.*;
import java.util.concurrent.*;

import javax.swing.*;

/** Some lambda examples. No real functionality: it just shows the syntax
 *  as given in the lecture.
 *  <p>
 *  From <a href="http://courses.coreservlets.com/Course-Materials/">the
 *  coreservlets.com tutorials on JSF 2, PrimeFaces, Ajax, JavaScript, jQuery, GWT, Android,
 *  Spring, Hibernate, JPA, RESTful Web Services, Hadoop, Spring MVC,
 *  servlets, JSP, Java 8 lambdas and streams (for those that know Java already), 
 *  and Java 8 programming (for those new to Java)</a>.
 */
public class LambdaSamples {
  private final String[] testStrings = {"one", "two", "three", "four"};
  private final JButton someButton = new JButton("Click Me");
  private final ExecutorService taskList = Executors.newFixedThreadPool(100);
  
  @SuppressWarnings({"unused", "resource"}) // Just showing lambda syntax with no real functionality
  public void doSomeLambdas() {
    Arrays.sort(testStrings, (s1, s2) -> s1.length() - s2.length());
    taskList.execute(() -> downloadSomeFile());
    someButton.addActionListener(event -> handleButtonClick());
    double d = MathUtilities.integrate(x -> x*x, 0, 100, 1000);
    AutoCloseable c = () -> cleanupForTryWithResources();
    Thread.UncaughtExceptionHandler handler = (thread, exception) -> doSomethingAboutException();
    Formattable f = (formatter, flags, width, precision) -> makeFormattedString();
    ContentHandlerFactory fact = mimeType -> createContentHandlerForMimeType();
    CookiePolicy policy = (uri, cookie) -> decideIfCookieShouldBeAccepted();
    Flushable toilet = () -> writeBufferedOutputToStream();
    TextListener t = event -> respondToChangeInTextValue();
  }
  
  private void downloadSomeFile() {}
  private void handleButtonClick() {}
  private void cleanupForTryWithResources() {}
  private void doSomethingAboutException() {}
  private void makeFormattedString() {}
  private ContentHandler createContentHandlerForMimeType() { return(null); }
  private boolean decideIfCookieShouldBeAccepted() { return(false); }
  private void writeBufferedOutputToStream() {}
  private void respondToChangeInTextValue() {}
}
