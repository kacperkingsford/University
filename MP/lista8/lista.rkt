#lang racket

;zad1


; Do let-env.rkt dodajemy wartosci boolowskie
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const    (val)      #:transparent)
(struct binop    (op l r)   #:transparent)
(struct var-expr (id)       #:transparent)
(struct let-expr (id e1 e2) #:transparent)
(struct if-expr  (eb et ef) #:transparent)

(define (expr? e)
  (match e
    [(const n) (or (number? n) (eq? n 'true) (eq? n 'false))] ; <---------- zad1
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef) ; <--------------------------------------- !!!
     (and (expr? eb) (expr? et) (expr? ef))]
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const 'true)]  ; <---------- zad1
    [(eq? q 'false) (const 'false)] ; ; <---------- zad1
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if)) ; <--- !!!
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v) (boolean? v)))

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo] ; <----------- !!!
            ['=   (lambda (x y) (if (= x y)  1 0))]               
            ['>   (lambda (x y) (if (> x y)  1 0))] 
            ['>=  (lambda (x y) (if (>= x y) 1 0))] 
            ['<   (lambda (x y) (if (< x y)  1 0))] 
            ['<=  (lambda (x y) (if (<= x y) 1 0))]
            ['and (lambda (x y) (if (and (= x 1) (= y 1)) 1 0))]
            ['or  (lambda (x y) (if (or  (= x 1) (= y 1)) 1 0))]))

(define (eval-env e env)
  (match e
    [(const n) (cond ; <---------- zad1
                 [(eq? n 'false) 0]
                 [(eq? n 'true)  1]
                 [else n])]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (= (eval-env eb env) 0) ; <---------- zad1
                            (eval-env ef env)
                            (eval-env et env))]))

(define (eval e) (eval-env e env-empty))

(define program
  '(if (or (> (% 123 10) 5)
           false)
       (+ 2 3)
       (/ 2 0)))

(define (test-eval) (eval (parse program)))


;zad2

; Do let-env.rkt dodajemy wartosci boolowskie
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const    (val)      #:transparent)
(struct binop    (op l r)   #:transparent)
(struct var-expr (id)       #:transparent)
(struct let-expr (id e1 e2) #:transparent)
(struct if-expr  (eb et ef) #:transparent)
(struct unop (op e)         #:transparent) ; <--- zmiana


    
(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(unop op e) (and (expr? e) (symbol? op))] ;---> zmiana
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]  
    [(eq? q 'false) (const false)] 
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 2) (symbol? (first q))) (unop (first q) (parse (second q)))]  ;<----- ZMIANA
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if)) 
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v) (boolean? v)))

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]
            ['boolean? boolean?] ['number? number?])) ;----> zmiana

(define (eval-env e env)
  (match e
    [(const n) n]
    [(unop op e) ((op->proc op) (eval-env e env))] ;-> zmiana
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env) ; 
                            (eval-env et env)
                            (eval-env ef env))]))

(define (eval e) (eval-env e env-empty))

(define program
  '(if (or (< (% 123 10) 5)
           true)
       (+ 2 3)
       (/ 2 0)))

(define (test-eval) (eval (parse program)))

