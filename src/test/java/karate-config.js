function fn() {
	// get system property from maven cmd eg 'karate.env'
	var env = karate.env;
	var testsWeburl = karate.properties["testsWeburl"];
	var testsAPIurl = karate.properties["testsAPIurl"];
	var browser = karate.properties["browser"];
	var userName = karate.properties["userName"];
	var passWord = karate.properties["passWord"];
	var selniumBToken = karate.properties["selniumBToken"];
    var usersAndPasses = karate.properties["usersAndPasses"];


    //Split the usernames and passwords for role based testing
    var userPassPairs = usersAndPasses.split(",");
    var users = [];
    var passwords = [];

    for (var i = 0; i < userPassPairs.length; i++) {
        var pair = userPassPairs[i].split(":");
        users.push(pair[0]);
        passwords.push(pair[1]);
    }

    karate.log("Users: ", users);
    karate.log("Passwords: ", passwords);

// Access each user and password separately
    var user1 = users[0];
    var pass1 = passwords[0];
    var user2 = users[1];
    var pass2 = passwords[1];
    var user3 = users[2];
    var pass3 = passwords[2];
    var user4 = users[3];
    var pass4 = passwords[3];




	// Set defaults in case of running local: Browser and driver as per local and selenium-box
	if (!browser) {
		browser = "chrome";
		typedriver = "chrome";
	} else if (browser === "chrome") {
		browser = "chrome";
		typedriver = "chromedriver";
	} else if (browser === "firefox") {
		browser = "firefox";
		typedriver = "geckodriver";
	} else if (browser === "MicrosoftEdge") {
		browser = "MicrosoftEdge";
		typedriver = "msedgedriver";
	} else if (browser === "iexplore") {
		browser = "internet explorer";
		typedriver = "iedriver";
	}

	// assign the variable either from Mvn cmd or defaults for driver config
	var config = {
		env: env,
		testsWeb: testsWeburl ? testsWeburl.toString() : '',
		userNameName: userName ? userName.toString() : '',
		passWordWord: passWord ? passWord.toString() : '',
		testsApi: testsAPIurl ? testsAPIurl.toString() : '',
		browsertype: browser ? browser.toString() : '',
        qquser1: user1 ? user1.toString() : '',
        qqpass1: pass1 ? pass1.toString() : '',
        qquser2: user2 ? user2.toString() : '',
        qqpass2: pass2 ? pass2.toString() : '',
        qquser3: user3 ? user3.toString() : '',
        qqpass3: pass3 ? pass3.toString() : '',
        qquser4: user4 ? user4.toString() : '',
        qqpass4: pass4 ? pass4.toString() : '',


	};

	function configureDriverWithRetry(driverConfig, retryCount) {
		var retry = retryCount || 1;
		try {
			karate.configure("driver", driverConfig);
		} catch (error) {
			if (retry > 0) {
				karate.log("Error configuring driver, retrying ...");
				karate.log(error);
				karate.sleep(5000);
				configureDriverWithRetry(driverConfig, retry - 1);
			} else {
				karate.log("Failed to configure driver after retries");
				// Log error stack trace for detailed error information
				karate.log(error.stack);
				throw error;
			}
		}
	}

	if (env === "local") {
		// run test on the local machine, note if you are using 32-bit machine , change the executable path 'C:/Program Files (x86)/.../chrome'
		var os = java.lang.System.getProperty('os.name').toLowerCase();


		// Print the OS
		karate.log("OS: ", os);

		// Check if the operating system is Windows
		if (os.indexOf("win") >= 0) {
			var chromeExecutablePath = "C:/Program Files/Google/Chrome/Application/chrome.exe";
		} else {

			var chromeExecutablePath = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";
		}
		var driverConfig1 = {

			type: "chrome",
			executable: chromeExecutablePath,
			addOptions: ["--ignore-certificate-errors","--incognito","--disable-web-security"],
			port: 9222,
			headless: false,
		};
		karate.configure("driver", driverConfig1);
	} else if (env === "remote") {
		//For Remote execution use the below seleniumbox capabilities
		var session = {
			capabilities: {
				browserName: browser,
			},
			desiredCapabilities: {
                maxInstances: 5,
                maxSessions: 5,
                sessionTimeout: "5m",
				e34: true,
				"e34:token": selniumBToken,
				"e34:video": true,
				takesScreenshot: true,
				browserName: browser,
				"e34:pacAlias": "proxy_muc",
				"e34:l_testName": karate.info.scenarioName,
			},
		};
		var driverConfig = {
			type: typedriver,
			addOptions: ["--ignore-certificate-errors","--incognito"],
			start: false,
			webDriverUrl: "https://seleniumbox/wd/hub",
			webDriverSession: session,
		};
		configureDriverWithRetry(driverConfig, 4); // retry 3 times
	}
	//load weblocators from json file
	var result = read("classpath:locators.json");
	config.webLoc = result;

	var karateOptions = karate.properties['karate.options'];



	karate.configure("connectTimeout", 60000);
	karate.configure("readTimeout", 60000);
	karate.configure("logPrettyRequest", true);
	karate.configure("logPrettyResponse", true);
	//karate.configure('retry', {count: 10, interval: 1500});
	karate.configure("retry", {count: 20, interval: 1500});

	return config;
}
