#lang racket

(define (var? t)
  (symbol? t))

(define (neg? t)
  (and (list? t)
       (= 2 (length t))
       (eq? 'neg (car t))))

(define (conj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'conj (car t))))

(define (disj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'disj (car t))))

(define (prop? f)
  (or (var? f)
      (and (neg? f)
           (prop? (neg-subf f)))
      (and (disj? f)
           (prop? (disj-left f))
           (prop? (disj-rght f)))
      (and (conj? f)
           (prop? (conj-left f))
           (prop? (conj-rght f)))))

;zad1
(define (make-neg f)
    (list 'neg f))
    
(define (make-conj l r)
    (list 'conj l r))
    
(define (make-disj l r)
    (list 'disj l r))
    
(define (neg-subf f)
    (second f))

(define (conj-left f)
    (second f))
    
(define (conj-rght f)
    (third f))
    
(define (disj-left f)
    (second f))
    
(define (disj-rght f)
    (third f))
    
(define tauthology (make-disj 'p (make-neg 'p)))
(define some-formula (make-conj 'p 'q))

;zad2
;Zasada indukcji. Dla dowolnej własności P, jeśli:

    ;dla każdego symbolu x zachodzi P(x),
    ;dla dowolnej formuły f, jeśli zachodzi P(f), to zachodzi P((neg f)),
   ; dla dowolnych formuł f1, f2, jeśli zachodzi P(f1) i P(f2), to zachodzi również P((conj f1 f2)) i P((disj f1 f2))

;to dla dowolnej formuły f, jeśli zachodzi (prop? f), to zachodzi P(f).

;zad3

(define (free-vars f)
    (define (go f)
        (cond ((var? f)
               (list f))
              ((neg? f)
               (go (neg-subf f)))
              ((disj? f)
               (append (go (disj-left f)) 
                       (go (disj-rght f))))
              ((conj? f)
               (append (go (conj-left f)) 
                       (go (conj-rght f))))))
    (remove-duplicates (go f))) ; wbudowana procedura usuwajaca duplikaty na liscie !

;zad4

;z tresci
(define (gen-vals xs) ; zwraca liste wszystkich mozliwych wartosciowan zmiennych, jedno wartosciowanie to lista par wiec wszystkie to lista list
  (if (null? xs)
      (list null)
      (let*
          ((vss  (gen-vals (cdr xs)))
           (x    (car xs))
           (vst  (map (lambda (vs) (cons (list x true)  vs)) vss))
           (vsf  (map (lambda (vs) (cons (list x false) vs)) vss)))
        (append vst vsf))))
;
(define (eval-formula f v)
    (cond
        ((var? f) (second (assoc f v))) ; assoc: Locates the first element of lst whose car is equal to v according to is-equal?. If such an element exists, the pair (i.e., an element of lst) is returned. Otherwise, the result is #f.
        ((neg? f) (not (eval-formula (neg-subf f) v)))
        ((conj? f) (and
            (eval-formula (conj-left f) v)
            (eval-formula (conj-rght f) v)))
        ((disj? f) (or
            (eval-formula (disj-left f) v)
            (eval-formula (disj-rght f) v)))
    ))

; np. (eval-formula some-formula (list (list 'p #f) (list 'q #t))) ;; p i q dla p = f i q = t

(define (falsifiable-eval? f)
    (define (is-false v)
        (not (eval-formula f v)))
    (let* [
        (vars (free-vars f))
        (all-vals (gen-vals vars))
        (false-vals (filter is-false all-vals))
        ]
        (if (= (length false-vals) 0)
            false
            (first false-vals)))) ; mozna sprobowac ormap / andmap ! (zamiast filter)
;2 sposob ! ormap zwraca pierwsze wartosciowanie ktore da true !
(define (falsifiable-eval2? f)
    (define (is-false v)
        (if (not (eval-formula f v))
            v
            false))
    (let* [
        (vars (free-vars f))
        (all-vals (gen-vals vars))
        ]
        (ormap is-false all-vals)))



; (falsifiable-eval? some-formula) np p = t q = f
; (falsifiable-eval? tauthology) brak falszujacego wartosciowania

;zad5

(define (nnf1? f)
    (or (var? f)
        (and (neg? f)
             (var? (neg-subf f)))
        (and (disj? f)
             (nnf? (disj-left f))
             (nnf? (disj-rght f)))
        (and (conj? f)
             (nnf? (conj-left f))
             (nnf? (conj-rght f)))))

;; (make-literal false p) - zanegowane p, wpp niezanegowane
(define (make-literal b p)
    (list 'literal b p))

(define (literal? f)
    (and (= 3 (length f))
         (eq? 'literal (first f))
         (boolean? (second f))
         (var? (third f))))

(define (literal-positive? f)
    (second f))

(define (literal-var f)
    (third f))

(define (nnf? f)
    (or (var? f)
        (literal? f)
        (and (disj? f)
             (nnf? (disj-left f))
             (nnf? (disj-rght f)))
        (and (conj? f)
             (nnf? (conj-left f))
             (nnf? (conj-rght f)))))

(define (free-vars-nnf f)
    (define (go f)
        (cond ((var? f)
               (list f))
              ((literal? f)
               (list (literal-var f)))
              ((neg? f)
               (go (neg-subf f)))
              ((disj? f)
               (append (go (disj-left f)) 
                       (go (disj-rght f))))
              ((conj? f)
               (append (go (conj-left f)) 
                       (go (conj-rght f))))))
    (remove-duplicates (go f)))
    
(define (eval-formula-nnf f v)
    (cond
        ((var? f) (second (assoc f v)))
        ((literal? f)
            (let ((var-val (second (assoc (literal-var f) v))))
                 (if (literal-positive? f)
                     var-val
                     (not var-val))))
        ((neg? f) (not (eval-formula-nnf (neg-subf f) v)))
        ((conj? f) (and
            (eval-formula-nnf (conj-left f) v)
            (eval-formula-nnf (conj-rght f) v)))
        ((disj? f) (or
            (eval-formula-nnf (disj-left f) v)
            (eval-formula-nnf (disj-rght f) v)))
    ))

;zad6

(define (convert-to-nnf f)
    (define (T f)
        (cond
            [(var? f) (make-literal true f)]
            [(neg? f) (F (neg-subf f))]
            [(conj? f) (make-conj
                (T (conj-left f))
                (T (conj-rght f)))]
            [(disj? f) (make-disj
                (T (disj-left f))
                (T (disj-rght f)))]
        )
    )
    (define (F f)
        (cond
            [(var? f) (make-literal false f)]
            [(neg? f) (T (neg-subf f))]
            [(conj? f) (make-disj
                (F (conj-left f))
                (F (conj-rght f)))]
            [(disj? f) (make-conj
                (F (disj-left f))
                (F (disj-rght f)))]
        )
    )
    (T f)
)

; np. (convert-to-nnf (make-neg (make-conj 'p (make-disj 'q 'r))))

;zad7

Zestaw równoważności:
(neg-subf (make-neg p)) = p

(conj-left (make-conj p q)) = p
(conj-rght (make-conj p q)) = q

(disj-left (make-disj p q)) = p
(disj-rght (make-disj p q)) = q

P(f) ≡ (nnf? (convert-to-nnf f)) = true

Zasada indukcji. Dla dowolnej własności P, jeśli:

    dla każdego symbolu x zachodzi P(x),
    dla dowolnej formuły f, jeśli zachodzi P(f), to zachodzi P((neg f)) i
    dla dowolnych formuł f1, f2, jeśli zachodzi P(f1) i P(f2), to zachodzi również P((conj f1 f2)) i P((disj f1 f2))

to dla dowolnej formuły f, jeśli zachodzi (prop? f), to zachodzi P(f).

(define (T f)
    (cond
        [(var? f) (make-literal true f)]
        [(neg? f) (F (neg-subf f))]
        [(conj? f) (make-conj
            (T (conj-left f))
            (T (conj-rght f)))]
        [(disj? f) (make-disj
            (T (disj-left f))
            (T (disj-rght f)))]
    )
)
    
(define (F f)
    (cond
        [(var? f) (make-literal false f)]
        [(neg? f) (T (neg-subf f))]
        [(conj? f) (make-disj
            (F (conj-left f))
            (F (conj-rght f)))]
        [(disj? f) (make-conj
            (F (disj-left f))
            (F (disj-rght f)))]
    )
)

;; Silniejsza własność P
P(f) ≡ (nnf? (T f)) i (nnf? (F f))

Weźmy dowolny symbol x. Pokażmy, że P(x):
L - lewa strona
L ≡ (nnf? (T x)) ≡ (nnf? (make-literal true x)) ≡ true
P ≡ (nnf? (F x)) ≡ (nnf? (make-literal false x)) ≡ true

Weźmy dowolną formułę f i załóżmy, że P(f). Pokażmy, że P(not f):
L ≡ (nnf? (T (make-neg f))) ≡ (nnf? (F f)) ≡ true
P ≡ (nnf? (F (make-neg f))) ≡ (nnf? (T f)) ≡ true

Weźmy dowolne formuły f1, f2 i załóżmy, że P(f1) i P(f2). Pokażmy, że:
a) P(conj f1 f2)
L ≡ (nnf? (T (make-conj f1 f2))) ≡ (nnf? (make-conj (T f1) (T f2))
≡ (and (nnf? (T f1)) (nnf? (T f2))) ≡ true
Dla prawej strony tak samo

b) P(disj f1 f2)
Analogicznie

Zatem na mocy zasady o indukcji, P(f) zachodzi dla dowolnej formuły f (czyli (T f) zamienia dowolną formułę na nnf)

Skoro (convert-to-nnf f) ≡ (T f), to udowodniliśmy, że procedura convert-to-nnf zamienia dowolną formułę f na nnf.



;;zad8 samodzielnie


(define (cnf? f)
  (define (isdisj? f)
    (and (list? f)
         (<= 1 (length f))
         (eq? 'cnf-disj (car f))
         (andmap lit? (cdr f))))  ;;sprawdza czy wszystkie elementy listy spełniają predykat
  (and (list? f)
       (eq? (car f) 'cnf-conj)
       ;;sprawdzenie czy elementy to dysjunkcje
       ))


(define (lit->cnf l)
  (list 'cnf-conj (list 'cnf-disj l)))

(define (conj->cnf c1 c2)
  (append (list 'cnf-conj (cdr c1) (cdr c2))))

(define (disj->cnf c1 c2)
  (define (mmerge xs i)
    (append (list 'cnf-disj) (apply append xs)))
  (append (list 'cnf-conj)
          (map mmerge (cartesian-product
                       (map cdr (cdr c1))
                       (map cdr (cdr c2))))))


(define (convert-to-cnf f)
  (cond [(lit? f) (lit->cnf f)]
        [(conj? f)
         (let ((left (convert-to-cnf (conj-left f)))
               (rght (convert-to-cnf (conj-rght f))))
           (conj->cnf left rght))]
         [(disj? f)
          (let ((left (convert-to-cnf (disj-left f)))
               (rght (convert-to-cnf (disj-rght f))))
           (disj->cnf left rght))]
          ]))