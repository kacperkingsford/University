#lang racket

;Ćwiczenie 1


;a)
`(+ (/ 8 (+ 2 3)) (+ 10 1))

(binop '+ (binop '/ (const 8) 
                    (binop '+ (const 2) 
                              (const 3))) 
            (binop '+ (const 10) 
                      (const 1)))

;b)
b = 1+2+3*4+5

(+ 1 (+ 2 (+ (* 3 4) 5))

(define a (binop '+ (const 1)
        (binop '+ (const 2) 
                  (binop '+ (binop '* (const 3)
                                      (const 4)) 
                            (const 5)))))
                            


(eq? (integer->char 955) (integer->char 955))
#f
(equal? (integer->char 955) (integer->char 955))
#t

(eq? (make-string 3 #\z) (make-string 3 #\z))
#f
(equal? (make-string 3 #\z) (make-string 3 #\z))
#t


;Ćwiczenie 2


(define (square x) (* x x))
(define (cont-frac-expr num den i k)
    (if (= k i)
        (const 0)
        (binop '/ 
            (const (num i)) 
            (binop '+ (const (den i)) (cont-frac-expr num den (+ i 1) k)))))

(define (pi-expr n)
    (binop '+ 
        (const 3) 
        (cont-frac-expr (lambda (i) (square (- (* 2 i) 1.0))) (lambda (i) 6.0) 1.0 n)))

;Ćwiczenie 3



(struct unop (op e))

(define (expr? e)
  (match e
    [(const n) (number? n)]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(unop op e) (and (symbol? op) (expr? e) )]
    [_ false]))

(define (binop->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['** **]))
(define (unop->proc op)
  (match op ['abs abs]))

(define (eval e)
  (match e
    [(const n) n]
    [(unop op e) ((unop->proc op) (eval e))]
    [(binop op l r) ((binop->proc op) (eval l) (eval r))]))
    

(define (parse q)
  (cond [(number? q) (const q)]
        [(and (list? q) (eq? (length q) 2) (symbol? (first q)))
         (unop (first q) (parse (second q)))]
        [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
         (binop (first q) (parse (second q)) (parse (third q)))]))
    
    
    
(define ** expt)


(eval (parse '(abs (** -2 3))))
;moga wyjsc brzydkie wyniki


;Ćwiczenie 4

(define (pretty-print e)
  (define (print-par? current-op e)
    (match current-op
        ['+ false]
        ['- false]
        ['* (match e
                [(binop '** _ _) true]
                [_ false])]
        ['/ (match e
                [(binop '** _ _) true]
                [_ false])]
        ['** (match e
                [(const n) false]
                [(variable) false]
                [_ true])]))
         
  (match e
    [(const n) (number->string n)]
    [(unop op e) (string-append (symbol->string op) "(" (pretty-print e) ")")]
    [(variable) "x"]
    [(binop op l r) (let
                        ((print-par-left? (print-par? op l))
                         (print-par-right? (print-par? op r)))
                        (string-append
                           (if print-par-left? "(" "")
                           (pretty-print l)
                           (if print-par-left? ")" "")
                           " " (symbol->string op) " "
                           (if print-par-right? "(" "")
                           (pretty-print r)
                           (if print-par-right? ")" "")
                           ))]))
                           
(pretty-print (parse '(** (+ (+ 1 (** (* 2 3) 2)) (- 4 6)) 2)))

;lepsze z priorytetem operatorów:
(define (pretty-print e)
  (define (binop->priority op)
    (match op
      ['+ 0]
      ['- 0]
      ['* 1]
      ['/ 1]
      ['** 2]
    ))
  (define (expr->priority e)
    (match e
      [(binop op _ _) (binop->priority op)]
      [else 50]
      ; [(const _) 50]
      ; [(variable) 50]
      ; [(unop op _) 50]
    ))
  (define (print-par? current-op e)
    (> (binop->priority current-op) (expr->priority e)))

  (match e
    [(const n) (number->string n)]
    [(variable) "x"]
    [(unop op e) (string-append (symbol->string op) "(" (pretty-print e) ")")]
    [(binop op l r) (let
                        ((print-par-left? (print-par? op l))
                         (print-par-right? (print-par? op r)))
                        (string-append
                           (if print-par-left? "(" "")
                           (pretty-print l)
                           (if print-par-left? ")" "")
                           " " (symbol->string op) " "
                           (if print-par-right? "(" "")
                           (pretty-print r)
                           (if print-par-right? ")" "")
                           ))]))


;Ćwiczenie 5

(define (∂ e)
    (match e
        [(variable) (const 1)]
        [(const val) (const 0)]
        [(binop op l r) (if (equal? op '+)
                            (binop '+ (∂ l) (∂ r))
                            (binop '+ 
                                (binop '* (∂ l) r) 
                                (binop '* l (∂ r))))]))

;lub

(define (∂ e)
  (match e
    [(const n) (const 0)]
    [(variable) (const 1)]
    [(binop op l r) 
     (match op
       ['+ (binop '+ (∂ l)  (∂ r))]
       ['* (binop '+
                  (binop '* (∂ l) r)
                  (binop '* l (∂ r)))])]))

(pretty-print (∂ (binop '* (variable) (binop '* (variable) (variable)))))
(pretty-print (∂ (parse '(* x (* x x)))))
"1 * x * x + x * (1 * x + x * 1)"

(pretty-print (∂ (parse '(+  x (* 3 (* x x))))))
"(1 + ((0 * (x * x)) + (3 * ((1 * x) + (x * 1)))))"

;Ćwiczenie 6

(define (simpl e)
  (match e
    [(variable) (variable)]
    [(const val) (const val)]
    [(binop op l r) (if (equal? op '+)
                        (if (equal? l (const 0))
                            (simpl r)
                            (if (equal? r (const 0))
                                (simpl l)
                                (binop op (simpl l) (simpl r))))
                                ;tu można by dać cond - znacznie czytelniej by było
                        (if (or
                             (equal? l (const 0))
                             (equal? r (const 0)))
                            (const 0)
                            (if (equal? l (const 1))
                                (simpl r)
                                (if (equal? r (const 1))
                                    (simpl l)
                                    (binop op (simpl l) (simpl r))))))]))

(binop '+ (binop '* (variable) (variable)) (binop '* (variable) (binop '+ (variable) (variable))))

(pretty-print (simpl (parse '(+  x (* 3 (* x x)))))))

;;lepsza WERSJA !!

(define (simpl e)
  (match e
    [(variable) (variable)]
    [(const val) (const val)]
    [(binop '+ (const 0) r) (simpl r)]
    [(binop '+ l (const 0)) (simpl l)]
    [(binop '+ l r) (binop '+ (simpl l) (simpl r))]
    [(binop '* (const 0) r) (const 0)]
    [(binop '* l (const 0)) (const 0)]
    [(binop '* (const 1) r) (simpl r)]
    [(binop '* l (const 1)) (simpl l)]
    [(binop '* l r) (binop '* (simpl l) (simpl r))]))

(pretty-print (simpl (parse '(* 2 x) )))s

;Ćwiczenie 7



  