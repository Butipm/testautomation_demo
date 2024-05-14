package automation.tests.uiTests;

import com.intuit.karate.junit5.Karate;

class UsersRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("intranetSample").relativeTo(getClass());
    }    

}
