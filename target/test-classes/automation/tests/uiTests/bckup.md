```
#    And eval
#for (var j = 0; j < arraytable.length; j++) {
#    var status = text("//*[@id='" + arraytable[j] + "-channelStatus']");
#    console.log("status is:"+status )
#
#    while (status !== 'Ready') {
#        console.log("Waiting for element with ID: " + arraytable[j]);
#        refresh();
#        delay(2000); // Adjust delay as needed
#        waitFor(webLoc.pipeline_details_tab).click(); // Add this line to navigate back to pipeline details tab
#        status = text("//*[@id='" + arraytable[j] + "-channelStatus']");
#    }
#}
#    """
#
#    And eval
#"""
#
#
#var maxWaitTime = 70000; // Maximum wait time in milliseconds (70 seconds)
#var startTime = new Date().getTime();
#
#for (var j = 0; j < arraytable.length; j++) {
#    var j = 0;
#    while (j < arraytable.length) {
#        var currentTime = new Date().getTime();
#        var elapsedTime = currentTime - startTime;
#        if (elapsedTime > maxWaitTime) {
#            throw new Error("Timeout: Deployment status not 'Ready' within 70 seconds.");
#        }
#        var status = text("//*[@id='" + arraytable[j] + "-deploymentStatus']");
#        if (status === 'Ready') {
#        karate.log("Status :"+status)
#            // Proceed with further actions
#            break; // Exit the loop as status is 'Ready'
#        } else {
#            delay(2000); // Adjust delay as needed
#            refresh(); // Refresh the page
#            waitFor(webLoc.pipeline_details_tab).click(); // Add this line to navigate back to pipeline details tab
#        }
#        j++;
#    }
#}
#"""
#
#
#    * refresh()
#    * delay(10000)
#    And waitFor(webLoc.pipeline_details_tab).click()
#    * script('window.scrollBy(0,900)')
#
#    * waitFor("{}Promote Subscription").click()
#    * delay(2000)
#    # assert the validate connection btn is disabled
#    And match enabled("//*[@id='btn-test-target']") == false
#
#    * waitFor(webLoc.Data_Destination).click()
#    * delay(1000)
#    And waitFor('{^span}' + DB_promote).click()
#
#    And waitFor(webLoc.DB_Vendor).click()
#    And waitFor('{^span}' + dbVendor).click()
#    * input('body', Key.ESCAPE)
#    * delay(6000)
#
#    And input(webLoc.promote_Password, PostGresPass)
#    And input(webLoc.promote_Port, port)
#    And input(webLoc.promote_HostName, DB_Server)
#
#    #assert you cannot continue
#    And click(webLoc.connection_test)
#
#
#    And input(webLoc.promote_DBname, DB_Name)
#    And input(webLoc.promote_Username, PostGresUser)
#    #insert everything and validate connection details
#    And click(webLoc.connection_test)
#
#    * waitFor(webLoc.promote_sub_btn).click()
#    * delay(1000)
#
#    * waitUntil("document.querySelector('span.ds-message__text').offsetHeight > 0")
#    * def findMSG2 = script("document.querySelector('span.ds-message__text').textContent")
#
#		#assert a success message pops up
#    * print findMSG2
#    And match findMSG2 contains 'Request was successful'
#    * delay(3000)
#
#    * refresh()
#    And waitFor(webLoc.pipeline_details_tab).click()
#    And match enabled('#btn-open-promote-subscription-modal') == false
#    And waitFor('{}PROD Environment').click()
#    * delay(1000)
#    * script('window.scrollBy(0,900)')
#    * delay(1000)
#    And match enabled('#btn-open-promote-subscription-modal') == false
```
