(module ansi-escape-sequences
  (cursor-position
   cursor-up
   cursor-down
   cursor-forward
   cursor-backward
   save-cursor-position
   restore-cursor-position
   hide-cursor
   show-cursor
   erase-display
   erase-line
   reset-mode
   set-text
   set-mode)

(import chicken scheme data-structures)
(use srfi-1)

;; http://ascii-table.com/ansi-escape-sequences.php

(define (csi . args)
  (string-append "\x1b["
                 (string-intersperse (map ->string (butlast args)) ";")
                 (last args)))

(define (cursor-position #!optional (line 0) (column 0))
  (csi line column "H"))

(define (cursor-up lines)
  (csi lines "A"))

(define (cursor-down lines)
  (csi lines "B"))

(define (cursor-forward columns)
  (csi columns "C"))

(define (cursor-backward columns)
  (csi columns "D"))

(define (save-cursor-position)
  (csi "s"))

(define (restore-cursor-position)
  (csi "u"))

(define (hide-cursor)
  (csi "?25l"))

(define (show-cursor)
  (csi  "?25h"))

(define (erase-display)
  (csi "2J"))

(define (erase-line)
  (csi "K"))

(define (set-text attribs text #!optional (reset #t))
  (let ((valid-attribs '((reset         . 0)
                         (bold          . 1)
                         (underscore    . 4)
                         (blink         . 5)
                         (reverse-video . 7)
                         (concealed     . 8)
                         (fg-black      . 30)
                         (fg-red        . 31)
                         (fg-green      . 32)
                         (fg-yellow     . 33)
                         (fg-blue       . 34)
                         (fg-magenta    . 35)
                         (fg-cyan       . 36)
                         (fg-white      . 37)
                         (bg-black      . 40)
                         (bg-red        . 41)
                         (bg-green      . 42)
                         (bg-yellow     . 43)
                         (bg-blue       . 44)
                         (bg-magenta    . 45)
                         (bg-cyan       . 46)
                         (bg-white      . 47)
                         )))
    (string-append
     (csi (string-intersperse
           (filter-map (lambda (attr)
                         (let ((a (alist-ref attr valid-attribs)))
                           (and a (number->string a))))
                       attribs)
           ";") "m")
     text
     (if reset (csi "0m") ""))))

(define (set/reset-mode attrib set?)
  (let ((valid-mode-attribs
         '((40x25-monochrome   . 0)
           (40x25-color        . 1)
           (80x25-monochrome   . 2)
           (80x25-color        . 3)
           (320x200-4-color    . 4)
           (320x200-monochrome . 5)
           (640x200-monochrome . 6)
           (line-wrapping      . 7)
           (320x200-color      . 13)
           (640x200-color      . 14)
           (640x350-monochrome . 15)
           (640x350-color      . 16)
           (640x480-monochrome . 17)
           (640x480-color      . 18)
           (320x200-color      . 19))))
    (or (and-let* ((a (alist-ref attrib valid-mode-attribs)))
          (csi a (if set? "h" "l")))
        (error (if set? 'set-mode 'reset-mode) (conc "Invalid attribute: " attrib)))))


(define (set-mode attrib)
  (set/reset-mode attrib #t))

(define (reset-mode attrib)
  (set/reset-mode attrib #f))

) ;; end module
