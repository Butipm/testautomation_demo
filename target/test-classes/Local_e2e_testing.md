
# Karate Test Automation - README

## Overview

This README file provides information about the Maven command used for running Karate tests, explains its various components, and includes instructions for configuring run configurations in IntelliJ IDEA and Visual Studio Code (VSCode).

## Maven Command

To run the Karate tests, execute the following Maven command:(**NB** replace the values `<>` with actual values

#### Functional Tests:
```bash
 mvn clean test 
 -DselniumBToken=<****> 
 -Dkarate.env=remote 
 -DmotusWeburl=<> 
 -DmotusAPIurl=<> 
 -Dbrowser=chrome 
 -Ddb_test=DV1G 
 -DEBMW_DV1G 
 -Dschema_test=MDD 
 -Dtable1_test=TMDD01 
 -Dtable2_test=TMDD02 
 -DiwaUser=<***> 
 -DiwaPass=<***> 
 -DPostQUser=<****> 
 -DPostQPass=<****> 
 -Dkarate.options="--tags @MDD-1367" 
 -f pom.xml
 ````



```bash
mvn clean test \
    -DselniumBToken=<****> \
    -Dkarate.env=remote \ local [remote will point the tests to SeleniumBox]
    -DmotusWeburl=https://dev-motus.net/ \
    -DmotusAPIurl=https://api.motus.dev.-1.aws.cloud. \
    -Dbrowser=chrome \
    -Ddb_test=DV1G - DEBMW_DV1G\
    -Dschema_test=MDD\
    -Dtable1_test=TMDD01\
    -Dtable2_test=TMDD02\
    -DiwaUser=<***> \
    -DiwaPass=<***> \
    -DPostQUser=<****> \
    -DPostQPass=<****> \
    -Dkarate.options="--tags @jira-1367" \
    -f pom.xml
```

Explanation of Command
- ``mvn clean test``: This is the Maven command used to build and execute the tests.

- ``mvn``: The Maven command itself.
clean test: Maven goals to clean the project and run the tests.

- `-DselniumBToken=<****>`: Set the Selenium Bearer Token property to a specific value. This token is likely used for authentication or authorization in your tests.

- `-Dkarate.env=remote`: Set the Karate test environment to "remote." The test environment configuration can affect how your tests behave.

- `-DmotusWeburl=https://dev-motus.net/`: Set the base URL for the Motus web application. This is the URL where your tests will interact with the web application.

- `-DmotusAPIurl=https://api.motus.dev.-1.aws.cloud.`: Set the base URL for Motus API endpoints. This URL is used for API testing.

- `-Dbrowser=chrome`: Specify the web browser for test execution. In this case, it's set to "chrome," indicating that your tests will run in the Chrome browser.

- `-Ddb_test=DV1G - DEBMW_DV1G -Dschema_test=MDD -Dtable1_test=TMDD01 -Dtable2_test=TMDD02`: Specify Source DB details (applicable to inegrations tests otherwise leave the defalts)

- `-DiwaUser=<***>` and `-DiwaPass=<***>`: Set login credentials for IWA (Integrated Windows Authentication). These credentials are likely used for authenticating into a part of your application.

- `-DPostQUser=<****>` and `-DPostQPass=<****>`: Set login credentials for another part of the application. These credentials are used for authentication in a different section of your application.

- `-Dkarate.options="--tags @jira-1367"`: Specify Karate options to run only tests tagged with "@jira-1367." Tags are used to categorize and selectively run tests based on specific criteria.

- `-f pom.xml`: Specify the Maven POM file. The POM file defines project configuration and dependencies.

## Notes
Ensure you have Maven installed and configured properly.
 Replace `<****>` and `<***>` with the actual values needed for your tests.
Modify the base URLs, browser choice, and tags as per your testing requirements.
This command assumes a clean test environment and can be customized further based on your project setup.


## IntelliJ IDEA:
#### Step 1: 
- Import Your Maven Project

- Open IntelliJ IDEA.

- Go to ``File`` > ``Open`` and select your Maven project's root directory.

#### Step 2: 
- Configure Run Configuration

- In IntelliJ IDEA, go to the top menu and select "Run" > "Edit Configurations..."

- Click the `+` button in the top-left corner to add a new configuration.

- Select `Maven` from the dropdown menu.

- In the `Name` field, give your configuration a descriptive name, such as `Karate Tests.`

- In the `Command line` field, enter the Maven command you want to run. For example:


```bash
clean test  
-DselniumBToken=<****> 
-Dkarate.env=remote
-DmotusWeburl=<>
-DmotusAPIurl=<>
-Dbrowser=chrome
-Ddb_test=DV1G
-DEBMW_DV1G
-Dschema_test=MDD
-Dtable1_test=TMDD01
-Dtable2_test=TMDD02
-DiwaUser=<***>
-DiwaPass=<***>
-DPostQUser=<****>
-DPostQPass=<****>
-Dkarate.options="--tags @MDD-1367"
-f pom.xml
````
- Make sure to replace placeholders like `<****>` and `<***>` with actual values.

- Click `Apply` and then `OK` to save the configuration.

#### Step 3: 
Run Your Karate Tests

With your new configuration selected, click the green `Run` button or use the keyboard shortcut usually `Shift + F10` to run your Karate tests.
## Visual Studio Code (VSCode):
#### Step 1: 
- Open Your Project Folder

- Open Visual Studio Code.

- Open your project folder in VSCode.

#### Step 2: 
- Create a Launch Configuration

- In the left sidebar, click on the `Run and Debug` icon (represented by a play button).

- Click the gear icon (⚙️) to open the launch configuration settings.

- Click `Add Configuration...` to create a new launch configuration.

- Select `Maven` from the list of available configurations.

#### Command to Run Performance Tests

``` bash
-P gatling gatling:test -Dkarate.env=local -Dbrowser=chrome -DiwaUser=<***> -DiwaPass=<***> -DmotusWeburl=<***> -DmotusAPIurl=<***> -f pom.xml
```
#### NB:
unlike functional test, the command starts by specifying the gatling profile, this is to avoid conflicts with test when running performance tests
