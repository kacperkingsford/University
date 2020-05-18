#lang racket

(provide partition quicksort)

(define (partition n xs)
  (define (partition-iter n pom1 pom2 xs)
    (if (null? xs)
        (list pom1 pom2)
        (if (> n (car xs))
            (partition-iter n (append pom1 (list (car xs))) pom2 (cdr xs))
             (partition-iter n pom1 (append pom2 (list (car xs))) (cdr xs)))))
  (partition-iter n '() '() xs))

(define (quicksort xs)
  (if (null? xs) xs
      (let ((pivot (car xs)))
        (append (quicksort (car (partition pivot (cdr xs))))
                (list pivot)
                (quicksort (car (cdr (partition pivot (cdr xs)))))))))


;testy

(quicksort '())
(quicksort '(1 2 3 4 5 6 7 8 9 10))
(quicksort '(1 9 2 83 10 -23 -1 02 3 9))
(quicksort '(10 9 8 7 6 5 4 3 2 1 ))
(quicksort '(1 -1 1 -1 1 -1 1 -1 -1 1 1 -1 0))
