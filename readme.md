# Pillow v1.2.2
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](https://fantom-lang.org/)
[![pod: v1.2.2](http://img.shields.io/badge/pod-v1.2.2-yellow.svg)](http://eggbox.fantomfactory.org/pods/afPillow)
[![Licence: ISC](http://img.shields.io/badge/licence-ISC-blue.svg)](https://choosealicense.com/licenses/isc/)

## Overview

Pillow is a web framework that maps HTTP request URLs to Pillow Pages, letting them react to RESTful events.

Pillow...

* Is a [BedSheet](http://eggbox.fantomfactory.org/pods/afBedSheet) framework
* Extends [efanXtra](http://eggbox.fantomfactory.org/pods/afEfanXtra) components
* Plays great with [Slim](http://eggbox.fantomfactory.org/pods/afSlim)
* Runs on [IoC](http://eggbox.fantomfactory.org/pods/afIoc)


Pillow - Something for your web app to get its teeth into!

## <a name="Install"></a>Install

Install `Pillow` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afPillow

Or install `Pillow` with [fanr](https://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afPillow

To use in a [Fantom](https://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afPillow 1.2"]

## <a name="documentation"></a>Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afPillow/) - the Fantom Pod Repository.

## <a name="quickStart"></a>Quick Start

1. Create a text file called `Example.efan`    Hello Mum! I'm <%= age %> years old!


2. Create a text file called `Example.fan`    using afIoc
    using afBedSheet
    using afEfanXtra
    using afPillow
    
    // ---- The only class you need! ----
    
    @Page
    const mixin Example : EfanComponent {
    
        @PageContext
        abstract Int age
    }
    
    // ---- Standard Main Class ----
    
    class Main {
        Int main() {
            afBedSheet::Main().main([AppModule#.qname, "8069"])
        }
    }
    
    // ---- Support class, needed when running from a script ----
    
    @SubModule { modules=[EfanXtraModule#, PillowModule#] }
    const class AppModule {
        @Contribute { serviceType=TemplateDirectories# }
        Void contributeEfanDirs(Configuration config) {
            // Look for Example.efan in the same dir as this fantom file
            config.add(`./`)
        }
    }


3. Run `Example.fan` as a Fantom script from the command line:    C:\> fan Example.fan
    
    Efan Library: 'app' has 1 page(s):
      Example : /example


4. Point your browser at `http://localhost:8069/example/42`    Hello Mum! I'm 42 years old!




## Usage

To create a web page, define an `EfanComponent` that is annotated with the [Page](http://eggbox.fantomfactory.org/pods/afPillow/api/Page) facet. Example:

    using afPillow::Page
    using afEfanXtra::EfanComponent
    
    @Page
    const mixin Admin : EfanComponent {
        ...
    }
    

[Pages](http://eggbox.fantomfactory.org/pods/afPillow/api/Page) are [efanXtra](http://eggbox.fantomfactory.org/pods/afEfanXtra) components and behave in exactly the same way.

Pillow will automatically route URLs with your page name, to your page. Camel casing class names results in a `/` delimiter. Examples:

    `/admin`        --> Admin.fan
    `/admin/secret` --> AdminSecret.fan

Or you can use the [@Page](http://eggbox.fantomfactory.org/pods/afPillow/api/Page) facet to define an explicit URL.

## Templates

EfanXtra, and hence Pillow, need to know where to look for template files. This is done by contributing to the `TemplateDirectories` service in your App Module:

    @Contribute { serviceType=TemplateDirectories# }
    Void contributeTemplateDirectories(Configuration config) {
        config.add(`efan-tempaltes/`)
    }
    

But if no configuration is given, then Pillow defaults to looking in the following directories:

* `etc/web-pages/`
* `etc/web-components/`


Template don't have to be on the file system, they may be pod files or even Type fandoc comments! See [efanXtra Templates](http://eggbox.fantomfactory.org/pods/afEfanXtra) for details.

## Welcome Pages

Pillow supports the routing of welcome pages, also known as directory pages, through the [WelcomePageStrategy](http://eggbox.fantomfactory.org/pods/afPillow/api/WelcomePageStrategy).

When switched on, whenever a request is made for a directory URL (one that ends with a /slash/) then `Pillow` will render the directory's [welcome page](http://eggbox.fantomfactory.org/pods/afPillow/api/PillowConfigIds.welcomePageName), which defaults to a page named `Index`. Examples:

    `/`        --> Index.fan
    `/admin/`  --> AdminIndex.fan

More can be read about directory URLs in the article: [Should Your URLs Point to the Directory or the Index Page?](http://www.thesitewizard.com/sitepromotion/directory-name-or-index-url.shtml)

The [welcome page strategy](http://eggbox.fantomfactory.org/pods/afPillow/api/WelcomePageStrategy) also supports redirects, where requests for legacy pages (like `/index.html`) are redirected to the directory URI. Redirects are preferred over serving up the same page for multiple URIs to avoid [duplicate content](http://moz.com/learn/seo/duplicate-content).

## Page Contexts

As seen in the [Quick Start](#quickStart) example, parts of the request path are automatically mapped to `@PageContext` fields. In our exmaple, the `42` in `http://localhost:8069/example/42` is mapped to the `age` page context field.

Declaring page context fields is actually shorthard for assigning fields manually from the `@InitRender` method. The [Quick Start](#quickStart) example could be re-written long hand as:

    @Page
    const mixin Example : EfanComponent {
        abstract Int age
    
        @InitRender
        Void initRender(Int age) {
            this.age = age
        }
    }
    

Note that a Pillow Page may choose to have *either* an `@InitRender` method or `@PageContext` fields, not both.

Any `@InitRender` method parameter with a default value becomes an optional URL parameter. Example:

    @Page
    const mixin Example : EfanComponent {
        @InitRender
        Void initRender(Int age := 69) { .. }
    }
    

Would respond to both of the following URLs:

    /example
    /example/42

### Custom URLs

To have your pages respond custom URLs, use the `url` field in the `@Page` facet. Similar to standard BedSheet routing, use `*` to replace page context parameters.

    @Page { url=`/example/*/edit` }
    const mixin Example : EfanComponent {
        @PageContext abstract name
    }
    

Would respond to URLs similar to:

    /example/steve/edit

### Skip Page Rendering

If `@InitRender` returns a non-null object, then page rendering is skipped and the returned object is passed to BedSheet for further processing.

This is useful for explicitly handling authentication and / or 404 errors. Example:

    @Page
    const mixin ExamplePage : EfanComponent {
    
        @InitRender
        Obj? initRender(Str fileName) {
            if (fileService.notFound(fileName))
                return HttpStatus(404, "File not found")
    
            if (!loggedInUser.isAuthorisedToView(ExamplePage#)
                return HttpRedirect.movedTemporarily(`/login`)
    
            return null
        }
    }
    

## Page Events

Page events allow pages to respond to RESTful actions by mapping URLs to page event methods. Page event methods are called in the context of the page they are defined. Denote page events with the `@PageEvent` facet.

Lets change our example so that the page context is a `Str` and introduce an event called `loves`:

    @Page
    const mixin Example : EfanComponent {
    
        @PageContext
        abstract Str name
    
        @PageEvent
        Void loves(Str meat) {
            echo("${name} loves ${meat}!")
        }
    }
    

Event URLs follow the pattern:

    <page name> / <page context(s)> / <event name> / <event context(s)>

So we can call the `loves` event with the URL `http://localhost:8069/example/Emma/loves/sausage`, which is broken down as:

    example --> 'Example#' page type
    Emma    --> 'name' field
    loves   --> 'loves()' method
    sausage --> 'meat' argument
    

Use `PageMeta.eventUrl(name, context)` to generate event URLs that can be used in templates.

Event methods are invoked before anything is rendered. The default action, should the event method be `Void` or return `null`, is to re-render the containing page.

Event methods may return any [BedSheet](http://eggbox.fantomfactory.org/pods/afBedSheet) response object.

It is standard practice to prefix event methods with the word `on`, so the `loves()` method could also be written as:

    @PageEvent
    Void onLoves(Str meat) {
        echo("${name} loves ${meat}!")
    }

But note that the event *name* (as used in the URL) is still `love`.

Note that any `@InitRender` method is called before the event method. This gives `@InitRender` a chance to assert access control.

### RESTful Services

Pillow can be used to easily create RESTful services. Simply use Page events to service the request and set the `@PageEvent.httpMethod` attribute to the required HTTP method:

    using afIoc
    using afBedSheet
    using afPillow
    
    @Page
    const mixin RestService {
        @Inject abstract HttpRequest  httpRequest
        @Inject abstract HttpResponse httpResponse
    
        new make(|This| in) { in(this) }
    
        @PageEvent { httpMethod="PUT" }
        Text onCreate(Int id) {
            // 'id' is supplied as part of the URL
    
            // use the request body to get submitted data as a JSON object
            json := httpRequest.body.jsonObj
    
            ...
    
            // return a different status code, e.g. 201 - Created
            httpResponse.statusCode = 201
    
            // return JSON objects to the client
            return Text.fromJsonObj(["response":"OK"])
        }
    }
    

## Page Meta

The [PageMeta](http://eggbox.fantomfactory.org/pods/afPillow/api/PageMeta) class holds information about the Pillow Page currently being rendered. Obviously, using `PageMeta` in a page class, returns information about itself! Which is quite handy.

Arguably the most useful method is `pageUrl()` which returns a URL that can be used, by a client, to render the page complete with the current page context. You can create new `PageMeta` instances with different page contexts by using the `withContext()` method. Using our example again:

    @Page
    const mixin Example : EfanComponent {
        @Inject abstract PageMeta pageMeta
    
        @PageContext
        abstract Int age
    
        Str renderLinkToSelf() {
            return "<a href='${pageMeta.pageUri}'>Link to ${age}</a>"
        }
    
        Str renderLinkTo69() {
            page69 := pageMeta.withContext([69]).pageUri
            return "<a href='${page69}'>Link to 69</a>"
        }
    }
    

`PageMeta` instances are [BedSheet](http://eggbox.fantomfactory.org/pods/afBedSheet) response objects and may be returned from route handlers. The Pillow `PageMeta` handler will then render the Pillow page.

Use the [Pages](http://eggbox.fantomfactory.org/pods/afPillow/api/Pages) service to create `PageMeta` instances for any Pillow page.

## Content Type

Page template files should use a double extension in their name, for example,

    IndexPage.html.slim

The outer extension denotes the type of templating to use, [Slim](http://eggbox.fantomfactory.org/pods/afSlim) in our example. The innter extension is used to find the [Content-Type](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.17) that is sent in the HTTP response header. In our example, the `Content-Type` would be set to `text/html`.

If a double extension is not used, or not know, then the default content type, as defined by the config value, is used.

Or you can use the [@Page](http://eggbox.fantomfactory.org/pods/afPillow/api/Page) facet to explicitly set the content type.

## Page Routes

HTTP requests are routed to pages and events via standard BedSheet routes. All the Pillow routes are contributed under a single contribution called `afPillow.pageRoutes`. So to disable Pillow routing, simply remove this contribution:

    @Contribute { serviceType=Routes# }
    static Void contributeRoutes(Configuration config) {
        config.remove("afPillow.pageRoutes")
    }

Should you wish to override any page route, contribute your own `Route` *before* the Pillow routes. That way your `Route` is processed first.

    @Contribute { serviceType=Routes# }
    static Void contributeRoutes(Configuration config) {
        config.add(Route(...)).before("afPillow.pageRoutes")
    }

## 404 and Err Pages

Pillow pages may be used as BedSheet 404 Status and 500 Error pages. To do so, contribute a `MethodCall` func to `Pages.renderPage()`:

To render `Error404Page` as a BedSheet 404 status page:

    @Contribute { serviceType=HttpStatusResponses# }
    Void contribute404Response(Configuration config) {
        config[404] = MethodCall(Pages#renderPage, [Error404Page#]).toImmutableFunc
    }
    

To render `Error500Page` as a BedSheet error page:

    @Contribute { serviceType=ErrResponses# }
    Void contributeErrResponses(Configuration config) {
        config[Err#] = MethodCall(Pages#renderPage, [Error500Page#]).toImmutableFunc
    }
    

Note that you should also disable routing for those pages so they can't be accessed directly by a URL.

    using afEfanXtra
    using afPillow
    
    @Page { disableRoutes=true }
    const mixin Error404Page : EfanComponent { ... }
    
    @Page { disableRoutes=true }
    const mixin Error500Page : EfanComponent { ... }
    

