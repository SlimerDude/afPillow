using afIoc
using afIocConfig
using afBedSheet
using afBounce

internal class TestWelcomePageStrategy : PillowTest {

	Void testOff() {
		start(T_AppModule03#)
		verifyEq(client.get(`/start`	 ).statusCode, 200) 
		verifyEq(client.get(`/`			 ).statusCode, 404) 
		verifyEq(client.get(`/start.html`).statusCode, 404) 
	}

	Void testOffWithRedirects() {
		start(T_AppModule04#)
		verifyEq(client.get(`/start`	 ).statusCode, 200)
		verifyEq(client.get(`/`			 ).statusCode, 307)
		verifyEq(client.lastResponse.headers.location, `/start`)
		verifyEq(client.get(`/start.html`).statusCode, 404) 
	}

	Void testOn() {
		start(T_AppModule05#)
		verifyEq(client.get(`/start`	 ).statusCode, 404) 
		verifyEq(client.get(`/`			 ).statusCode, 200) 
		verifyEq(client.get(`/start.html`).statusCode, 404) 
	}
	
	Void testOnWithRedirects() {
		start(T_AppModule06#)
		verifyEq(client.get(`/start`	 ).statusCode, 307)
		verifyEq(client.lastResponse.headers.location, `/`)
		verifyEq(client.get(`/`			 ).statusCode, 200) 
		// is no-longer a 307 redirect due to BedSheet no-longer serving regex routes 
		verifyEq(client.get(`/start.html`).statusCode, 404)
	}
	
	override Void setup() {	}
	private Void start(Type module) {
		server := BedServer(T_AppModule#).addModule(module).startup
		client = server.makeClient
		client.errOn4xx.enabled = false
		client.followRedirects.enabled = false
	}
}

internal const class T_AppModule03 {
	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeApplicationDefaults(Configuration config) {
		config[PillowConfigIds.welcomePageName] 	= "start"
		config[PillowConfigIds.welcomePageStrategy] = WelcomePageStrategy.off
	}
}

internal const class T_AppModule04 {
	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeApplicationDefaults(Configuration config) {
		config[PillowConfigIds.welcomePageName] 	= "start"
		config[PillowConfigIds.welcomePageStrategy] = WelcomePageStrategy.offWithRedirects
	}
}

internal const class T_AppModule05 {
	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeApplicationDefaults(Configuration config) {
		config[PillowConfigIds.welcomePageName] 	= "start"
		config[PillowConfigIds.welcomePageStrategy] = WelcomePageStrategy.on
	}
}

internal const class T_AppModule06 {
	@Contribute { serviceType=ApplicationDefaults# }
	static Void contributeApplicationDefaults(Configuration config) {
		config[PillowConfigIds.welcomePageName] 	= "start"
		config[PillowConfigIds.welcomePageStrategy] = WelcomePageStrategy.onWithRedirects
	}
}