val (parse '(number? (if (< 0 (+ (* 2 2) 7)) 5 true))) ;-> #t

(eval (parse '(boolean? (if (< 0 (+ (* 2 2) 7)) 5 true)))) ;-> #f

(eval (parse '(boolean? (if (> 0 (+ (* 2 2) 7)) 5 true)))) ;-> #t

;zad3

; Do let-env.rkt dodajemy wartosci boolowskie
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;
(struct binop2    (op l r)   #:transparent)
(struct const    (val)      #:transparent)
(struct binop    (op l r)   #:transparent)
(struct var-expr (id)       #:transparent)
(struct let-expr (id e1 e2) #:transparent)
(struct if-expr  (eb et ef) #:transparent)

(define (expr? e)
  (match e
    [(const n) (or (number? n) (eq? n 'true) (eq? n 'false))] ; <---------- zad1
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef) ; <--------------------------------------- !!!
     (and (expr? eb) (expr? et) (expr? ef))]
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const 'true)]  ; <---------- zad1
    [(eq? q 'false) (const 'false)] ; ; <---------- zad1
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if)) ; <--- !!!
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
       [(and (list? q) (eq? (length q) 3) (or (eq? (first q) 'and) (eq? (first q) 'or) ) )
     (binop2 (first q)
            (parse (second q))
            (parse (third q)))]

    
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v) (boolean? v)))

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo] ; <----------- !!!
            ['=   (lambda (x y) (if (= x y)  1 0))]               
            ['>   (lambda (x y) (if (> x y)  1 0))] 
            ['>=  (lambda (x y) (if (>= x y) 1 0))] 
            ['<   (lambda (x y) (if (< x y)  1 0))] 
            ['<=  (lambda (x y) (if (<= x y) 1 0))]
            ))



(define (zmien x)
(if (= x 0) false true)
  )

(define (spowrotem x)
(if x 1 0)
  )

;; spowrotem -> z-powrotem

(define (eval-env e env)
  (match e
    [(const n) (cond ; <---------- zad1
                 [(eq? n 'false) 0]
                 [(eq? n 'true)  1]
                 [else n])]
    [(binop2 op l r) (cond [(eq? op 'and)  (spowrotem (and (zmien (eval-env l env   )) (zmien (eval-env r env)))) ]
                           [(eq? op 'or)   (spowrotem (or  (zmien (eval-env l env)) (zmien (eval-env r env)))) ]           
	)]
    
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (= (eval-env eb env) 0) ; <---------- zad1
                            (eval-env ef env)
                            (eval-env et env))]))

(define (eval e) (eval-env e env-empty))

(define program
  '(if (or (> (% 123 10) 5)
           false)
       (+ 2 3)
       (/ 2 0)))

;;;LUB TEŻ!

można było też potraktować and i or jako lukier syntaktyczny i zmienić na if w trakcie parsowania:

    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'and)); <----------------- !!!
     (if-expr (parse (second q))
              (parse (third q))
              (const false))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'or)); <----------------- !!!
     (if-expr (parse (second q))
              (const 'true)
              (parse (third q)))]

;zad4

; Do boolean.rkt dodajemy pary
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const     (val)      #:transparent)
(struct binop     (op l r)   #:transparent)
(struct var-expr  (id)       #:transparent)
(struct let-expr  (id e1 e2) #:transparent)
(struct if-expr   (eb et ef) #:transparent)
(struct cons-expr (e1 e2)    #:transparent) ; <------------------- !!!
(struct car-expr  (e)        #:transparent) ; <------------------- !!!
(struct cdr-expr  (e)        #:transparent) ; <------------------- !!!

(struct pair?-expr (e) #:transparent)

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))] ; <----------- !!!
    [(car-expr e) (expr? e)] ; <---------------------------------- !!!
    [(cdr-expr e) (expr? e)] ; <---------------------------------- !!!
    [(pair?-expr e) (expr? e) ]
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons)) ; <- !!!
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car)) ; <-- !!!
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr)) ; <-- !!!
     (cdr-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
   
   [(and (list? q) (eq? (length q) 2) (eq? (first q) 'pair?))
     (pair?-expr (parse (second q)))]
   
   
   [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))))

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]))

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env) ; <---------------- !!!
                             (eval-env e2 env))]
    [(car-expr e) (car (eval-env e env))] ; <--------------------- !!!
    [(cdr-expr e) (cdr (eval-env e env))]
    
    [(pair?-expr e) (pair? (eval-env e env))]
    )) ; <------------------- !!!
    
    

(define (eval e) (eval-env e env-empty))

(define program
  '(car (if true (cons 1 2) false)))

(define (test-eval) (eval (parse program)))

;zad5 niepelne rozw:

; Z fun.rkt:
[(and (list? q) (pair? q) (not (op->proc (car q)))) ; <------- !!!
     (parse-app q)]

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['pair? pair?] ; <- NOWE
            ['not not] ; <- NOWE
            ['car car] ; <- NOWE
            ['cdr cdr] ; <- NOWE
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]
            [_ false]))


;zad6


; Do boolean.rkt dodajemy pary
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const     (val)      #:transparent)
(struct binop     (op l r)   #:transparent)
(struct var-expr  (id)       #:transparent)
(struct let-expr  (id e1 e2) #:transparent)
(struct if-expr   (eb et ef) #:transparent)
(struct cons-expr (e1 e2)    #:transparent) ; <------------------- !!!
(struct car-expr  (e)        #:transparent) ; <------------------- !!!
(struct cdr-expr  (e)        #:transparent) ; <------------------- !!!

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))] ; <----------- !!!
    [(car-expr e) (expr? e)] ; <---------------------------------- !!!
    [(cdr-expr e) (expr? e)] ; <---------------------------------- !!!
    [_ false]))

(define (parse q)
  (define (isCR? l)
    (define (rec x) (if (or (eq? (car x) #\d) (eq? (car x) #\a))
                        (rec (cdr x))
                        (and (eq? (car x) #\r) (eq? (cdr x) null))))
    (if (eq? (car l) #\c)
        (rec (cdr l))
        false))
  (define (parseCR l rest)
    (match (car l)
      [#\a (car-expr (parseCR (cdr l) rest))]
      [#\d (cdr-expr (parseCR (cdr l) rest))]
      [#\r (parse rest)]))
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons)) ; <- !!!
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car)) ; <-- !!!
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr)) ; <-- !!!
     (cdr-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (isCR? (string->list (symbol->string (first q)))))
     (parseCR (cdr (string->list (symbol->string (first q)))) (second q))]))

(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))


; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))))

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]))

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env) ; <---------------- !!!
                             (eval-env e2 env))]
    [(car-expr e) (car (eval-env e env))] ; <--------------------- !!!
    [(cdr-expr e) (cdr (eval-env e env))])) ; <------------------- !!!

