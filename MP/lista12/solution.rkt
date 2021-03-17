#lang racket

(require "graph.rkt")
(provide bag-stack@ bag-fifo@)

;; struktura danych - stos
(define-unit bag-stack@
  (import)
  (export bag^)

  (define (bag? b)
    (list? b))

  (define empty-bag
    null)

  (define (bag-empty? b)
    (null? b))

  (define (bag-insert b v)
    (cons v b))

  (define (bag-peek b)
    (car b))

  (define (bag-remove b)
    (cdr b))
)


;; struktura danych - kolejka FIFO
(define-unit bag-fifo@
  (import)
  (export bag^)

;; konstruktor fifo
(define (make-fifo in out)
  (if (null? out)
      (cons in (reverse in))
      (cons in out)))

;;selektory fifo
(define (fifo-in f)
  (car f))

(define (fifo-out f)
  (cdr f))

  
  (define (bag? b)
    (and (pair? b)
         (list? (fifo-in b))
         (list? (fifo-out b))))

  (define empty-bag
    (make-fifo null null))

  (define (bag-empty? b)
    (and (pair? b)
         (null? (fifo-in b))
         (null? (fifo-out b))))

  (define (bag-insert b v)
    (make-fifo (cons v (fifo-in b)) (fifo-out b)))

  (define (bag-peek b)
    (car (fifo-out b)))

  (define (bag-remove b)
    (make-fifo (reverse (cdr (reverse (fifo-in b)))) (cdr (fifo-out b))))
)

;; otwarcie komponentów stosu i kolejki

(define-values/invoke-unit bag-stack@
  (import)
  (export (prefix stack: bag^)))

(define-values/invoke-unit bag-fifo@
  (import)
  (export (prefix fifo: bag^)))

;; testy w Quickchecku
(require quickcheck)

;; testy kolejek i stosów
(define-unit bag-tests@
  (import bag^)
  (export)
  
  ;; test przykładowy: jeśli do pustej struktury dodamy element
  ;; i od razu go usuniemy, wynikowa struktura jest pusta

  (quickcheck
   (property ([s arbitrary-symbol])
             (bag-empty? (bag-remove (bag-insert empty-bag s)))))
  
  (quickcheck
   (property ([s arbitrary-symbol])
             (eq? (bag-peek (bag-insert empty-bag s)) s)))

  (quickcheck
   (bag-empty? empty-bag))

)

;; uruchomienie testów dla obu struktur danych

(invoke-unit bag-tests@ (import (prefix stack: bag^)))
(invoke-unit bag-tests@ (import (prefix fifo: bag^)))


(define-unit fifo-tests@
  (import bag^)
  (export)

  ;;sprawdza czy dobrze porzadkuje elementy
  (quickcheck
   (property ([s arbitrary-symbol]
              [s2 arbitrary-symbol])
             (eq? (bag-peek (bag-insert (bag-insert empty-bag s) s2)) s)))

  (quickcheck
   (property ([s arbitrary-symbol]
              [s2 arbitrary-symbol]
              [s3 arbitrary-symbol])
             (eq? (bag-peek (bag-remove (bag-insert (bag-insert (bag-insert empty-bag s) s2) s3))) s2)))

  (quickcheck
   (property ([s arbitrary-symbol]
              [s2 arbitrary-symbol]
              [s3 arbitrary-symbol])
             (eq? (bag-peek (bag-remove (bag-remove (bag-insert (bag-insert (bag-insert empty-bag s) s2) s3)))) s3)))

)

(invoke-unit fifo-tests@ (import (prefix fifo: bag^)))

;; otwarcie komponentu grafu
(define-values/invoke-unit/infer simple-graph@)

;; otwarcie komponentów przeszukiwania 
;; w głąb i wszerz
(define-values/invoke-unit graph-search@
  (import graph^ (prefix stack: bag^))
  (export (prefix dfs: graph-search^)))

(define-values/invoke-unit graph-search@
  (import graph^ (prefix fifo: bag^))
  (export (prefix bfs: graph-search^)))

;; graf testowy
(define test-graph
  (graph
   (list 1 2 3 4)
   (list (edge 1 3)
         (edge 1 2)
         (edge 2 4))))

(define test-graph-2
  (graph
   (list 1 2)
   (list (edge 1 2)
         (edge 2 1))))

(define test-graph-3
  (graph
   (list 1 2 3)
   (list (edge 1 3)
         (edge 2 3)
         (edge 3 2)
         (edge 2 1))))

(define test-graph-4
  (graph
   (list 1 2 3 4)
   (list (edge 1 2)
         (edge 2 4)
         (edge 1 4)
         (edge 4 2)
         (edge 3 4)
         (edge 3 1)
         (edge 2 1)
         )))


;; TODO: napisz inne testowe grafy

;; uruchomienie przeszukiwania na przykładowym grafie
(bfs:search test-graph 1)
(dfs:search test-graph 1)
(bfs:search test-graph-2 1)
(dfs:search test-graph-2 1)
(bfs:search test-graph-3 1)
(dfs:search test-graph-3 1)
(bfs:search test-graph-4 1)
(dfs:search test-graph-4 1)
(bfs:search test-graph-4 2)
(dfs:search test-graph-4 2)

;; TODO: uruchom przeszukiwanie na swoich przykładowych grafach