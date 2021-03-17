#lang racket

(define (close-enough-complex? x y)
  (< (magnitude (- x y)) 0.00001))

(define sqrt/c
  (->i ([n number?])
        [result (n) number?]
       #:post (n result)
       (close-enough-complex? n (* result result))))

(define/contract mysqrt
  sqrt/c
  (lambda (x) (sqrt x)))

(mysqrt 4)
(mysqrt 13)
(mysqrt -7)
;(mysqrt "a")
```

## Ćwiczenie 2
> Damian Kowalik

```racket
(define filter/c
  (parametric->/c [a] (-> (-> a any/c) (listof a) (listof a))))
  
;(filter identity 5) ;; Błąd

(define filter->i/c
  (->i ([predicate (-> any/c any/c)]
        [input list?])
       [result list?]
       #:post (result predicate input)
         (and (andmap predicate result)
              (andmap (lambda (x) (member x input)) result)
              (<= (length result) (length input)))))
              
(define filter->final/c
    (and/c filter/c filter->i/c))
    
(define/contract (filter p xs)
  filter->final/c ;; Tutaj kontrakt użyty
  (if (null? xs)
      null
      (if (p (car xs))
          (cons (car xs) (filter p (cdr xs)))
          (filter p (cdr xs)))))

(filter (lambda (x) (= 1 x)) '(1 2 3 4)) ; <- działa

```

## Ćwiczenie 3

>Mateusz Reis
```racket=
(define-signature monoid^
  ((contracted
    [elem? (-> any/c boolean?)]
    [neutral elem?]
    [oper (-> elem? elem? elem?)])))

(define-unit monoid-int@
    (import)
    (export monoid^)
    
    (define elem?
        integer? )

    (define neutral 0)

    (define oper +))
    
(define-values/invoke-unit/infer monoid-int@) 

(quickcheck
    (property 
        ([x arbitrary-integer])
        (and (eq? x (oper neutral x)) 
            (eq? x (oper x neutral)) 
            (eq? (oper x neutral) 
                (oper neutral x)
        ))))

(quickcheck
    (property
        ([x arbitrary-integer]
         [y arbitrary-integer]
         [z arbitrary-integer])
        (eq? (oper x (oper y z)) (oper (oper x y) z))))
        
       
```
> Mateusz Leonowicz
```racket=
(define-unit monoid-lists@
  (import)
  (export monoid^)

  (define elem? list?)
  
  (define neutral null)
  
  (define oper append))

(define-values/invoke-unit/infer monoid-lists@)

(require quickcheck)

(quickcheck ;; lewo i prawostronność
 (property
  ([l (arbitrary-list arbitrary-symbol)])
  (and (equal? l (oper neutral l))
       (equal? (oper neutral l) l))))

(quickcheck ;; łączność
 (property
  ([x (arbitrary-list arbitrary-symbol)]
   [y (arbitrary-list arbitrary-symbol)]
   [z (arbitrary-list arbitrary-symbol)])
  (equal? (oper x (oper y z))
          (oper (oper x y) z))))
```

## Ćwiczenie 4

## Ćwiczenie 5

```racket=
(define-signature integer-set^
  ((contracted
    [set? (-> any/c boolean?)]
    [contains? (-> integer? set? boolean?)]
    [empty set?]
    [make-singleton (-> integer? set?)]
    [union (-> set? set? set?)]
    [intersection (-> set? set? set?)])))

(define-unit list-integer-set@
  (import)
  (export integer-set^)

  (define (set? x)
      (and (list? x)
           (andmap integer? list)))

  (define (contains? el set)
    (not (not (member el set))))

  (define empty null)

  (define (make-singleton x) (cons x null))

  (define (union s1 s2)
    (remove-duplicates (append s1 s2)))

  (define (intersection s1 s2)
    (filter (lambda (x) (contains? x s2)) s1)))