(define (eval e) (eval-env e env-empty))

(define program
  '(car (if true (cons 1 2) false)))

(define (test-eval) (eval (parse program)))

(eval (parse '(cadr (cons 1 (cons 2 3)))))

;;ZAD6 ROZW Z REPET:

---
tags: mp
---
# Repetytorium z Metod Programowania (04.05.2020)

```racket=
#lang racket

; Do list.rkt dodajemy procedury
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const      (val)      #:transparent)
(struct binop      (op l r)   #:transparent)
(struct var-expr   (id)       #:transparent)
(struct let-expr   (id e1 e2) #:transparent)
(struct if-expr    (eb et ef) #:transparent)
(struct cons-expr  (e1 e2)    #:transparent)

(struct cadr-like-expr (op e) #:transparent)

(struct null-expr  ()         #:transparent)
(struct null?-expr (e)        #:transparent)
(struct app        (f e)      #:transparent)
(struct lam        (id e)     #:transparent)

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))]
    
    [(cadr-like-expr op e) (and (cadr-like? op) (expr? e))]
    
    [(null-expr) true]
    [(null?-expr e) (expr? e)]
    [(app f e) (and (expr? f) (expr? e))]
    [(lam id e) (and (symbol? id) (expr? e))]
    [_ false]))

(define (cadr-like? op)
  (and (symbol? op)
       (let [(xs (string->list (symbol->string op)))]
         (and (> (length xs) 2)
              (eq? (first xs) #\c)
              (eq? (last xs   #\r))
              (all (lambda (c)
                      (or (eq? c #\a) (eq? c #\d)))
                   (cdr (reverse (cdr xs))))))))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(eq? q 'null)  (null-expr)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'null?))
     (null?-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons))
     (cons-expr (parse (second q))
                (parse (third q)))]
    
    
    [(and (list? q) (eq? (length q)) (cadr-like? (first q)))
     (cadr-like-expr (first q) (parse (second q)))]
    
     
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'lambda)) ; <!!!
     (parse-lam (second q) (third q))]
    [(and (list? q) (pair? q) (not (op->proc (car q))))
     (parse-app q)]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(define (parse-app q)
  (define (parse-app-accum q acc)
    (cond [(= 1 (length q)) (app acc (parse (car q)))]
          [else (parse-app-accum (cdr q) (app acc (parse (car q))))]))
  (parse-app-accum (cdr q) (parse (car q))))

(define (parse-lam pat e)
  (cond [(= 1 (length pat))
         (lam (car pat) (parse e))]
        [else
         (lam (car pat) (parse-lam (cdr pat) e))]))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs) #:transparent)

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(struct clo (id e env) #:transparent) ; <------------------------- !!!

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))
      (null? v)
      (clo? v))) ; <---------------------------------------------- !!!

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]
            [_ false])) ; <--------------------------------------- !!!

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env)
                             (eval-env e2 env))]
                             
                             
    [(cadr-like-expr op e)
      (eval-cadr-like op (eval-env e env))]    
    
    
    [(null-expr) null]
    [(null?-expr e) (null? (eval-env e env))]
    [(lam x e) (clo x e env)] ; <--------------------------------- !!!
    [(app f e) ; <------------------------------------------------ !!!
     (let ([vf (eval-env f env)]
           [ve (eval-env e env)])
       (match vf [(clo x body fun-env)
                  (eval-env body (env-add x ve fun-env))]))]))

(define (eval-cadr-like op v)
  (define (eval-cadr-rec op v)
    (cond
      [(eq? (first op) #\r) v]
      [(eq? (first op) #\a)
        (car (eval-cadr-rec (cdr op) v))]
      [(eq? (first op) #\d)
        (cdr (eval-cadr-rec (cdr op) v))]))
  (eval-cadr-rec (car (string->list (symbol->string op))) v))

(define (eval e) (eval-env e env-empty))

(define program
  '(let [twice (lambda (f x) (f (f x)))]
   (let [inc (lambda (x) (+ 1 x))]
     (twice twice twice twice inc 1))))
    

(define (test-eval) (eval (parse program)))
```



;;

;zad7
; Do boolean.rkt dodajemy pary
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const     (val)      #:transparent)
(struct binop     (op l r)   #:transparent)
(struct var-expr  (id)       #:transparent)
(struct let-expr  (id e1 e2) #:transparent)
(struct if-expr   (eb et ef) #:transparent)
(struct cons-expr (e1 e2)    #:transparent) ; <------------------- !!!
(struct car-expr  (e)        #:transparent) ; <------------------- !!!
(struct cdr-expr  (e)        #:transparent) ; <------------------- !!!

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))] ; <----------- !!!
    [(car-expr e) (expr? e)] ; <---------------------------------- !!!
    [(cdr-expr e) (expr? e)] ; <---------------------------------- !!!
    [_ false]))

(define (parse q)
  (define (isCR? l)
    (define (rec x) (if (or (eq? (car x) #\d) (eq? (car x) #\a))
                        (rec (cdr x))
                        (and (eq? (car x) #\r) (eq? (cdr x) null))))
    (if (eq? (car l) #\c)
        (rec (cdr l))
        false))
  (define (parseCR l rest)
    (match (car l)
      [#\a (car-expr (parseCR (cdr l) rest))]
      [#\d (cdr-expr (parseCR (cdr l) rest))]
      [#\r (parse rest)]))
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons)) ; <- !!!
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car)) ; <-- !!!
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr)) ; <-- !!!
     (cdr-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (isCR? (string->list (symbol->string (first q)))))
     (parseCR (cdr (string->list (symbol->string (first q)))) (second q))]))

(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))


; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))))

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]))

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env) ; <---------------- !!!
                             (eval-env e2 env))]
    [(car-expr e) (car (eval-env e env))] ; <--------------------- !!!
    [(cdr-expr e) (cdr (eval-env e env))])) ; <------------------- !!!

