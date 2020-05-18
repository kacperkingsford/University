#lang racket

(provide merge split mergesort)

(define (merge l1 l2)
    (cond
      ((null? l1) l2)
      ((null? l2) l1)
      ((< (car l1) (car l2)) (cons (car l1) (merge (cdr l1) l2)))
      (else (cons (car l2) (merge l1 (cdr l2))))))

(define (split l)
  (let ((dl (ceiling (/ (length l) 2))))
    (define (>=? x y)
      ((or (> x y) (= x y))))
    
    (define (split-iter l pom1 k)
      (if (>= k dl)
          (cons pom1 l)
          (split-iter (cdr l) (append pom1 (list (car l))) (+ k 1))))
    (split-iter l '() 0)))

(define (mergesort l)
    (if (or (null? l) (null? (cdr l))) l
    (merge (mergesort (car (split l))) (mergesort (cdr (split l))))))

;testy
(mergesort '(-2 383 2 1 3 19 0 2 3 3 4 1 12 2))
(mergesort '())
(mergesort '(-100))
(mergesort '(2 1 3 5 4))


 
    
            