#lang racket

;zad2
(define (compose f g)
  (lambda (x)
    (f (g x))))

;zad3
(define (identity x)
  x)

(define (repeated p n)
    (if (= n 0)
        p 
       (compose p (repeated p (- n 1)))))

;zad4

(define (product_1 start end)
  (if (> start end)
      1
      (* (/ start (- start 1)) (/ start (- start 1)) (product_1 (+ start 2) end))))

(define (product_rec)
  (* 8 (product_1 4.0 10000) 1.0 1/10000)) 
  

(define (product_2 start end count)
  (if (> start end)
      count
      (product_2 (+ start 2) end (* count (/ (* start start) (* (- start 1) (- start 1)))))))

(define (product_iter)
  (* 8 (product_2 4.0 10000 1) 1.0 1/10000))

;zad5 (!)

(define (accumulate combiner null-value term next start stop)
  (if (> start stop)
      null-value
      (combiner (accumulate combiner null-value term next (next start) stop) (term start))))

;zad6

(define (const-frac_1 num den k i)
  (if (> i k)
      0
  (/ (num i) (+ (den i) (const-frac_1 (num (+ i 1)) (den (+ i 1)) k (+ i 1))))))

(define (const-frac)
  (const-frac_1 (lambda (i) 1.0) (lambda (i) 1.0) 1000.0 1.0))


;;cw 6
(define (cont-franc num den k)
  (define (aux i)
    (if (< i k)
        (/ (num i) (+ (den i) (aux (+ i 1))))
        (/ (num i) (den i))))
  (aux 1))

(define (cont-franc1 num den k)
  (define (aux i aku)
    (if (< 1 i)
        (aux (- i 1) (/ (num i) (+ (den i) aku)))
        (aku)
        )
  (aux k 0)))

;; cw 7
(+ 3 (cont-franc
      (lambda (i)
              ((-( 2 i) 1) (-(* 2 i) 1)))
      (lambda (i) 6)
      1000))