(define (eval e) (eval-env e env-empty))

(define program
  '(car (if true (cons 1 2) false)))

(define (test-eval) (eval (parse program)))

(eval (parse '(cadr (cons 1 (cons 2 3))))) ;zwraca 2

(define prog
  '(let [xs (cons 1 (cons 2 (cons 3 (cons 4 (cons 5 6)))))]
      (caddddr xs))) 

Ćwiczenie 7

; Do pair.rkt dodajemy listy
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const      (val)      #:transparent)
(struct binop      (op l r)   #:transparent)
(struct var-expr   (id)       #:transparent)
(struct let-expr   (id e1 e2) #:transparent)
(struct if-expr    (eb et ef) #:transparent)
(struct cons-expr  (e1 e2)    #:transparent)
(struct car-expr   (e)        #:transparent)
(struct cdr-expr   (e)        #:transparent)
(struct null-expr  ()         #:transparent) 
(struct null?-expr (e)        #:transparent) 
(struct nth-expr (selector e) #:transparent) ; <- NOWE

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))]
    [(car-expr e) (expr? e)]
    [(cdr-expr e) (expr? e)]
    [(null-expr) true] 
    [(null?-expr e) (expr? e)] 
    ; FIXME: czy ewaluować pierwszy parametr (dla dynamicznych wyrażeń)?
    [(nth-expr selector e) (and (symbol? selector) (expr? e))]
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(eq? q 'null)  (null-expr)] ; 
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'null?)) 
     (null?-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons))
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car))
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr))
     (cdr-expr (parse (second q)))]
    [(and (list? q) (= (length q) 2)) ; <- NOWE
      (nth-expr (first q) (parse (second q)))] ; <- NOWE
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))
      (null? v))) ; 

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]))

(define (get-nth n xs) (list-ref xs n)) ; <- NOWE

