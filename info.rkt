#lang info
(define collection "scribble-math")
(define deps '("base"
               "rackunit-lib"
               "scribble-lib"))
(define build-deps '("scribble-lib"
                     "racket-doc"
                     "at-exp-lib"
                     "scribble-doc"))
(define scribblings '(("scribblings/scribble-math.scrbl" ())))
(define pkg-desc "Description Here")
(define version "0.0")
(define pkg-authors '(georges))
