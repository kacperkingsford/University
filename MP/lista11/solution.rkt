#lang racket

(provide (contract-out
          [with-labels  with-labels/c]
          [foldr-map  foldr-map/c]
          [pair-from  pair-from/c ]))

(provide with-labels/c  foldr-map/c  pair-from/c)

(define with-labels/c
  (parametric->/c [a b] (-> (-> a b) (listof a) (listof (cons/c b (listof a))))))

(define (with-labels f xs)
  with-labels/c
  (if (null? xs)
      null
      (cons (list (f (car xs)) (car xs)) (with-labels f (cdr xs)))))

(define foldr-map/c
    (parametric->/c [a b]
                  (-> (-> a b (cons/c a b))
                      b (listof a) (cons/c (listof a) b))))

(define (foldr-map f a xs)
  foldr-map/c
  (define (it a xs ys)
    (if (null? xs)
        (cons ys a)
        (let [(p (f (car xs) a))]
          (it (cdr p) (cdr xs) (cons (car p) ys)))))
  (it a (reverse xs) null))

(define pair-from/c
    (parametric->/c [a b] 
        (-> (-> a b) (-> a b) (-> a (cons/c b b)))
    ))

(define (pair-from f g)
   pair-from/c
 (lambda (x) (cons (f x) (g x))))

;Współpracowywałem z Adamem Jarząbkiem.