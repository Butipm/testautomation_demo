package automation.tests.runner;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;


@RunWith(Cucumber.class)
@CucumberOptions(features = "src/test/java/automation/tests/features",
                glue = {"automation/tests/StepDefinitions","automation/tests/utilities"},
                plugin = {"pretty","html:target/cucumber-html-report.html","json:cucumber.json"})
public class TestRunner {

}