; Pomysł: pogrupować słowa w grupy (a . modifier).
; `a` w przedziale 0-999, modifier \in {billion, million, thousand}.
(define (selector-to-n selector)
  (define (a-to-number mod)
    (match mod
      ['first 1] ['second 2] ['third 3] ['fourth 4] ['fifth 5]
      ['sixth 6] ['seventh 7] ['eighth 8] ['ninth 9] ['tenth 10]
      ['eleventh 11] ['twelfth 12] ['thirteenth 13] ['fourteenth 14] ['fifteenth 15]
      ['sixteenth 16] ['seventeenth 17] ['eightteenth 18] ['nineteenth 19]

      ; Dla one-hundred etc.
      ; FIXME: wydzielić do innej funkcji, żeby (one xs) nie działało.
      ['one 1] ['two 2] ['three 3] ['four 4] ['five 5]
      ['six 6] ['seven 7] ['eight 8] ['nine 9] ['ten 10]
      ['eleven 11] ['twelve 12] ['thirteen 13] ['fourteen 14] ['fifteen 15]
      ['sixteen 16] ['seventeen 17] ['eightteen 18] ['nineteen 19]

      ['twenty 20] ['thirty 30] ['fourty 40] ['fifty 50]
      ['sixty 60] ['seventy 70] ['eighty 80] ['ninety 90]

      [_ false]))

  (define (group-separator? mod)
    (match mod
      ['hundred false]
      ['thousand true]
      ['million  true]
      ['billion  true]
      [_ false]))

  (define (exp-to-number mod)
    (match mod
      ['hundred  100]
      ['thousand 1000]
      ['million  1000000]
      ['billion  1000000000]
      [_ false]))

  (define (group-complete? group)
    (and (not (null? group))
      (group-separator? (car group))))

  ; chunks - lista symboli (słów)
  ; groups - lista list (grup)
  ; grupa to np. (first hundred one)
  (define (chunks-to-groups chunks groups)
    (cond
      ; Warunek stopu iteracji.
      [(null? chunks) groups]
      ; Zaczynamy budować nową listę grup...
      [(null? groups)
        (chunks-to-groups
          (cdr chunks)
          (cons (cons (car chunks) null) null))]
      ; Zaczynamy budować nową grupę...
      [(group-complete? (car groups))
        (chunks-to-groups
          (cdr chunks)
          (cons (cons (car chunks) null) groups))]
      ; Kontynuujemy budowanie grupy...
      [else
        (chunks-to-groups
          (cdr chunks)
          (cons (cons (car chunks) (car groups)) (cdr groups)))]))

  (define (group-to-num group)
    (cond
      [(null? group) 0]
      [(exp-to-number (car group)) (* (exp-to-number (car group)) (group-to-num (cdr group)))]
      [else (+ (a-to-number (car group)) (group-to-num (cdr group)))]))

  (define chunks
    (map string->symbol
      (string-split
        (symbol->string selector)
        "-")))

  (define groups
    (chunks-to-groups chunks null))
  (display "Groups: ")
  (displayln groups)

  (define numbers
    (map group-to-num groups))
  (display "Numbers: ")
  (displayln numbers)

  (define sum
    (foldl + 0 numbers))
  (displayln sum)

  sum)

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env)
                             (eval-env e2 env))]
    [(car-expr e) (car (eval-env e env))]
    [(cdr-expr e) (cdr (eval-env e env))]
    [(nth-expr selector e) (get-nth (selector-to-n selector) (eval-env e env))] ; <- NOWE
    [(null-expr) null] 
    [(null?-expr e) (null? (eval-env e env))])) 

(define (eval e) (eval-env e env-empty))

(define program
  '(nine-hundred-ninety-nine-billion-nine-hundred-ninety-nine-million-nine-hundred-ninety-nine-thousand-nine-hundred-ninety-ninth nope))

(eval (parse program))y
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const      (val)      #:transparent)
(struct binop      (op l r)   #:transparent)
(struct var-expr   (id)       #:transparent)
(struct let-expr   (id e1 e2) #:transparent)
(struct if-expr    (eb et ef) #:transparent)
(struct cons-expr  (e1 e2)    #:transparent)
(struct car-expr   (e)        #:transparent)
(struct cdr-expr   (e)        #:transparent)
(struct null-expr  ()         #:transparent) ; <------------------ !!!
(struct null?-expr (e)        #:transparent) ; <------------------ !!!

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))]
    [(car-expr e) (expr? e)]
    [(cdr-expr e) (expr? e)]
    [(null-expr) true] ; <---------------------------------------- !!!
    [(null?-expr e) (expr? e)] ; <-------------------------------- !!!
    [_ false]))

(define (parse q)

  (define (desugar expr)
      (if (null? expr)
          (null-expr)
          (cons-expr (car expr) (desugar (cdr expr)))))
  
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(eq? q 'null)  (null-expr)] ; <------------------------------ !!!
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'null?)) ; < !!!
     (null?-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons))
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car))
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr))
     (cdr-expr (parse (second q)))]
    [(and (list? q) (eq? (first q) 'list))
     (desugar (map parse (cdr q)))]  
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))
      

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))
      (null? v))) ; <--------------------------------------------- !!!

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]))

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env)
                             (eval-env e2 env))]
    [(car-expr e) (car (eval-env e env))]
    [(cdr-expr e) (cdr (eval-env e env))]
    [(null-expr) null]
    [(null?-expr e) (null? (eval-env e env))]))

(define (eval e) (eval-env e env-empty))

;zad7 z REPET


(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(eq? q 'null)  (null-expr)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'null?))
     (null?-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons))
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car))
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr))
     (cdr-expr (parse (second q)))]
     
     
    [(and (list? q) (pair? q) (eq? (first q) 'list))
     (make-list (map parse (cdr q)))]
     
     
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'lambda)) ; <!!!
     (parse-lam (second q) (third q))]
    [(and (list? q) (pair? q) (not (op->proc (car q)))) ; <------- !!!
     (parse-app q)]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))
            

