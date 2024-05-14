package automation.tests.StepDefinitions;

import automation.tests.utilities.BrowserDriver;
import io.cucumber.java.en.Given;
import org.openqa.selenium.chrome.ChromeDriver;

import static automation.tests.utilities.BrowserDriver.driver;

public class BasePage extends BrowserDriver{
    BrowserDriver bd = new BrowserDriver();

    @Given("^I have navigated to test")
    public void user_navigates_to_test(){
        bd.setDriver();
    }
}
