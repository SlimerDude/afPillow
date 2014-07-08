
** [IocConfig]`http://repo.status302.com/doc/afIocConfig/` values as provided by 'Pillow'.
** To change their value, override them in your 'AppModule'. Example:
** 
** pre>
** using afIoc
** using afIocConfig
** using afPillow
**  
** class AppModule {
** 
**     @Contribute { serviceType=ApplicationDefaults# } 
**     static Void configureAppDefaults(MappedConfig config) {
**         config[PillowConfigIds.welcomePage] = "home"
**     }
** }
** <pre 
const class PillowConfigIds {
 
	** The component name (Str) of directory welcome pages.
	** 
	** Defaults to "index".
	static const Str welcomePageName		:=	"afPillow.welcomePageName"

	** The default 'Content-Type' to serve pages up as, if it can not be determined.
	** 
	** Defaults to 'MimeType("text/plain")'
	static const Str defaultContentType		:=	"afPillow.defaultContentType"

	** Set to 'false' to disable the automatic routing of request URLs to Pillow page rendering.
	** 
	** Defaults to 'true'.
	static const Str enableRouting			:=	"afPillow.enableRouting"

	** Set the welcome page strategy which defines the interaction between welcome page URIs and directory URIs.
	** 
	** Defaults to 'onWithRedirects'
	static const Str welcomePageStrategy	:=	"afPillow.welcomePageStrategy"

	** The 'cache-control' HTTP header value to set in rendered Pillow pages. 
	** The header is set just before the page is rendered, making it easy to override / re-set in any '@InitRender' method.   
	** 
	** Defaults to '"max-age=0, no-cache"'
	static const Str cacheControl			:=	"afPillow.cacheControl"

}
