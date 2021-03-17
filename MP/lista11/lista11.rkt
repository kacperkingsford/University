#lang racket

;zad1

(define/contract (sufixes xs)
  (parametric->/c [a] (-> (listof a) (listof (listof a)))) 
  (if (null? xs)
      (list null)
      (cons xs (sufixes (cdr xs)))))

;zad2

(define/contract (sublists xs)
  (parametric->/c [a] (-> (listof a) (listof (listof a))))
  (if (null? xs)
      (list null)
      (append-map
       (lambda (ys)
         (cons (cons (car xs) ys) (list ys)))
       (sublists (cdr xs)))))

(sublists (list 1 2 3 4))

;zad3

;                          n n p
;(parametric->/c [a b] (-> a b a))
(define/contract (wasteful-identity x y)
  (parametric->/c [a b] (-> a b a))
  x)
  
;                                p p n      p n  n p
;(parametric->/c [a b c] (-> (-> a b c) (-> a b) a c))
(define/contract (weird-apply f g x)
  (parametric->/c [a b c] (-> (-> a b c) (-> a b) a c))
  (f x (g x)))
  
 (weird-apply + identity 5) ; -> (+ 5 5)
 
 

;; (parametric->/c [a b c] (-> (-> b#p c#n) (-> a#p b#n) (-> a#n c#p)))

(define/contract (sample3 f g)
(parametric->/c [a b c] (-> (-> b c)(-> a b)(-> a c)))
    (lambda (x) (f (g x))))

;;((sample3 car cdr)  '(1 2 3))  ; -> (cadr '(1 2 3))

(define/contract (func3 e1)
  (parametric->/c [a] (-> (-> (-> a a) a) a))
  (e1 identity))
;(-> (-> (-> -a +a) -a) +a)
(func3 (lambda (f) (f '(1 2 3))))


(define/contract (zad3-moje f g)
    (parametric->/c [a b c] (->  (-> a b c) (-> a b) (-> a c)))
    (lambda (x) (f x (g x))))

;zad4

(define/contract (foo x)
  (parametric->/c [a b] (-> a b))
  (foo x))

;zad5


(define/contract (foldl-map f a xs)
  (parametric->/c [arg acum listValue] (-> (-> arg acum (cons/c listValue acum)) acum (listof arg) (cons/c (listof listValue) acum)))
  (define (it a xs ys)
    (if (null? xs)
        (cons (reverse ys) a)
        (let [(p (f (car xs) a))]
          (it (cdr p)
              (cdr xs)
              (cons (car p) ys)))))
  (it a xs null))


(foldl-map (lambda (x a) (cons a (+ a x))) 0 '(1 2 3))

(define/contract (foldl-map-bad f a xs)
  (parametric->/c [a]  (->(-> a a (cons/c a a)) a (listof a) (cons/c (listof a) a)))
  (cons xs a))


;zad6