(define (make-list es)
  (if (null?)
      (null-expr))
      (cons-expr (car es) (make-list es)))

;

;zad8

; Do pair.rkt dodajemy listy
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const      (val)      #:transparent)
(struct binop      (op l r)   #:transparent)
(struct var-expr   (id)       #:transparent)
(struct let-expr   (id e1 e2) #:transparent)
(struct if-expr    (eb et ef) #:transparent)
(struct cons-expr  (e1 e2)    #:transparent)
(struct car-expr   (e)        #:transparent)
(struct cdr-expr   (e)        #:transparent)
(struct null-expr  ()         #:transparent) 
(struct null?-expr (e)        #:transparent) 
(struct nth-expr (selector e) #:transparent) ; <- NOWE

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))]
    [(car-expr e) (expr? e)]
    [(cdr-expr e) (expr? e)]
    [(null-expr) true] 
    [(null?-expr e) (expr? e)] 
    ; FIXME: czy ewaluować pierwszy parametr (dla dynamicznych wyrażeń)?
    [(nth-expr selector e) (and (symbol? selector) (expr? e))]
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(eq? q 'null)  (null-expr)] ; 
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'null?)) 
     (null?-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons))
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car))
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr))
     (cdr-expr (parse (second q)))]
    [(and (list? q) (= (length q) 2)) ; <- NOWE
      (nth-expr (first q) (parse (second q)))] ; <- NOWE
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs))

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))
      (null? v))) ; 

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]))

(define (get-nth n xs) (list-ref xs n)) ; <- NOWE

