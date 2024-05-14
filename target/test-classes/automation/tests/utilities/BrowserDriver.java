package automation.tests.utilities;

import org.junit.After;
import org.junit.Before;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.edge.EdgeOptions;
import org.openqa.selenium.manager.SeleniumManager;
import org.openqa.selenium.remote.DesiredCapabilities;

import java.time.Duration;

public class BrowserDriver {
    public static WebDriver driver;
    //public ChromeOptions options;



        @Before
        public void setDriver() {

            // Create ChromeOptions object and set the desired capability
           // ChromeOptions chromeOptions = new ChromeOptions();
            //chromeOptions.setCapability("goog:chromeOptions", true);
            // These codes are optional

            ChromeOptions ChromeOpt = new ChromeOptions();
            ChromeOpt.setBrowserVersion("120");
            // Pass the ChromeOpt option it takes as a type of Capability.
            String chromeDriverPath = SeleniumManager.getInstance().getDriverPath(ChromeOpt,true).getDriverPath();
            System.out.println("chromeDriverPath--" + chromeDriverPath);
            // These codes are optional

            // Create EdgeOptions object and set the desired capability



            // Only this code is needed to setup driver , above codes are just to get driver paths.
            ChromeOpt.addArguments("--start-maximized");
            driver = new ChromeDriver(ChromeOpt);
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));

            driver.get("https://www.youtube.com/watch?v=NSmEaOEeusE");
            driver.manage().window().maximize();



            /*ChromeOptions options = new ChromeOptions();
            DesiredCapabilities capabilities = new DesiredCapabilities();
            capabilities.setCapability(ChromeOptions.CAPABILITY, options);
            capabilities.setCapability(ChromeOptions.CAPABILITY, options);
            options.merge(capabilities);
            ChromeDriver driver = new ChromeDriver(options);
            driver.get("www.google.com");
            driver.manage().window().maximize();
            //driver.quit();*/
        }

@After
    public void close(){
        driver.quit();
    }

}
