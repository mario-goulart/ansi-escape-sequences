#!/bin/sh
#| -*- scheme -*-
exec csi -s $0 "$@"
|#
; Author: Erik Falor <ewfalor@gmail.com>
; CHICKEN Scheme port of the venerable 256colors2.pl program to demonstrate
; 256 color capabilities of xterm-compatible terminal emulators
;
; Originally:
; Author: Todd Larason <jtl@molehill.org>
; $XFree86: xc/programs/xterm/vttests/256colors2.pl,v 1.2 2002/03/26 01:46:43 dickey Exp $

(import ansi-escape-sequences srfi-1)

;; use the resources for colors 0-15 - usually more-or-less a
;; reproduction of the standard ANSI colors, but possibly more
;; pleasing shades

;; colors 16-231 are a 6x6x6 color cube
(do ((red 0 (add1 red))) ((= red 6))
  (do ((green 0 (add1 green))) ((= green 6))
        (do ((blue 0 (add1 blue))) ((= blue 6))
          (print* (set-color256!
                                (+ 16 (* red 36) (* green 6) blue)
                                (if (zero? red) red (+ (* red 40) 55))
                                (if (zero? green) green (+ (* green 40) 55))
                                (if (zero? blue) blue (+ (* blue 40) 55)))))))

;; colors 232-255 are a grayscale ramp, intentionally leaving out
;; black and white
(for-each
  (lambda (gray)
        (let ((level (+ 8 (* 10 gray))))
          (print* (set-color256! (+ 232 gray) level level level))))
  (unfold (lambda (p) (= p 24)) values add1 0))

;(do ((gray 0 (add1 gray))) ((= gray 24))
;  (let ((level (+ 8 (* 10 gray))))
;       (print* (set-color256! (+ 232 gray) level level level))))

;; display the colors

;; first the system ones:
(print "System colors:")
(for-each
  (lambda (color) (print* (set-text256 `((background ,color)) "  " #t)))
  '(0 1 2 3 4 5 6 7))
(newline)
(for-each
  (lambda (color) (print* (set-text256 `((background ,color)) "  " #t)))
  '(8 9 10 11 12 13 14 15))
(newline)
(newline)

;; now the color cube
(print "Color cube, 6x6x6:")
(do ((green 0 (add1 green)))
  ((= green 6))
  (do ((red 0 (add1 red)))
        ((= red 6))
        (do ((blue 0 (add1 blue)))
          ((= blue 6))
          (let ((color (+ 16 (* red 36) (* green 6) blue)))
                (print* (set-text256 `((background ,color)) "  "))))
        (print* (set-text '(reset) " ")))
  (newline))

;; now the grayscale ramp
(print "Grayscale ramp:")
(for-each
  (lambda (color) (print* (set-text256 `((background ,color)) "  " #t)))
  (unfold (lambda (p) (= p 256)) values add1 232))
(print* (set-text '(reset) "\n"))
