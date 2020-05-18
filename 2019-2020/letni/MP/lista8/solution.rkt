#lang racket

(provide parse eval)

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
(struct app        (f e)      #:transparent) ; <------------------ !!!

(struct lazy-lam   (id e)     #:transparent);;ZMIANA
(struct post (e) #:transparent)  ;; ZMIANA!!   (odroczenie)

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
    [(app f e) (and (expr? f) (expr? e))] ; <--------------------- !!!
    [(lazy-lam id e) (and (symbol? id) (expr? e))] ;;ZMIANA
    [(post e) (expr? e)]               ;;ZMIANA!!
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
     
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'lambda)) ;;ZMIANA
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

(define (parse-lazy-lam pat e) ;;ZMIANA
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
(struct lazy-lam-clo (id e env) #:transparent) ;;ZMIANA
(struct lazy-clo (e env) #:transparent) ;;ZMIANA

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
    
    [(var-expr x)
       (match (env-lookup x env)
         [(lazy-clo e env) (eval-env e env)]
         [v v])]
    
    
    [(if-expr eb et ef) (if (eval-env eb env)
                            (eval-env et env)
                            (eval-env ef env))]
    [(cons-expr e1 e2) (cons (post e1)    ;;ZMIANA!!
                             (post e2))]  ;;ZMIANA!!
    [(car-expr e) (eval-env (car (eval-env e env)) env)] ;;ZMIANA!!
    [(cdr-expr e) (eval-env (cdr (eval-env e env)) env)] ;;ZMIANA!!
    [(null-expr) null]
    [(null?-expr e) (null? (eval-env e env))]
    
    [(lazy-lam x e) (lazy-lam-clo x e env)]
    
    [(post e) (eval-env e env)]  ;;ZMIANA!!
    
    [(app f e)
     (match (eval-env f env)
       [(clo x body fun-env)
         (eval-env body (env-add x (eval-env e env) fun-env))]
       [(lazy-lam-clo x body fun-env)
         (eval-env body (env-add x (lazy-clo e env) fun-env))])])) ;;ZMIANA
     

(define (eval e) (eval-env e env-empty))

;Współpracowywałem z Adamem Jarząbkiem.