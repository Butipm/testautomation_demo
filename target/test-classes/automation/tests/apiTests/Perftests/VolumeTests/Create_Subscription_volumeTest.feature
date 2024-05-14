@ignore
Feature: Create Subscription using API
	#As the MDD feature team I want to create a working Kafka JDBC Sink Connector Configuration so that I can emit data to a target data store.

	#Tests As the MDD feature team I want to create a process for creating a Kafka JDBC Sink Connector so that they can emit data to a target data store.

	Background:
		* url testsAPIurl
		* configure ssl = true
	  	* configure retry = { count: 10, interval: 30000 }
		* def requestload = read('classpath:subscriptio20Tables.json')
    * def tableData = read('classpath:perfTestData20table.csv')

    * def tableCount = tableData.length

    * eval
    """
    for (var i = 0; i < tableCount; i++) {
      var generateDataSource = {
        "identifier": {
          "tableName": tableData[i].tableName,
          "schemaName": tableData[i].schemaName,
          "dataSourceType": tableData[i].dataSourceType
        },
        "options": {
          "containsClassifiedData": Boolean(tableData[i].containsClassifiedData)
        }
      };
      karate.appendTo(requestload.dataSources, generateDataSource);
      karate.appendTo(requestload.dataTargets.username,PostGresUser);
      karate.appendTo(requestload.dataTargets.password,PostGresPass);
    }
    """
    * print requestload

	@MDD-2108 @volumeTests @api @ignore
	Scenario:Test Validate the creation of the Subscription via API
		Given path '/subscriptions'
    And header Authorization = 'Bearer ' + accessToken
		And request requestload
		When method POST
		* print response
		Then status 201
	# All specifications are created
		And assert response.status == 'PENDING_APPROVAL'
		And assert for(var i=0;i<response.subscriptionItems.length;i++) response.subscriptionItems[i].channelSpecification.deployments.length == 0
		And assert for(var i=0;i<response.subscriptionItems.length;i++) response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[0].deployments.length == 0
		And assert for(var i=0;i<response.subscriptionItems.length;i++) response.subscriptionItems[i].dataTransportSpecification.deployments.length == 0
		* def subId = response._id

		* path '/subscriptions/'+subId
	# Until Subscription is approved and all deployments for the first environment are created
		And retry until response.status == 'APPROVED' && response.subscriptionItems[0].channelSpecification.deployments.length == 1 && response.subscriptionItems[0].channelSpecification.targetEmitterSpecifications[0].deployments.length == 1 && response.subscriptionItems[0].dataTransportSpecification.deployments.length == 1
		And header Authorization = 'Bearer ' + accessToken
		When method GET
		Then status 200
	# Verify all deployments are requested
		And eval
    """
	 for(var i=0; i < response.subscriptionItems.length ; i++) {
	    for(var x=0; x < response.subscriptionItems[i].channelSpecification.deployments.length; x++) {
	     	response.subscriptionItems[i].channelSpecification.deployments[x].status == 'REQUESTED'
	     	response.subscriptionItems[i].channelSpecification.deployments[x].environment == 'DEV'
	     	response.subscriptionItems[i].channelSpecification.deployments[x].resourceName == null
	     	response.subscriptionItems[i].channelSpecification.deployments[x].resourceId == null
	    }

	    for(var x=0; x < response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications.length; x++) {
	    	for(var y=0; y < response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[x].deployments.length; y++) {
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].status == 'REQUESTED'
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].environment == 'DEV'
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].resourceName == null
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].resourceId == null
	     	}
	    }

	    for(var x=0; x < response.subscriptionItems[i].dataTransportSpecification.deployments.length; x++) {
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].status == 'REQUESTED'
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].environment == 'DEV'
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].resourceName == null
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].resourceId == null
	    }
	 }
    """
	  * def subId = response._id
	  * path '/subscriptions/'+subId
	  And retry until for(var i=0;i<response.subscriptionItems.length;i++) response.subscriptionItems[0].channelSpecification.deployments[0].status == 'IN_PROGRESS'
	  And header Authorization = 'Bearer ' + accessToken
	  When method GET
	  Then status 200
	# Verify topic deployments have are in progress and CDC & JDBC Sink Connector deployments are requested
	  And eval
    """
	 for(var i=0; i < response.subscriptionItems.length ; i++) {
	    for(var x=0; x < response.subscriptionItems[i].channelSpecification.deployments.length; x++) {
	     	response.subscriptionItems[i].channelSpecification.deployments[x].status == 'IN_PROGRESS'
	     	response.subscriptionItems[i].channelSpecification.deployments[x].environment == 'INT'
	     	response.subscriptionItems[i].channelSpecification.deployments[x].resourceName != null
	     	response.subscriptionItems[i].channelSpecification.deployments[x].resourceId != null
	    }

	    for(var x=0; x < response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications.length; x++) {
	    	for(var y=0; y < response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[x].deployments.length; y++) {
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].status == 'REQUESTED'
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].environment == 'DEV'
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].resourceName == null
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].resourceId == null
	     	}
	    }

	    for(var x=0; x < response.subscriptionItems[i].dataTransportSpecification.deployments.length; x++) {
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].status == 'REQUESTED'
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].environment == 'DEV'
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].resourceName == null
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].resourceId == null
	    }
	 }
    """

	  * def subId = response._id
	  * path '/subscriptions/'+subId
	  And retry until for(var i=0;i<response.subscriptionItems.length;i++) response.subscriptionItems[0].channelSpecification.targetEmitterSpecifications[0].deployments[0].status == 'IN_PROGRESS'
	  And header Authorization = 'Bearer ' + accessToken
	  When method GET
	  Then status 200
	# Verify JDBC Sink Connector deployments are in progress and CDC deployments are requested
	  And eval
    """
	 for(var i=0; i < response.subscriptionItems.length ; i++) {
	    for(var x=0; x < response.subscriptionItems[i].channelSpecification.deployments.length; x++) {
	     	response.subscriptionItems[i].channelSpecification.deployments[x].status == 'IN_PROGRESS'
	     	response.subscriptionItems[i].channelSpecification.deployments[x].environment == 'DEV'
	     	response.subscriptionItems[i].channelSpecification.deployments[x].resourceName != null
	     	response.subscriptionItems[i].channelSpecification.deployments[x].resourceId != null
	    }

	    for(var x=0; x < response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications.length; x++) {
	    	for(var y=0; y < response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[x].deployments.length; y++) {
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].status == 'IN_PROGRESS'
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].environment == 'DEV'
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].resourceName != null
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].resourceId != null
	     	}
	    }

	    for(var x=0; x < response.subscriptionItems[i].dataTransportSpecification.deployments.length; x++) {
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].status == 'REQUESTED'
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].environment == 'DEV'
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].resourceName == null
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].resourceId == null
	    }
	 }
    """

	  * def subId = response._id
	  * path '/subscriptions/'+subId
	  And retry until for(var i=0;i<response.subscriptionItems.length;i++) response.subscriptionItems[0].dataTransportSpecification.deployments[0].status == 'IN_PROGRESS'
	  And header Authorization = 'Bearer ' + accessToken
	  When method GET
	  Then status 200
	# Verify CDC deployments are prepared
	  And eval
    """
	 for(var i=0; i < response.subscriptionItems.length ; i++) {
	    for(var x=0; x < response.subscriptionItems[i].channelSpecification.deployments.length; x++) {
	     	response.subscriptionItems[i].channelSpecification.deployments[x].status == 'IN_PROGRESS'
	     	response.subscriptionItems[i].channelSpecification.deployments[x].environment == 'DEV'
	     	response.subscriptionItems[i].channelSpecification.deployments[x].resourceName != null
	     	response.subscriptionItems[i].channelSpecification.deployments[x].resourceId != null
	    }

	    for(var x=0; x < response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications.length; x++) {
	    	for(var y=0; y < response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[x].deployments.length; y++) {
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].status == 'IN_PROGRESS'
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].environment == 'DEV'
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].resourceName != null
	     		response.subscriptionItems[i].channelSpecification.targetEmitterSpecifications[y].deployments[y].resourceId != null
	     	}
	    }

	    for(var x=0; x < response.subscriptionItems[i].dataTransportSpecification.deployments.length; x++) {
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].status == 'IN_PROGRESS'
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].environment == 'DEV'
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].resourceName != null
	     	response.subscriptionItems[i].dataTransportSpecification.deployments[x].resourceId != null
	    }
	 }
    """
