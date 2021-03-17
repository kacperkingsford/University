#lang racket

(provide cont-frac)

(define (cont-frac num den)
  
  (define (good-enough? prev new)
    (< (abs (- prev new)) 0.00001))
  
  (define (AB_N prev next start end)
    (cond
      ((= end -1) prev)
      ((= end 0) next)
      ((= start end) next)
      (else (AB_N next (+ (* (den start) next) (* (num start) prev)) (+ start 1) end))))

  (define (f k)
    (/ (AB_N 1 0 1 k) (AB_N 0 1 1 k)))

  (define (iter prev new i)
    (cond
      ((good-enough? prev new) new)
      (else (iter new (f (+ i 1)) (+ i 1)))))
  (iter 0.0 1.0 4))

;testy
(display "PI = ")
(+ 3 (cont-frac (lambda (x) (* (+ 1 (* (- x 1) 2)) (+ 1 (* (- x 1) 2)))) (lambda (x) 6.0)))

(display "Złoty podział = ")
(/ 1.0 (cont-frac (lambda (x) 1.0) (lambda (x) 1.0)))
;korzystałem z zadań z ćwiczeń