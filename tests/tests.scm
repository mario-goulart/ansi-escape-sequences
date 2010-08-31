(use posix)

(load "../ansi-escape-sequences.scm")
(import ansi-escape-sequences)

(set-buffering-mode! (current-output-port) #:none)
(display (save-cursor-position))
(for-each (lambda (letter)
            (display letter)
            (sleep 1)
            (cursor-forward 1))
          '("c" "h" "i" "c" "k" "e" "n"))

(display " ")
(for-each (lambda (letter)
            (display (set-text '(bg-black fg-yellow) letter))
            (sleep 1)
            (cursor-forward 1))
          '("r" "o" "c" "k" "s" "!"))

(display (restore-cursor-position))
(display (erase-line))

(for-each (lambda (letter)
            (display letter)
            (sleep 1)
            (cursor-forward 1))
          '("c" "h" "i" "c" "k" "e" "n"))

(display " ")
(for-each (lambda (letter)
            (display (set-text '(bg-red fg-white) letter))
            (sleep 1)
            (cursor-forward 1))
          '("r" "u" "l" "e" "s" "!"))

(print "")
