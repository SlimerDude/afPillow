using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afPillow"
		summary = "A library for integrating efanXtra components with the afBedSheet web framework"
		version = Version("0.0.5")

		meta	= [	"org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"vcs.uri"		: "https://bitbucket.org/Alien-Factory/afpillow",
					"proj.name"		: "Pillow",
					"license.name"	: "BSD 2-Clause License",	
					"repo.private"	: "true"

					,"afIoc.module"	: "afPillow::PillowModule"
				]

		index	= [	"afIoc.module"	: "afPillow::PillowModule"
				]


		depends = ["sys 1.0", "afIoc 1.4.10+", "afIocConfig 0+", "afBedSheet 1.1+", "afEfanXtra 0+", "afEfan 1.3+", "afPlastic 1.0.4+"]
		srcDirs = [`test/unit-tests/`, `test/app-tests/`, `test/app/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [`doc/`, `test/app/`]

		docApi = true
		docSrc = true

		// exclude test code when building the pod
//		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
//		resDirs = resDirs.exclude { it.toStr.startsWith("test/") }
	}
}
