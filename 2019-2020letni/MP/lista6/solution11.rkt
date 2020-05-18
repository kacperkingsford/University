#lang racket

(provide (struct-out const) (struct-out binop) rpn->arith)

;; -------------------------------
;; Wyrazenia w odwr. not. polskiej
;; -------------------------------

(define (rpn-expr? e)
  (and (list? e)
       (pair? e)
       (andmap (lambda (x) (or (number? x) (member x '(+ - * /))))
               e)))

;; ----------------------
;; Wyrazenia arytmetyczne
;; ----------------------

(struct const (val)    #:transparent)
(struct binop (op l r) #:transparent)
(struct stack (xs)     #:transparent)

(define empty-stack (stack null))
(define (empty-stack? s) (null? (stack-xs s)))
(define (top s) (car (stack-xs s)))
(define (push a s) (stack (cons a (stack-xs s))))
(define (pop s) (stack (cdr (stack-xs s))))



(define (arith-expr? e)
  (match e
    [(const n) (number? n)]
    [(binop op l r)
     (and (symbol? op) (arith-expr? l) (arith-expr? r))]
    [_ false]))

;; ----------
;; Kompilacja
;; ----------

(define (rpn->arith e)
  (define (rpn->arith_stack e xs)
  (cond
    [(null? e) (top xs)]
    [(number? (car e)) (rpn->arith_stack (cdr e) (push (const (car e)) xs))]
    [(member (car e) '(+ - * /)) (rpn->arith_stack (cdr e) (push (binop (car e) (top (pop xs)) (top xs)) (pop (pop xs))))]
  )
  )
  (rpn->arith_stack e empty-stack))



; Mozesz tez dodac jakies procedury pomocnicze i testy

;TESTY :
(rpn->arith '(3 4 5 + 2 7 + - *)) ; powinno dać ( 3 * ((4 + 5) - (2 + 7)))
(arith-expr? (rpn->arith '(3 4 5 + 2 7 + - *))) ; true
(rpn->arith '(3 4 + 2 -))
