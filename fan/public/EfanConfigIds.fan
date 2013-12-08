
** Config values as provided by BedSheetEfanExtra.
const mixin EfanConfigIds {

	** The name of directory welcome pages.
	** Defaults to "index".
	static const Str welcomePage		:=	"afEfan.welcomePage"

	** TODO: needs to be an enum
	** - redirectDirectoryToWelcomePage
	** - redirectWelcomePageToDirectory
	** - off
	** Note this affects how clientUri's are reported by Pages 
//	static const Str redirectStrategy	:=	"afEfan.redirectStrategy"

}