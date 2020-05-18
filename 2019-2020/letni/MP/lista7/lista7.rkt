#lang racket
;zad1

; --------- ;
; Wyrazenia ;
; --------- ;

(struct const    (val)      #:transparent)
(struct binop    (op l r)   #:transparent)
(struct var-expr (id)       #:transparent)
(struct let-expr (id e1 e2) #:transparent)
(struct sum-expr (n m f i)       #:transparent) ; dopisane zad 1
(struct integral-expr (a b f x)  #:transparent) ; dopisane zad 1
(struct min-expr (f i)           #:transparent) ; dopisane zad 1

(define (expr? e)
  (match e
    [(const n) (number? n)]
    [(binop op l r) (and (symbol? op) (expr? l) (expr? r))]
    [(var-expr x) (symbol? x)]
    [(let-expr x e1 e2) (and (symbol? x) (expr? e1) (expr? e2))]
    [(sum-expr a b f i) (and (expr? a) (expr? b) (expr? f) (symbol? i))]  ; dopisane zad 1 
    [(integral-expr a b f x) (and (expr? a) (expr? b) (expr? f) (symbol? x))] ; dopisane zad 1
    [(min-expr f i) (and (expr? f) (symbol? i))]                              ; dopisane zad 1 
    [_ false]))

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))

; ----------------------- ;
; Podstawienie za zmienna ;
; ----------------------- ;

(define (subst e1 x e2)
  (match e2
    [(var-expr y) (if (eq? x y) e1 (var-expr y))]
    [(const n) (const n)]
    [(binop op l r)
     (binop op (subst e1 x l) (subst e1 x r))]
    [(let-expr y e3 e4)
     (let-expr y (subst e1 x e3) 
                 (if (eq? x y) e4 (subst e1 x e4)))]))

(define (test-subst)
  (subst (parse '(+ 2 2))
         'x
         (parse '(let [y (+ x 1)] (let [x (+ x y)] (+ y x))))))

; --------- ;
; Ewaluacja ;
; --------- ;

(define (value? v)
  (number? v))

(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /]))

(define (eval e)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval l) (eval r))]
    [(let-expr x e1 e2)
     (eval (subst (const (eval e1)) x e2))]))

(define (test-eval) (eval (test-subst)))


;zad2


(define (parse q)
  (cond
    [(number? q) (const q)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]
    [(and (list? q) (eq? (length q) 5) (eq? (first q) 'sum))
     (sum-expr
            (parse (second q))
            (parse (third q))
            (parse (fourth q))
            (fifth q))] 
     [(and (list? q) (eq? (length q) 5) (eq? (first q) 'integral))
     (integral-expr
            (parse (second q))
            (parse (third q))
            (parse (fourth q))
            (fifth q))]
     [(and (list? q) (eq? (length q) 2) (eq? (first q) 'min))
     (min-expr
            (parse (second q))
            (third q))]
            
            ))


;zad3

(struct var (val) #:transparent)
(struct neg (val) #:transparent)
(struct conj (left right) #:transparent);and
(struct disj (left right) #:transparent);or
(struct QA (val form) #:transparent);All
(struct QE (val form) #:transparent);Exist


(define (prop? f)
  (or (boolean? f)
      (and (var? f)
           (symbol? (var-val f)))
      (and (neg? f)
           (prop? (neg-val f)))
      (and (disj? f)
           (prop? (disj-left f))
           (prop? (disj-right f)))
      (and (conj? f)
           (prop? (conj-left f))
           (prop? (conj-right f)))
      (and (QA? f)
           (var? (QA-val f))
           (prop? (QA-form f)))
      (and (QE? f)
           (var? (QE-val f))
           (prop? (QE-form f))))
)

(define (parse p)
  (cond
    [(boolean? p) p]
    [(symbol? p) (var p)]
    [(and (list? p) (= 2 (length p)) (eq? 'neg (first p))) (neg (parse (second p)))]
    [(and (list? p) (= 3 (length p)) (eq? 'QA (first p))) (QA (parse (second p)) (parse (third p)))]
    [(and (list? p) (= 3 (length p)) (eq? 'QE (first p))) (QE (parse (second p)) (parse (third p)))]
    [(and (list? p) (= 3 (length p)) (eq? 'conj (first p))) (conj (parse (second p)) (parse (third p)))]
    [(and (list? p) (= 3 (length p)) (eq? 'disj (first p))) (disj (parse (second p)) (parse (third p)))]
  )
)
;(parse '(neg p))
;(parse '(QA p (conj p (neg p))))
;(parse '(QE x (neg x)))             ;1 przyklad
;(parse '(QA p (disj p (neg p))))    ;2
;(parse '(QE p (conj p (neg p))))    ;3

;zad4



(println "ZADANIE 3")

(struct conj (l r)             #:transparent)
(struct disj (l r)             #:transparent)
(struct neg  (subf)            #:transparent)
(struct qvar (p)               #:transparent)
(struct qfb (quant qvar qexpr) #:transparent)

(define (val? v)
  (boolean? v))

(define (formula? f)
  (match f
    [(qvar p) (symbol? p)]
    [(disj l r) (and (formula? l) (formula? r))]
    [(conj l r) (and (formula? l) (formula? r))]  
    [(neg subf) (formula? subf)]
    [_ false]))

(define (mygvar? v)
  (symbol? v))

(define (mygfb? f)
  (match f
    [(qfb quant gvar qexpr) (and (member quant '(exists every)) (mygvar? gvar) (mygfb? qexpr))]
    [_ (formula? f)]))

(define (parseqfb q)
  (cond
    [(symbol? q) (qvar q)]
    [(and (list? q) (eq? (length q) 3) (eq? 'exists (first q)) (mygvar? (second q)))
     (qfb (first q) (second q) (parseqfb (third q)))]
    [(and (list? q) (eq? (length q) 3) (eq? 'every (first q)) (mygvar? (second q)))
     (qfb (first q) (second q) (parseqfb (third q)))]
    [(and (list? q) (eq? (length q) 3) (eq? 'or (second q)))
     (disj (parseqfb (first q)) (parseqfb (third q)))]
    [(and (list? q) (eq? (length q) 3) (eq? 'and (second q)))
     (conj (parseqfb (first q)) (parseqfb (third q)))]
    [(and (list? q) (eq? (length q) 2) (eq? 'not (first q)))
     (neg (parseqfb (second q)))]))

(parseqfb '(exists p (p or q))) 
(parseqfb '(every q (exists p (p or q))))
(mygfb? (parseqfb '(exists p (p or q)))) 

(println "ZADANIE 4")

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

(define (evalqbf q)
  (evalqbf-env q env-empty))

(define (evalqbf-env q env)
     (match q
        [(qvar p) (env-lookup p env)]
        [(disj l r) (or (evalqbf-env l env) (evalqbf-env r env))]
        [(conj l r) (and (evalqbf-env l env) (evalqbf-env r env))]
        [(neg subf) (not (evalqbf-env subf env))]
        [(qfb 'exists qvar qexpr) (or (evalqbf-env qexpr (env-add                     qvar #f env)))]
        [(qfb 'every qvar qexpr) (and (evalqbf-env qexpr (env-add                     qvar #f env)))]))        
 
(evalqbf (parseqfb '(exists p (not p)))) ;#t
(evalqbf (parseqfb '(every p (p or (not p))))) ;#t
(evalqbf (parseqfb '(exists p (p and (not p))))) ;#f
(evalqbf (parseqfb '(every q (every p (p or q))))) ;#f
(evalqbf (parseqfb '(exists q (every p (p or q))))) ;#t

;zad5

(struct const    (val)      #:transparent)
(struct binop    (op l r)   #:transparent)
(struct var-expr (id)       #:transparent)
(struct let-expr (id e1 e2) #:transparent)

(define (parse q)
  (cond
    [(number? q) (const q)]
    [(symbol? q) (var-expr q)]
    [(and (list? q) (eq? (length q) 3) (eq? (first q) 'let))
     (let-expr (first (second q))
               (parse (second (second q)))
               (parse (third q)))]
    [(and (list? q) (eq? (length q) 3) (symbol? (first q)))
     (binop (first q)
            (parse (second q))
            (parse (third q)))]))

(struct environ (xs))
(define env-empty (environ null))

(define (env-add name newName value env)
  (environ (cons (list name newName value) (environ-xs env))))

(define (env-lookup x env)
  (define (assoc-lookup xs)
    (cond [(null? xs) null]
          [(eq? x (car (car xs))) (car (cdr (car xs)))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

(define (env-length env)
  (define (env-length-iter xs count)
    (if (null? xs)
        count
        (env-length-iter (cdr xs) (+ 1 count))))
  (env-length-iter (environ-xs env) 0))

(define (get-name var env)
  (string->symbol (string-append (symbol->string var) (number->string (env-length env)))))

(define (rename expr)
  (define (rename-env x env)
    (match x
      [(const n) (const n)]
      [(binop op l r) (binop op
                             (rename-env l env)
                             (rename-env r env))]
      [(var-expr var)
       (if (null? (env-lookup var env))
                          (var-expr var)
                          (var-expr (env-lookup var env)))]
      [(let-expr id e1 e2)
       (let ([newName (get-name id env)])
         (let-expr newName (rename-env e1 env) (rename-env e2 (env-add id newName e1 env))))]))
  (rename-env expr env-empty))

;;(let ([x 5]) (let ([y 3]) (let ([x 3]) (+ y x))
;;(let ([x0 5]) (let ([y1 3]) (let ([x2 3]) (+ y1 x2))

(rename (binop '+
        (let-expr'x (const 1) (var-expr'x))
        (let-expr'x (const 1) (var-expr'x))))
    
(rename (let-expr 'x (const  3)
            (binop '+ (var-expr'x)
                    (let-expr'x (const  5) (var-expr'x)))))

(rename (parse '(let [x 5] (let [y 3] (let [x 3] (+ y x)))))) ;;cos nie gra w tym zad

;zad6

(define (subst e1 x e2)
  (match e2
    [(var-expr y) (if (eq? x y) e1 (var-expr y))]
    [(const n) (const n)]
    [(binop op l r)
     (binop op (subst e1 x l) (subst e1 x r))]
    [(let-expr y e3 e4)
     (let-expr y (subst e1 x e3)
                 (if (eq? x y) e4 (subst e1 x e4)))]))

(define (assoc-find xs key)
  (define pair (assoc key xs))
  (if pair
    (cdr pair)
    #f))

(define (assoc-add xs key new-value)
  (cons (cons key new-value) xs))

(define (assoc-replace xs key new-value)
  (define (go xs acc)
    (cond [(null? xs) acc]
          [(eq? key (car (car xs)))
            (append acc (list (cons key new-value)) (cdr xs))]
          [else (go (cdr xs) (append acc (list (car xs))))]))
  (go xs null))

(define (symbol-append symbol num)
  (string->symbol
    (string-append (symbol->string symbol) "-" (number->string num))))

(define (rename expr)
  ; `do` zwraca parę (expr, used)
  ; `expr` jest listą par typu ('zmienna . 5)
  (define (do expr used)
    (match expr
      [(const n) (cons (const n) used)]
      [(binop op l r)
        ; NOWE. Najpierw wywołujemy się na lewym poddrzewie,
        ; przekazujemy nowy stan liczników do wywołania na prawym
        ; poddrzewie, zwracamy nowy stan liczników z prawego wywołania.
        ; W taki sposób `used` "wędruje" razem z wykonaniem kodu.
        (let* ((left-do (do l used))
              (right-do (do r (cdr left-do))))
              (cons (binop op (car left-do) (car right-do)) (cdr right-do)))]
      [(let-expr x e1 e2)
        (let* [(known (assoc-find used x))
              (new-counter (if known (+ known 1) 1))
              (new-used
                (if known
                  (assoc-replace used x new-counter)
                  (assoc-add used x new-counter)))
              (symbol (symbol-append x new-counter))
              (new-e2 (subst (var-expr symbol) x e2))
              ; NOWE
              (left-do (do e1 new-used))
              (right-do (do new-e2 (cdr left-do)))]
            (cons
              (let-expr symbol
                (car left-do)
                (car right-do))
              (cdr right-do)))]
      [(var-expr x) (cons (var-expr x) used)]))
  (car (do expr null)))
 
> (rename (let-expr 'x (const 3)
  (binop
    '+
    (var-expr 'x)
    (let-expr 'x (const 5) (var-expr 'x)))))

(let-expr
 'x-1
 (const 3)
 (binop '+ (var-expr 'x-1) (let-expr 'x-2 (const 5) (var-expr 'x-2))))

> (rename (binop '+
  (let-expr
    'x (const 1) (var-expr 'x))
  (let-expr
    'x (const 1)
    (binop '+ (var-expr 'x)
              (let-expr 'x-1 (const 1)
                  (let-expr 'x (const 2)
                      (var-expr 'x-1)))))))

(binop
 '+
 (let-expr 'x-1 (const 1) (var-expr 'x-1))
 (let-expr
  'x-2
  (const 1)
  (binop
   '+
   (var-expr 'x-2)
   (let-expr 'x-1-1 (const 1) (let-expr 'x-3 (const 2) (var-expr 'x-1-1))))))

;zad7

