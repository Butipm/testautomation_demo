package automation.tests.apiTests.perfTestSimulations

import com.intuit.karate.gatling.PreDef.*
import io.gatling.core.Predef.*

import scala.concurrent.duration.*

class SubscriptionsSimulation extends Simulation {

    val protocol = karateProtocol(
        "/cats/{id}" -> Nil,
        "/cats" -> pauseFor("get" -> 15, "post" -> 25)
    )

    protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
   protocol.runner.karateEnv("perf")

    // Get the current working directory
    val projectPath = System.getProperty("user.dir")

    // Construct the relative path from the project root
    val relativeCsvPath = "/src/test/java/perfTestData1.csv"
    val absoluteCsvPath = projectPath + relativeCsvPath

    // Use the relative path for CSV feeder
    val csvFeeder = csv(filePath = absoluteCsvPath).circular


    val create = scenario("create").feed(csvFeeder).exec(karateFeature("classpath:automation/tests/apiTests/Perftests/G_Subscription_via_api.feature"))


    setUp(
        create.inject(rampUsers(10)during(5 seconds)).protocols(protocol),

    )

}
