#lang scribble/manual
@require[@for-label[scribble-math
                    racket/base
                    scribble/core]
         @for-syntax[racket/base
                     syntax/parse]
         scribble-math]


@(define-syntax scribbleblock
   (syntax-parser
     [(_ (~optional (~seq #:keep-lang-line? keep-lang))
         str ...+)
      #`(codeblock
         #:keep-lang-line? #,(if (attribute keep-lang) #'keep-lang #'#f)
         "#lang scribble/base" "\n"
         str ...)]))

@(define-syntax scribblecode
   (syntax-parser
     [(_ str ...+)
      #`(code #:lang "scribble/base"
              str ...)]))

@(use-mathjax)

@title[#:style (with-html5 manual-doc-style)]{@racketmodname[scribble-math]}
@author[
 @author+email["Georges Dupéron" "georges.duperon@gmail.com"]
 @author+email["Jens Axel Søgaard" "jensaxel@soegaard.net"]]

@defmodule[scribble-math]

This library allows typesetting math and Asymptote figures
in Scribble documents.

@(local-table-of-contents #:style 'immediate-only)

@section{Typesetting math with @racket[$] and @racket[$$]}
@defmodule[scribble-math/dollar]

@(define title-html5-code
   @scribblecode|{@title[#:style (with-html5 manual-doc-style)]{…}}|)

The following functions help with typesetting mathematical
equations. The main functions are @racket[$] for inline mode
math, @racket[$$] for display mode math. The functions 
@racket[use-katex] and @racket[use-mathjax] change the
rendering engine used, the default being @racket[katex]. To
use @racket[katex], it is necessary to use 
@title-html5-code or a similar configuration, see the
documentation for @racket[with-html5] for more details.

@defproc[($ [str string?] ...) element?]{
 Renders the given strings as inline math, using MathJax or
 KaTeX for the HTML output, depending on the current
 configuration. For the LaTeX output, the code is simply
 passed as-is. For example, when using MathJax, 
 @racket[($ "x^2")] renders as
 @(use-mathjax) @${x^2}.

 The syntax accepted by @racket[$] is a subset of the
 commands supported by LaTeX, and depends on the backend
 used (MathJax should support more commands than KaTeX). For
 details, see their respective documentation.}

@defproc[($$ [str string?] ...) element?]{
 Renders the given strings as display math (centered, alone
 on its line), using MathJax or KaTeX for the HTML output,
 depending on the current configuration. For the LaTeX
 output, the code is simply passed as-is. For example, when
 using MathJax,
 
 @racketblock[($$ "\\sum_{i=0}^n x_i^3")]

 renders as:

 @(use-mathjax)
 @$${\sum_{i=0}^n x_i^3}

 The syntax accepted by @racket[$] is a subset of the
 commands supported by LaTeX, and depends on the backend
 used (MathJax should support more commands than KaTeX). For
 details, see their respective documentation.}

@defproc[(with-html5 [doc-style style?]) style?]{
 Alters the given document style, so that the resulting
 document uses HTML5.

 This function should be called to alter the 
 @racket[#:style] argument for @racket[title] when KaTeX is
 used, as KaTeX is incompatible with the default scribble 
 @tt{DOCTYPE} (the HTML 4.01 Transitional loose DTD). The
 scribble document should therefore contain code similar to
 the following:
 
 @scribbleblock|{
  @title[#:style (with-html5 manual-doc-style)]{...}
  }|

 This function works by changing the existing 
 @racket[html-defaults] property or adding a new one, so
 that it uses an HTML5
 @tech[#:doc '(lib "scribblings/scribble/scribble.scrbl")]{prefix file}
 (the @tech[#:doc '(lib "scribblings/scribble/scribble.scrbl")]{prefix file}
 contains the @tt{DOCTYPE} line).}

@defparam[$-html-handler handler (→ (listof? string?) element?)
          #:value $-katex]{
 A parameter whose values is a function called by 
 @racket[$], to transform the math code into HTML. The 
 @racket[$] function uses this parameter only when rendering
 the document as HTML.}

@defparam[$$-html-handler handler (→ (listof? string?) element?)
          #:value $$-katex]{
 A parameter whose values is a function called by 
 @racket[$], to transform the math code into HTML. The 
 @racket[$] function uses this parameter only when rendering
 the document as HTML.
}

@defproc[($-katex [math (listof? string?)]) element?]{
 Produces an @racket[element?] which contains the given 
 @racket[math] code, so that it is rendered as inline math
 using KaTeX. More precisely, the resulting element uses
 several scribble properties to add scripts and stylesheets
 to the document. The resulting element also uses a specific
 CSS class so that when the page is loaded into a browser,
 KaTeX can recognise it and render it in inline mode.}

@defproc[($$-katex [math (listof? string?)]) element?]{
 Produces an @racket[element?] which contains the given 
 @racket[math] code, so that it is rendered as display math
 (centered, alone on its line) using KaTeX. More precisely,
 the resulting element uses several scribble properties to
 add scripts and stylesheets to the document. The resulting
 element also uses a specific CSS class so that when the
 page is loaded into a browser, KaTeX can recognise it and
 render it in display mode.}

@defproc[($-mathjax [math (listof? string?)]) element?]{
 Produces an @racket[element?] which contains the given 
 @racket[math] code, so that it is rendered as inline math
 using MathJax. More precisely, the resulting element uses
 several scribble properties to add scripts and stylesheets
 to the document. The resulting element also uses a specific
 CSS class so that when the page is loaded into a browser,
 MathJax can recognise it and render it in inline mode.}

@defproc[($$-mathjax [math (listof? string?)]) element?]{
 Produces an @racket[element?] which contains the given 
 @racket[math] code, so that it is rendered as display math
 (centered, alone on its line) using KaTeX. More precisely,
 the resulting element uses several scribble properties to
 add scripts and stylesheets to the document. The resulting
 element also uses a specific CSS class so that when the
 page is loaded into a browser, MathJax can recognise it and
 render it in display mode.}

@defproc[(use-katex) void?]{
 This shorthand calls @racket[($-html-handler $-katex)]
 and @racket[($$-html-handler $$-katex)]. The mathematical
 formulas passed to @racket[$] and @racket[$$] which appear
 later in the document will therefore be typeset using
 KaTeX.

 The KaTeX library will be added to the HTML document only
 if is uses the result of one of @racket[$], @racket[$$], 
 @racket[$-katex] or @racket[$$-katex]. It is therefore safe
 to call this function in libraries to change the default
 handler, without the risk of adding extra resources to the
 page if the user changes the default before typesetting any
 math.}

@defproc[(use-mathjax) void?]{
 This shorthand calls @racket[($-html-handler $-mathjax)]
 and @racket[($$-html-handler $$-mathjax)]. The mathematical
 formulas passed to @racket[$] and @racket[$$] which appear
 later in the document will therefore be typeset using
 MathJax.


 The MathJax library will be added to the HTML document only
 if is uses the result of one of @racket[$], @racket[$$], 
 @racket[$-katex] or @racket[$$-katex]. It is therefore safe
 to call this function in libraries to change the default
 handler, without the risk of adding extra resources to the
 page if the user changes the default before typesetting any
 math.}

@;@$${\sum_{i=0}ⁿ xᵢ³}

When using MathJax, @racket[$] and @racket[$$] wrap their
content with @racket["$…$"] and @racket["\\[…\\]"]
respectively, and insert it in an element with the style 
@racket["tex2jax_process"]. MathJax is configured to only
process elements with this class, so it is safe to use
@tt{$} signs in the source document. For example, the text
$\sum x^3$ is displayed as-is, like the rest of the text.

@section{Drawing figures with Asymptote}

@defmodule[scribble-math/asymptote]

@defproc[(asymptote [#:cache cache? any/c #t] [str string?] ...+) image?]{
 Renders the figure described by the given strings using
 Asymptote. If @racket[cache?] is @racket[#f], then the
 resulting images are generated into temporary PNG, SVG and
 PDF files are generated using @racket[make-temporary-file].
 Otherwise, to improve compilation speed, the result is
 cached in the @filepath{asymptote-images} directory, based
 on a checksum of the strings. It is a good idea to clean up
 the working directory after experimenting a lot with a
 figure, as it will be cluttered with stale cached files.

 If the Asymptote code is dynamically generated, make sure
 that the result is always the same, or use 
 @racket[#:cache #f]. Otherwise, each compilation would
 cause a new file to be generated.

 The @tt{asy} executable must be installed on the
 machine that renders the figures. If the results are
 already cached, then the scribble document can be compiled
 without installing Asymptote.

 As an example, the the code
 
 @scribbleblock|{
  @asymptote{
   import drawtree;
   size(4cm, 0);
   TreeNode root = makeNode("let");
   TreeNode bindings = makeNode(root, "bindings");
   TreeNode binding = makeNode(bindings, "binding");
   TreeNode bid = makeNode(binding, "id");
   TreeNode bexpr = makeNode(binding, "expr");
   TreeNode bindingddd = makeNode(bindings, "\vphantom{x}\dots");
   TreeNode body = makeNode(root, "body");
   TreeNode bodyddd = makeNode(root, "\vphantom{x}\dots");

   draw(root, (0,0));
   shipout(scale(2)*currentpicture.fit());
  }
 }|
 
 renders as:
 
 @asymptote{
  import drawtree;
  size(4cm, 0);
  TreeNode root = makeNode("let");
  TreeNode bindings = makeNode(root, "bindings");
  TreeNode binding = makeNode(bindings, "binding");
  TreeNode bid = makeNode(binding, "id");
  TreeNode bexpr = makeNode(binding, "expr");
  TreeNode bindingddd = makeNode(bindings, "\vphantom{bg}\dots");
  TreeNode body = makeNode(root, "body");
  TreeNode bodyddd = makeNode(root, "\vphantom{bg}\dots");

  draw(root, (0,0));
  shipout(scale(2)*currentpicture.fit());
 }
}