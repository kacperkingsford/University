#lang racket

```racket=

#lang typed/racket


(: prefixes (All (a) (-> (Listof a) (Listof (Listof a)))))
(define (prefixes l)
  (: prefix (All (a) (-> (Listof a) (Listof (Listof a)))))
  (define (prefix xs)
    (if (null? xs)
        (list null)
        (cons (reverse xs) (prefix (cdr xs)))))
  (prefix (reverse l)))


(prefixes '(1 2 3 4))

(: prefixes2 (All (a) (-> (Listof a) (Listof (Listof a)))))
(define (prefixes2 xs)
  (: iter (-> Integer (Listof (Listof a)) (Listof (Listof a))))
  (define (iter n acc)
    (if (= n 0)
        (cons null acc)
        (iter (- n 1) (cons (take xs n) acc))))
  (iter (length xs) null))

(prefixes2 '(1 2 3 4 5))


(: prefixes3 (All (A)  (-> (Listof A) (Listof (Listof A)))))
(define (prefixes3 l)
  (if (null? l)
      (list null)
      (cons null 
            (map (lambda ([xs : (Listof A)]) (cons (car l) xs))
                 (prefixes3 (cdr l))))))
```
## Ćwiczenie 2
> Maria Wyrzykowska, Paweł Zmarzły i wch

```racket=
(struct vector2 ([x : Real] [y : Real])            #:transparent)
(struct vector3 ([x : Real] [y : Real] [z : Real]) #:transparent)

;tu nie definiujemy predykatów, bo to struktura, a nie typ
(: vector-length-cond (-> (U vector2 vector3) Real))
(define (vector-length-cond v)
  (cond
    [(vector2? v) (sqrt (+ (sqr (vector2-x v)) (sqr (vector2-y v))))]
    [(vector3? v) (sqrt (+ (sqr (vector3-x v)) (sqr (vector3-y v)) (sqr (vector3-z v))))]))

(: vector-length-match (-> (U vector2 vector3) Real))
(define (vector-length-match v)
  (match v
    [(vector2 x y) (sqrt (+ (sqr x) (sqr y)))]
    [(vector3 x y z) (sqrt (+ (sqr x) (sqr y) (sqr z)))]))

(vector-length-cond  (vector2 -4 3))
(vector-length-match (vector2 -4 3))

(vector-length-cond  (vector3 -1 2 1))
(vector-length-match (vector3 -1 2 1))

(define-predicate nonnegative-real? Nonnegative-Real)

 (: square (-> Real Nonnegative-Real))
;(:  square (-> Number Number)) 
;(define (square x) (assert (* x x) (lambda ([x : Real]) (<= 0 x))))
(define (square x) (assert (* x x) nonnegative-real?)) 

(: vector2-length (-> vector2 Number))
(define (vector2-length v)
  (sqrt (+ (square (vector2-y v)) (square (vector2-x v)))))

(: square2 (-> Real Nonnegative-Real))
(define (square2 x)
  (let ([y (* x x)])
    (if (<= 0 y)
      y
      (error "never happens"))))

(: vector2-length2 (-> vector2 Real))
(define (vector2-length2 v)
  (sqrt (+ (square2 (vector2-y v)) (square2 (vector2-x v)))))

```

## Ćwiczenie 3

> [name=Aleksander Uniatowicz]

```racket=
#lang typed/racket

(: foldr (All (a b) (-> (-> a b b) b (Listof a) b)))
(define (foldr f initial xs)
  (if (null? xs)
      initial
      (f (car xs) (foldr f initial (cdr xs)))))

(foldr + 0 '(1 2 3 4))
(foldr - 0 '(1 2 3 4))

(: foldr-single (All (a) (-> (-> a a a) a (Listof a) a)))
(define (foldr-single f initial xs)
  (if (null? xs)
      initial
      (f (car xs) (foldr-single f initial (cdr xs)))))

; podpunkt a)

(: foldr-single-bad (All (a) (-> (-> a a a) a (Listof a) a)))
(define (foldr-single-bad f initial xs)
  (if (null? xs)
      initial
                                  ;(car xs) zamiast initial
      (f (car xs) (foldr-single-bad f (car xs) (cdr xs)))))

;(: foldr-bad (All (a b) (-> (-> a b b) b (Listof a) b)))
;(define (foldr-bad f initial xs)
;  (if (null? xs)
;      initial
;      (f (car xs) (foldr-bad f (car xs) (cdr xs)))))

(foldr-single-bad + 0 '(1 2 3 4))
;(foldr-bad + 0 '(1 2 3 4))

; podpunkt b) (tak ogranicza)

(: wasteful-string-identity (-> Number String String))
(define (wasteful-string-identity n s) s)

(foldr wasteful-string-identity "1" '(1 2 3))
;(foldr-single wasteful-string-identity "1" '(1 2 3))

(: len (-> (Listof Any) Number))
(define (len list) 
    (foldr (lambda ((elem : Any) (acc : Number)) (+ acc 1)) 0 list)
)

```

