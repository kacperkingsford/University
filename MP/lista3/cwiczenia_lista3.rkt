#lang racket
;cw1

(define make-point cons)
(define x-point car)
(define y-point cdr)

(define (point? p)
  (and (pair? p)
       (number? (x-point p))
       (number? (y-point p))))

(define (make-vector x1 y1 x2 y2) 
  (cons (make-point x1 y1) (make-point x2 y2)))

(define vector-begin car)
(define vector-end cdr)

(define (vector? v)
  (and (pair? v)
       (point? (vector-begin v))
       (point? (vector-end v))))

(define (vector-lenght v)
  (define (sq x) (* x x))
      (sqrt (+ (sq (- (x-point (vector-begin v))
                      (x-point (vector-end v))))
               (sq (- (y-point (vector-begin v))
                      (y-point (vector-end)))))
            )
      )

( define ( display-point p )
( display "(")
( display ( x-point p ) )
( display ", ")
( display ( y-point p ) )
( display ")") )

( define ( display-vect v )
( display "[")
( display-point ( vector-begin v ) )
( display ", ")
( display-point ( vector-end v ) )
( display "]") )

;funkcje pomocnicze
(define (map proc items)
  (if (null? items)
      null
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (append l1 l2)
  (if (null? l1)
      l2
      (cons (car l1) (append (cdr l1) l2))))

(define (list? l)
  (or (null? l)
      (and (cons? l) (list? (cdr l)))))

;cw3
(define (reverse l)
  (if (null? l)
      null
      (append (reverse (cdr l))
              (list (car l)))))

(define (reverse-iter l)
  (define (iter old new)
    (if (null? old)
        new
        (iter (cdr old) (cons (car old)))
        ))
    (iter l '() ))

;cw4
(define (insert l x)
  (if (null? l)
      (list x)
      (if (> x (car l))
          (cons (car l) (insert (cdr l) x))
          (cons x l))
      ))

(define (insertion-sort l)
  (define (sort l acc)
    (if (null? l)
    acc
    (sort (cdr l) (insert acc (car l)))))
  (sort l '() ))


;cw5
(define (select-min l)
  (define (sm-search min l)
    (if (null? l)
        min
        (if (< (car l) min)
            (sm-search (car l) (cdr l))
            (sm-search min (cdr l)))))
  (define (sm-process x l)
    (if (null? l)
        l
        (if (= x (car l))
            (cdr l)
            (cons (car l) (sm-process x l)))))
    (let ([x (select-min l)])
      (cons x (sm-process x l)))
  )

;cw7 (podpowiedz)
;(1 2 3)
;((1 2 3) (2 1 3) ..)
(define (perm l)
  (if (null? l)
      '()
      (let ([perms (perm (cdr l))])
        ;reszta kodu
        )
      )
  )
    
;cw6

;null : list
;cons : a -> list -> list
;
;1 podpunkt
;Dla dowolnych xs i ys, jesli (list? xs) i (list? ys) to (list? (append xs ys))
; (dowod polega na rozwijaniu poszczegolnych funkcji uzytych w dowodzie)

; 1. xs==null
; (list? (append null ys)) ~ (list? ys)

; 2. zakladamy ze zachodzi (list? (append xs ys))
; (list? (append (cons a xs) ys)) ~
; (list? (cons a (append xs ys))) ~
; (and (cons? (cons a (append xs ys))) (list? (cdr (cons a (append xs ys))))) ~
; (list? (cdr (cons a (append xs ys)))) ~
; (list? (append xs ys))
      