; Pomysł: pogrupować słowa w grupy (a . modifier).
; `a` w przedziale 0-999, modifier \in {billion, million, thousand}.
(define (selector-to-n selector)
  (define (a-to-number mod)
    (match mod
      ['first 1] ['second 2] ['third 3] ['fourth 4] ['fifth 5]
      ['sixth 6] ['seventh 7] ['eighth 8] ['ninth 9] ['tenth 10]
      ['eleventh 11] ['twelfth 12] ['thirteenth 13] ['fourteenth 14] ['fifteenth 15]
      ['sixteenth 16] ['seventeenth 17] ['eightteenth 18] ['nineteenth 19]

      ; Dla one-hundred etc.
      ; FIXME: wydzielić do innej funkcji, żeby (one xs) nie działało.
      ['one 1] ['two 2] ['three 3] ['four 4] ['five 5]
      ['six 6] ['seven 7] ['eight 8] ['nine 9] ['ten 10]
      ['eleven 11] ['twelve 12] ['thirteen 13] ['fourteen 14] ['fifteen 15]
      ['sixteen 16] ['seventeen 17] ['eightteen 18] ['nineteen 19]

      ['twenty 20] ['thirty 30] ['fourty 40] ['fifty 50]
      ['sixty 60] ['seventy 70] ['eighty 80] ['ninety 90]

      [_ false]))

  (define (group-separator? mod)
    (match mod
      ['hundred false]
      ['thousand true]
      ['million  true]
      ['billion  true]
      [_ false]))

  (define (exp-to-number mod)
    (match mod
      ['hundred  100]
      ['thousand 1000]
      ['million  1000000]
      ['billion  1000000000]
      [_ false]))

  (define (group-complete? group)
    (and (not (null? group))
      (group-separator? (car group))))

  ; chunks - lista symboli (słów)
  ; groups - lista list (grup)
  ; grupa to np. (first hundred one)
  (define (chunks-to-groups chunks groups)
    (cond
      ; Warunek stopu iteracji.
      [(null? chunks) groups]
      ; Zaczynamy budować nową listę grup...
      [(null? groups)
        (chunks-to-groups
          (cdr chunks)
          (cons (cons (car chunks) null) null))]
      ; Zaczynamy budować nową grupę...
      [(group-complete? (car groups))
        (chunks-to-groups
          (cdr chunks)
          (cons (cons (car chunks) null) groups))]
      ; Kontynuujemy budowanie grupy...
      [else
        (chunks-to-groups
          (cdr chunks)
          (cons (cons (car chunks) (car groups)) (cdr groups)))]))

  (define (group-to-num group)
    (cond
      [(null? group) 0]
      [(exp-to-number (car group)) (* (exp-to-number (car group)) (group-to-num (cdr group)))]
      [else (+ (a-to-number (car group)) (group-to-num (cdr group)))]))

  (define chunks
    (map string->symbol
      (string-split
        (symbol->string selector)
        "-")))

  (define groups
    (chunks-to-groups chunks null))
  (display "Groups: ")
  (displayln groups)

  (define numbers
    (map group-to-num groups))
  (display "Numbers: ")
  (displayln numbers)

  (define sum
    (foldl + 0 numbers))
  (displayln sum)

  sum)

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env)
                             (eval-env e2 env))]
    [(car-expr e) (car (eval-env e env))]
    [(cdr-expr e) (cdr (eval-env e env))]
    [(nth-expr selector e) (get-nth (selector-to-n selector) (eval-env e env))] ; <- NOWE
    [(null-expr) null] 
    [(null?-expr e) (null? (eval-env e env))])) 

(define (eval e) (eval-env e env-empty))

(define program
  '(nine-hundred-ninety-nine-billion-nine-hundred-ninety-nine-million-nine-hundred-ninety-nine-thousand-nine-hundred-ninety-ninth nope))

(eval (parse program))

;zad9


; Do list.rkt dodajemy procedury
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const      (val)      #:transparent)
(struct binop      (op l r)   #:transparent)
(struct var-expr   (id)       #:transparent)
(struct let-expr   (id e1 e2) #:transparent)
(struct if-expr    (eb et ef) #:transparent)
(struct cons-expr  (e1 e2)    #:transparent)
(struct car-expr   (e)        #:transparent)
(struct cdr-expr   (e)        #:transparent)
(struct null-expr  ()         #:transparent)
(struct null?-expr (e)        #:transparent)
(struct app        (f e)      #:transparent) 
(struct lam        (id e)     #:transparent) 

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))]
    [(car-expr e) (expr? e)]
    [(cdr-expr e) (expr? e)]
    [(null-expr) true]
    [(null?-expr e) (expr? e)]
    [(app f e) (and (expr? f) (expr? e))] 
    [(lam id e) (and (symbol? id) (expr? e))] 
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(eq? q 'null)  (null-expr)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'null?))
     (null?-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons))
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car))
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr))
     (cdr-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'lambda)) 
     (parse-lam (second q) (third q))]
    [(and (list? q) (pair? q) (not (op->proc (car q))))
     (parse-app q)]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(define (parse-app q) ; 
  (define (parse-app-accum q acc)
    (cond [(= 1 (length q)) (app acc (parse (car q)))]
          [else (parse-app-accum (cdr q) (app acc (parse (car q))))]))
  (parse-app-accum (cdr q) (parse (car q))))

(define (parse-lam pat e)
  (cond [(= 1 (length pat))
         (lam (car pat) (parse e))]
        [else
         (lam (car pat) (parse-lam (cdr pat) e))]))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs) #:transparent)

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(struct clo (id e env) #:transparent) 

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))
      (null? v)
      (clo? v))) 

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]
            [_ false]))

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
    [(var-expr x) (env-lookup x env)]
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env)
                             (eval-env e2 env))]
    [(car-expr e) (car (eval-env e env))]
    [(cdr-expr e) (cdr (eval-env e env))]
    [(null-expr) null]
    [(null?-expr e) (null? (eval-env e env))]
    [(lam x e) (clo x e env)] 
    [(app f e) 
     (let ([vf (eval-env f env)]
           [ve (eval-env e env)])
       (match vf [(clo x body fun-env)
                  (eval-env body (env-add x ve fun-env))]))]))
                  

(define (eval e) (eval-env e env-not))

(define env-not (env-add 'not (eval-env (parse '(lambda (q) (if q
                             false
                             true))) env-empty) env-empty))

(define not-program
     '(not true)
     ;(not false)     
     ;(not (or true false))
     )

(eval (parse not-program))

;zad10 Z REPET

(lambda (p) (+ (car p) (cdr p)))

(lambda (x) (lambda (y) (+ x y)))

curry:

(let (curry 
  (lambda (f) (lambda (x) (lambda (y) (f (cons x y))))))
  ...)

uncurry

(let (uncurry
  (lambda (f) (lambda (p) ((f (car p)) (cdr p)))))
  ...)

;zad11 Z REPET
;+ LAMBDA LAZY