## Ćwiczenie 4

> Damian Kowalik, Mateusz Leonowicz, Adam Jarząbek

```racket=

#lang typed/racket

(define-type Leaf 'leaf)
(define-type (Node a) (List 'node a (Listof (Tree a))))
(define-type (Tree a) (U Leaf (Node a)))

(define-predicate leaf? Leaf)
(define-predicate node? (Node Any))
(define-predicate tree? (Tree Any))

(: leaf Leaf)
(define leaf 'leaf)

(: node-val (All [a] (-> (Node a) a)))
(define (node-val x)
  (second x))

(: node-children (All [a] (-> (Node a) (Listof (Tree a)))))
(define (node-children x)
  (third x))

(: make-node (All [a] (-> a (Listof (Tree a)) (Node a))))
(define (make-node v children)
  (list 'node v children))

(: get-preorder (All [a] (-> (Tree a) (Listof a))))
(define (get-preorder v)
  (: inner (-> (Tree a) (Listof a)))
  (define (inner v)
    (if (leaf? v)
      null
      (cons (node-val v) (append-map inner (node-children v)))))
  (inner v))

(: tree (Tree Integer))
(define tree
  (make-node 1 (list (make-node 2 (list (make-node 5 (list leaf))))
    (make-node 3 (list (make-node 6 (list leaf)))) (make-node 4 (list (make-node 7 (list leaf)))))))
(get-preorder tree)

;--------------------
(: preorder (All (a) (-> (Tree a) (Listof a))))
(define (preorder t)
  (match t
    [(list 'node w xs) (cons w (append-map
                                 (ann preorder (-> (Tree a) (Listof a)))  
                                 ;(inst preorder a)
                                xs))]
    ['leaf null]))
    
;---------------------    
; zad4

(struct [a] node ([v : a] [sub : (Listof (Rose a))]) #:transparent)
(struct leaf () #:transparent)

(define-type (Rose a) (U leaf (node a)))


( : rose-preorder (All [a] (-> (Rose a) (Listof a))))


(define (rose-preorder r)
  (match r
    [(leaf) null]
    [(node v sub) (cons v
                       (append-map (lambda ([x : (Rose a)])
                                     (rose-preorder x))
                                  sub))]))

; przykład
(define (róża)
  (node 'a (list (node 'b (list (leaf))) (node 'c (list (leaf))))))

```

## Ćwiczenie 5

