#lang racket

;zad1
(define (square x) (* x x))

(define (make-vect x y) (cons x y))

(define (vect-begin vector) (car vector))

(define (vect-end vector) (cdr vector))

(define (vect? vector)
  (not (or (null? (car vector)) (null? (cdr vector)))))

(define (make-point x y) (cons x y))

(define (point-x point) (car point))

(define (point-y point) (cdr point))

(define (point? point)
  (not (or (null? (car point)) (null? (cdr point)))))

(define (vect-length vector)
  (sqrt (+ (square (car vector)) (square (cdr vector)))))

(define (vect-scale vector k)
    (cons (vect-begin vector) (sqrt (- (* (square k) (+ (square (vect-begin vector)) (square (vect-end vector)))) (square (vect-begin vector))))))

;;zle, to mialo byc za pomoca punktow !

  
  

(define (display-point p)
  (display "(")
  (display (point-x p))
  (display ", ")
  (display (point-y p))
  (display ")"))
(define (display-vect v)
  (display "[")
  (display (vect-begin v))
  (display ", ")
  (display (vect-end v))
  (display "]"))

;zad2
(define (make-vect-v2 x y z) (cons x (cons y z)))

;zad3
(define (reverse lista) ;rekurencyjnie
  (if (null? (cdr lista))
      lista
      (append (reverse (cdr lista)) (list (car lista)))))


(define (reverse-iter-correct lista) ; iteracyjnie
  (define (reverse-iter lista pom)
  (if (null? lista)
      pom
      (reverse-iter (cdr lista) (append (list (car lista)) pom))))
  (reverse-iter lista null))

;zad4

(define (insert xs n)
  (if (and (>= (car xs) n) (<= (cdr (car xs)) n))
      



  
  