; Do list.rkt dodajemy procedury
;
; Miejsca, ktore sie zmienily oznaczone sa przez !!!

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const      (val)      #:transparent)
(struct binop      (op l r)   #:transparent)
(struct var-expr   (id)       #:transparent)
(struct let-expr   (id e1 e2) #:transparent)

(struct let-lazy-expr (id e1 e2) #:transparent)

(struct if-expr    (eb et ef) #:transparent)
(struct cons-expr  (e1 e2)    #:transparent)
(struct car-expr   (e)        #:transparent)
(struct cdr-expr   (e)        #:transparent)
(struct null-expr  ()         #:transparent)
(struct null?-expr (e)        #:transparent)
(struct app        (f e)      #:transparent) ; <------------------ !!!
(struct lam        (id e)     #:transparent) ; <------------------ !!!

(struct lazy-lam   (id e)     #:transparent)

(define (expr? e)
  (match e
    [(const n) (or (number? n) (boolean? n))]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
     
    [(let-lazy-expr x e1 e2)
     (and (symbol? x) (expr? e1) (expr? e2))]
     
    [(if-expr eb et ef)
     (and (expr? eb) (expr? et) (expr? ef))]
    [(cons-expr e1 e2) (and (expr? e1) (expr? e2))]
    [(car-expr e) (expr? e)]
    [(cdr-expr e) (expr? e)]
    [(null-expr) true]
    [(null?-expr e) (expr? e)]
    [(app f e) (and (expr? f) (expr? e))] ; <--------------------- !!!
    [(lam id e) (and (symbol? id) (expr? e))] ; <----
    [(lazy-lam id e) (and (symbol? id) (expr? e))]
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(eq? q 'true)  (const true)]
    [(eq? q 'false) (const false)]
    [(eq? q 'null)  (null-expr)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'null?))
     (null?-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'cons))
     (cons-expr (parse (second q))
                (parse (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'car))
     (car-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 2) (eq? (first q) 'cdr))
     (cdr-expr (parse (second q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
               
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let-lazy))
     (let-lazy-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
               
               
    [(and (list? q) (eq? (length q) 4) (eq? (first q) 'if))
     (if-expr (parse (second q))
              (parse (third q))
              (parse (fourth q)))]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'lambda)) ; <!!!
     (parse-lam (second q) (third q))]
     
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'lazy-lambda)) ; <!!!
     (parse-lazy-lam (second q) (third q))]
     
    [(and (list? q) (pair? q) (not (op->proc (car q)))) ; <------- !!!
     (parse-app q)]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(define (parse-app q) ; <----------------------------------------- !!!
  (define (parse-app-accum q acc)
    (cond [(= 1 (length q)) (app acc (parse (car q)))]
          [else (parse-app-accum (cdr q) (app acc (parse (car q))))]))
  (parse-app-accum (cdr q) (parse (car q))))

(define (parse-lam pat e) ; <------------------------------------- !!!
  (cond [(= 1 (length pat))
         (lam (car pat) (parse e))]
        [else
         (lam (car pat) (parse-lam (cdr pat) e))]))

(define (parse-lazy-lam pat e) ; <------------------------------------- !!!
  (cond [(= 1 (length pat))
         (lazy-lam (car pat) (parse e))]
        [else
         (lazy-lam (car pat) (parse-lazy-lam (cdr pat) e))]))

; ---------- ;
; Srodowiska ;
; ---------- ;

(struct environ (xs) #:transparent)

(define env-empty (environ null))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(struct clo (id e env) #:transparent)
(struct lazy-lam-clo (id e env) #:transparent)
(struct lazy-clo (e env) #:transparent)

(define (value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v) (value? (car v)) (value? (cdr v)))
      (null? v)
      (clo? v))) ; <---------------------------------------------- !!!

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /] ['% modulo]
            ['= =] ['> >] ['>= >=] ['< <] ['<= <=]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]
            [_ false])) ; <--------------------------------------- !!!

(define (eval-env e env)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval-env l env)
                                   (eval-env r env))]
    [(let-expr x e1 e2)
     (eval-env e2 (env-add x (eval-env e1 env) env))]
     
    [(let-lazy-expr x e1 e2)
     (eval-env e2 (env-add x (lazy-clo e1 env)))]
    
    
    [(var-expr x)
       (match (env-lookup x env)
         [(lazy-clo e env) (eval-env e env)]
         [v v])]
    
    
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (eval-env e1 env)
                             (eval-env e2 env))]
    [(car-expr e) (car (eval-env e env))]
    [(cdr-expr e) (cdr (eval-env e env))]
    [(null-expr) null]
    [(null?-expr e) (null? (eval-env e env))]
    [(lam x e) (clo x e env)] ; <--------------------
    
    [(lazy-lam x e) (lazy-lam-clo x e env)]
    
    [(app f e)
     (match (eval-env f env)
       [(clo x body fun-env)
         (eval-env body (env-add x (eval-env e env) fun-env))]
       [(lazy-lam-clo x body fun-env)
         (env-env body (env-add x (lazy-clo e env) fun-env))])]))
     

(define (eval e) (eval-env e env-empty))

(define program
  '(let [twice (lambda (f x) (f (f x)))]
   (let [inc (lambda (x) (+ 1 x))]
     (twice twice twice twice inc 1))))
    

(define (test-eval) (eval (parse program)))