>Adam Jarząbek
```racket=

; --------- ;
; Wyrazenia ;
; --------- ;


(struct const    ([val : Number])                        #:transparent)
(struct binop    ([op : BinopSym] [l : Expr] [r : Expr]) #:transparent)
(struct var-expr ([id : Symbol])                         #:transparent)
(struct let-expr ([id : Symbol] [e1 : Expr] [e2 : Expr]) #:transparent)

(define-type Expr (U const binop var-expr let-expr))

(define-type BinopSym (U '+ '- '* '/))
(define-predicate binop-sym? BinopSym)



(: parse (-> Any Expr))
(define (parse q)
  (match q
    [_ #:when (number? q) (const q)]
    [_ #:when (symbol? q) (var-expr q)]
    [`(,op ,e1 ,e2)
     #:when (binop-sym? op)
     (binop op (parse e1) (parse e2))]
    [`(let (,x ,e1) ,e2)
     #:when (symbol? x)
     (let-expr x (parse e1) (parse e2))]))

;; Alternatywna wersja D. Kowalik
;(: parse (-> Any Expr))
;(define (parse q)
;  (match q
;    [(? number? n) (const n)]
;    [(? symbol? s) (var-expr s)]
;    [(list 'let (list (? symbol? x) expr) body)
;      (let-expr x (parse expr) (parse body))]
;    [(list (? op? op) l r) (binop op (parse l) (parse r))]))


(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))

; ----------------------- ;
; Podstawienie za zmienna ;
; ----------------------- ;

( : subst (-> Expr Symbol Expr Expr))
(define (subst e1 x e2)
  (match e2
    [(var-expr y) (if (eq? x y) e1 (var-expr y))]
    [(const n) (const n)]
    [(binop op l r)
     (binop op (subst e1 x l) (subst e1 x r))]
    [(let-expr y e3 e4)
     (let-expr y (subst e1 x e3) 
                 (if (eq? x y) e4 (subst e1 x e4)))]))



; --------- ;
; Ewaluacja ;
; --------- ;

( : value? (-> Any Boolean))
(define (value? v)
  (number? v))

( : op->proc (-> BinopSym (-> Number Number Number)))
(define (op->proc op)
  (match op ['+ +] ['- -] ['* *] ['/ /]))

( : eval (-> Expr Number))
(define (eval e)
  (match e
    [(const n) n]
    [(binop op l r) ((op->proc op) (eval l) (eval r))]
    [(let-expr x e1 e2)
     (eval (subst (const (eval e1)) x e2))]))

```


## Ćwiczenie 6

> Damian Kowalik
> 


```racket=

#lang typed/racket

; wykład 8 plik boolean.rkt

; --------- ;
; Wyrazenia ;
; --------- ;

(define-type Value  (U Real Boolean))
(define-predicate value? Value)
(define-type Expr   (U const binop var-expr let-expr if-expr))
(define-predicate expr? Expr)
(define-type Op     (U 'modulo '+ '- '* '/ '= '> '>= '< '<= 'and 'or))
(define-predicate op? Op)
(struct const    ([val : Value])                            #:transparent)
(struct binop    ([op : Op] [l : Expr] [r : Expr])          #:transparent)
(struct var-expr ([id : Symbol])                            #:transparent)
(struct let-expr ([id : Symbol] [e1 : Expr] [e2 : Expr])    #:transparent)
(struct if-expr  ([eb : Expr] [et : Expr] [ef : Expr])      #:transparent)

(: parse (-> Any Expr))
(define (parse q)
  (match q
    [(? real? n) (const n)]
    ['true (const true)]
    ['false (const false)]
    [(? symbol? s) (var-expr s)]
    [(list (? symbol? 'let) (list (? symbol? x) expr) body)
      (let-expr x (parse expr) (parse body))]
    [(list 'if pred ifTrue ifFalse)
          (if-expr (parse pred) (parse ifTrue) (parse ifFalse))]
    [(list (? op? op) l r) (binop op (parse l) (parse r))]))

(: test-parse (-> Expr))
(define (test-parse) (parse '(let [x (+ 2 2)] (+ x 1))))

; ---------- ;
; Srodowiska ;
; ---------- ;

(define-type Env environ)
(struct environ ([xs : (Listof (Pairof Symbol Value))]))

(: env-empty Env)
(define env-empty (environ null))

(: env-add (-> Symbol Value Env Env))
(define (env-add x v env)
  (environ (cons (cons x v) (environ-xs env))))
(: env-lookup (-> Symbol Env Value))
(define (env-lookup x env)
  (: assoc-lookup (-> (Listof (Pairof Symbol Value)) Value))
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (environ-xs env)))

; --------- ;
; Ewaluacja ;
; --------- ;

(: wrap-op-real (-> (-> Real Real Real) (-> Value Value Value)))
(define (wrap-op-real op)
  (lambda (x y)
    (cond
      [(and (real? x) (real? y)) (op x y)]
      [(and (real? x) (boolean? y)) (op x (if y 1 0))]
      [(and (boolean? x) (real? y)) (op (if x 1 0) y)]
      [(and (boolean? x) (boolean? y)) (op (if x 1 0) (if y 1 0))])))

(: wrap-op-bool (-> (-> Real Real Boolean) (-> Value Value Value)))
(define (wrap-op-bool op)
  (lambda (x y)
    (cond
      [(and (real? x) (real? y)) (op x y)]
      [(and (real? x) (boolean? y)) (op x (if y 1 0))]
      [(and (boolean? x) (real? y)) (op (if x 1 0) y)]
      [(and (boolean? x) (boolean? y)) (op (if x 1 0) (if y 1 0))])))

(: wrap-op-int (-> (-> Integer Integer Boolean) (-> Value Value Value)))
(define (wrap-op-int op)
  (lambda (x y)
    (cond
      [(and (real? x) (real? y)) (op (exact-round x) (exact-round y))]
      [(and (real? x) (boolean? y)) (op  (exact-round x) (if y 1 0))]
      [(and (boolean? x) (real? y)) (op (if x 1 0)  (exact-round y))]
      [(and (boolean? x) (boolean? y)) (op (if x 1 0) (if y 1 0))])))


(: op->proc (-> Op (-> Value Value Value)))
(define (op->proc op)
  (match op ['+ (wrap-op-real +)] 
            ['- (wrap-op-real -)] 
            ['* (wrap-op-real *)] ['/ (wrap-op-real /)]
            ['= (wrap-op-bool =)] 
            ['> (wrap-op-bool >)] 
            ['>= (wrap-op-bool >=)] ['< (wrap-op-bool <)] 
            ['% (wrap-op-int modulo)]
            ['<= (wrap-op-bool <=)]
            ['and (lambda (x y) (and x y))]
            ['or  (lambda (x y) (or  x y))]))

(: eval-env (-> Expr Env Value))
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
                            (eval-env ef env))]))

(: eval (-> Expr Value))
(define (eval e) (eval-env e env-empty))

(: program Any)
(define program
  '(if (or (< (- 5 3) 5)
           true)
       (+ 2 3)
       (/ 2 0)))

(: test-eval (-> Value))
(define (test-eval) (eval (parse program)))

```

## Ćwiczenie 7
> Adam Jarząbek
```racket=
;1
(eval (parse '(/ 2020 0)))
;2
(eval (parse '(+ 1 (= 1 1))))

; to nie jest dobra odpowiedz, bo używa zmiennych
(parse '(if 2 + 3))
```
