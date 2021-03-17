#lang typed/racket

(provide parse typecheck)

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


;; zadanie 21

(define-type EType (U 'real 'boolean))

;; Środowisko typów

(define-type TypeEnv type-environ)
(struct type-environ ([xs : (Listof (Pairof Symbol EType))]))

(: type-env-empty TypeEnv)
(define type-env-empty (type-environ null))

(: type-env-add (-> Symbol EType TypeEnv TypeEnv))
(define (type-env-add x t env)
  (type-environ (cons (cons x t) (type-environ-xs env))))
(: type-env-lookup (-> Symbol TypeEnv EType))
(define (type-env-lookup x env)
  (: assoc-lookup (-> (Listof (Pairof Symbol EType)) EType))
  (define (assoc-lookup xs)
    (cond [(null? xs) (error "Unknown identifier" x)]
          [(eq? x (car (car xs))) (cdr (car xs))]
          [else (assoc-lookup (cdr xs))]))
  (assoc-lookup (type-environ-xs env)))

;; Typechecker

(define-type ArithOp (U '+ '- '* '/ 'modulo))
(define-predicate arithop? ArithOp)

(define-type CompOp (U '= '< '> '<= '>=))
(define-predicate compop? CompOp)

(define-type LogicOp (U 'and 'or))
(define-predicate logicop? LogicOp)


( : typecheck-env (-> Expr TypeEnv (U #f EType)))
(define (typecheck-env e env)
  (match e
    [(const n) (if (real? n)
                   'real
                   (if (boolean? n)
                       'boolean
                       #f))]
    [(var-expr x) (type-env-lookup x env)]
    [(binop op l r) (cond
                      [(arithop? op)
                        (if (and
                         (eq? (typecheck-env l env) 'real)
                         (eq? (typecheck-env r env) 'real))
                        'real
                        #f)]
                        [(compop? op)
                            (if (and
                                 (eq? (typecheck-env l env) 'real)
                                 (eq? (typecheck-env r env) 'real))
                                'boolean
                                #f)]
                            [(logicop? op)
                                (if (and
                                     (eq? (typecheck-env l env) 'boolean)
                                     (eq? (typecheck-env l env) 'boolean))
                                'boolean
                                #f)])]
    [(let-expr x e1 e2) (let ([t : (U EType #f) (typecheck-env e1 env)])
                              (if (eq? t #f)
                                  #f
                                  (typecheck-env e2
                                             (type-env-add x t env))))]
    [(if-expr eb et ef) (if (eq? (typecheck-env eb env) 'boolean)
                            (let ([t1 : (U #f EType) (typecheck-env et env)]
                                  [t2 : (U #f EType) (typecheck-env ef env)])
                              (if (eq? t1 t2)
                                  t1
                                  #f))
                            #f)]))

( : typecheck (-> Expr (U EType #f)))
(define (typecheck e)
  (typecheck-env e type-env-empty))

; testy

(define (test1)
  (typecheck (parse '(+ 1 2))))
;> 'real

(define (test2)
  (typecheck (parse '(/ (+ 3 true) 2))))
;> #f

(define (test3)
  (typecheck (parse '(let (x (* 3 3))
                       (if (= x 9)
                           (+ x 1)
                           0)))))
;>real

(define (test4)
  (typecheck (parse '(= (let (x (* 3 3))
                       (if (= x 9)
                           (+ x 1)
                           0)) 10))))
;> 'boolean

(define (test5)
  (typecheck (parse '(let (x (* 3 3))
                       (if (= x 9)
                           (+ x 1)
                           false)))))
;> #f

;Wspólpracowywałem z Adamem Jarząbkiem.