using afIoc::Inject
using afEfanExtra::Component

** Your web pages should extend this!
@Component
const mixin Page {
	
	@NoDoc
	@Inject abstract Pages _af_pages

	** Returns the Uri that is used to route requests to your page.
	** Use it to print links to your page:
	** 
	** Efan snippet:
	** pre>
	** <a href="<% pages[MyPage#].clientUri %>"> My Awesome Page </a>
	** <pre  
	Uri clientUri() {
		_af_pages.clientUri(typeof)
		
		// TODO: add extra mod path to uris
		// TODO: add passivate info to uris
	}
	
}
