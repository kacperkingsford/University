#lang racket

(provide nth-root)

(define (nth-root_1 n y damp_count)
  (define (repeated p n)
    (define (compose f g)
      (lambda (x)
        (f (g x))))
    (if (= n 0)
        p 
       (compose p (repeated p (- n 1)))))

  (define (fixed-point f x)
    (define (close-enough? a b)
      (< (abs (- a b)) 0.0001))
    (cond
      ((close-enough? x (f x)) x)
      (else (fixed-point f (f x)))))

  (define (average-damp f)
    (lambda (x) (/ (+ x (f x)) 2)))

  (if (= y 0)
      0.0
      (fixed-point ((repeated average-damp damp_count) (lambda (x) (/ y (expt x damp_count)))) 1.0)))


(nth-root_1 4 81 3)

(nth-root_1 2 100 1)

(nth-root_1 10 1024 9)

(nth-root_1 3 8 2)
;prawidłowa ilość tłumień pierwiastka n-tego stopnia wynosi n-1

(define (nth-root n y)
  (nth-root_1 n y (- n 1)))

(nth-root 5 243)
(nth-root 10 10000000000)
(nth-root 3 27)