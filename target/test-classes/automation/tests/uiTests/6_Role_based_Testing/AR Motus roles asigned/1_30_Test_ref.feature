@Test
Feature: test
  for help, see: https://github.com/intuit/karate/wiki/IDE-Support
  'http://localhost:4200/home'

  Background:
    * url testsWeb
    * print testsWeb
    * configure ssl = true


  @test-24293 @web @uitest @testTests
  Scenario: Test_AR test User PROD Role and promote <userName>:<role>
    Given driver testsWeb
    * delay(2000)
    * def actualUrl = driver.url
    * eval if (actualUrl === '') (driver.url = testWeb)
    * delay(1000)
    * driver.maximize()
    * refresh()
    * delay(3000)
    * def actualUrl = waitForUrl('https://auth.bmwgroup.net/')
    * def myLowerCaseactualUrl = actualUrl.toLowerCase()
    * eval
	"""
	if (myLowerCaseactualUrl.includes('auth') && myLowerCaseactualUrl.includes('bmwgroup.net')) {
		waitFor(webLoc.iwa_logonButton)
		//input(webLoc.iwa_userName, <userName>)
		//input(webLoc.iwa_password, )
		input(webLoc.f_userName, userNameName)
		input(webLoc.f_password, passWordWord)
		click(webLoc.f_logonButton)


	}

"""

#    * waitFor(webLoc.open).click()
#    * delay(1000)
#    And waitFor(webLoc.Subscription).click()
#    And waitFor(webLoc.Find_Subscription).click()
#    * delay(1000)
#    And input(webLoc.subscriptionId, subID)
#    And waitFor(webLoc.subSearchBtn).click()
#		# check no presence of error message on this scenario MDD-9959
#    * def findMSG = scriptAll('span ', '_.textContent', function(x){ return x.contains('Please select at least one criteria') })
#    * print findMSG
#    And match findMSG == []
#    * delay(2000)
#    * script('window.scrollBy(0,900)')
#    * delay(1000)
#
#    And waitFor(webLoc.btnView).click()
#    And waitFor(webLoc.pipeline_details_tab).click()
#        * print 'subId:',subID
#
#  #Ensure you cannot view config via config buttons
#    * def butttonexist = exists("{}view config")
#    * def checkboxexist = exists("//*[@id='bmw.test.cdc.v1.mdd.tmdd01_replicatorEngine_checkBox']")
#    And eval if(butttonexist || checkboxexist ){karate.fail('view config is there')}

    * delay(15000)
    * driver.quit()



#    Examples:
#      | userName | userPass | userName2 | userPass2 | role              | appid     | subtype    | dbSelect          | dataownership | schemaarray | tablearray    | data_desti | dbVendor   | DB_Server                                                               | port | DB_Name | DB_promote           |
#      | qquser1  | qqpass1  | qquser2   | qqpass2  | AR test User PROD | APP-31567 | DECOUPLING | DV1G - DEBMW_DV1G | No            | MDD         | TMDD01,TMDD02 | DATABASE   | PostgreSQL | mtos-dev-euc1-test-pg-main.c8ykfomwr7ir.eu-central-1.rds.amazonaws.com | 5432 | testDb  | DP1G - BMWAG_P_DB2X1 |
