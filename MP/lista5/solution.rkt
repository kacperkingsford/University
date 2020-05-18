#lang racket

(require "props.rkt")
(provide falsifiable-cnf?)

(define (lit? f)
  (or (var? f)
      (and (neg? f)
           (var? (neg-subf f)))))

(define (lit-pos v)
  v)

(define (lit-neg v)
  (neg v))

(define (lit-var l)
  (if (var? l)
      l
      (neg-subf l)))

(define (lit-pos? l)
  (var? l))

(define (to-nnf f)
  (cond
   [(var? f)  (lit-pos f)]
   [(neg? f)  (to-nnf-neg (neg-subf f))]
   [(conj? f) (conj (to-nnf (conj-left f))
                    (to-nnf (conj-right f)))]
   [(disj? f) (disj (to-nnf (disj-left f))
                    (to-nnf (disj-right f)))]))

(define (to-nnf-neg f)
  (cond
   [(var? f)  (lit-neg f)]
   [(neg? f)  (to-nnf (neg-subf f))]
   [(conj? f) (disj (to-nnf-neg (conj-left f))
                    (to-nnf-neg (conj-right f)))]
   [(disj? f) (conj (to-nnf-neg (disj-left f))
                    (to-nnf-neg (disj-right f)))]))

(define (mk-cnf xss)
  (cons 'cnf xss))

(define (clause? f)
  (and (list? f)
       (andmap lit? f)))

(define (cnf? f)
  (and (pair? f)
       (eq? 'cnf (car f))
       (list? (cdr f))
       (andmap clause? (cdr f))))

(define (to-cnf f)
  (define (join xss yss)
    (apply append (map (lambda (xs) (map (lambda (ys) (append xs ys)) yss)) xss)))
  (define (go f)
    (cond
     [(lit? f)  (list (list f))]
     [(conj? f) (append (go (conj-left f))
                        (go (conj-right f)))]
     [(disj? f) (join (go (disj-left f))
                      (go (disj-right f)))]))
  (mk-cnf (go f)))


(define (search-for l f)
      (if (null? f)
      #f
       (cond
         [(and (neg? l) (pair? (car f)) (neg? (car f)))
          (if (eq? (neg-subf l) (car (cdr (car f))))
              #t
              (search-for l (cdr f)))]
         
         [(and (neg? l) (pair? (car f)) (not (neg? (car (car f)))))
          (search-for l (cdr f))]
         
         [(and (not (neg? l)) (pair? (car f)) (neg? (car f)))
          (search-for l  (cdr f))]
         
         [else (if
                (eq? l (car f))
                #t
                (search-for l (cdr f)))])))

(define (is-clause-tauthology f)
  (if (null? f)
      #f
  (if (and (pair? (car f)) (neg? (car f)))
      (if (search-for (neg-subf (car f)) (cdr f))
          #t
          (is-clause-tauthology (cdr f)))
      (if (search-for (neg (car f)) (cdr f))
          #t
          (is-clause-tauthology (cdr f))))))


(define (eval-clause f) ;;jesli nie jest tautologia klauzula to :
  (define (pom xs f)
    (if (null? f)
        xs
    (if (and (pair? (car f)) (neg? (car f)))
        (if (not (is-there xs (second (car f))))
            (pom (append xs (list (list (second (car f)) #t))) (cdr f))
            (pom xs (cdr f)))
        (if (not (is-there xs (car f)))
            (pom (append xs (list(list (car f) #f))) (cdr f))
            (pom xs (cdr f))))))
  (pom (list) f))

(define (is-there xs p)
  (if (null? xs)
      #f
      (if (eq? (first (car xs)) p)
          #t
          (is-there (cdr xs) p))))

(define (falsifiable-cnf? f)
  (let(
      [f (to-cnf (to-nnf f))])
  (define (pom f) ;; usuwa przedrostek 'cnf po prostu
  (if (null? f)
      #f
    (if (is-clause-tauthology (car f))
        (pom (cdr f))
        (eval-clause (car f)))))
    (pom (cdr f))))


;Współpracowywałem z Adamem Jarząbkiem rozwiązując to zadanie.
    
       
         
         
  

      
