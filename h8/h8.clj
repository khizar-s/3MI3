(load-file "./unwindrec.clj")

(unwindrec exponent [x y]
    (= y 0) 1
    (> y 0) (* x (exponent x (- y 1)))
    (throw (Exception. "Trying to calculate the exponent of a negative number.")))

(defn exponent-tr [x y]
    (unwindrec exponent-tr-helper [x y collect]
            (= y 0) collect
            (> y 0) (exponent-tr-helper x (- y 1) (* collect x))
            (throw (Exception. "Trying to calculate the exponent of a negative number.")))
    (exponent-tr-helper x y 1))

(unwindrec sumlist [s]
    (empty? s) 0
    (not-empty s) (+ (first s) (sumlist (rest s))) 
    (throw (Exception. "Trying to calculate the sum of an empty list.")))

(defn sumlist-tr [s]
    (unwindrec sumlist-tr-helper [s collect]
        (empty? s) collect
        (not-empty s) (sumlist-tr-helper (rest s) (+ collect (first s))))
    (sumlist-tr-helper s 0)
)

(unwindrec flattenlist [s]
    (empty? s) nil
    (not-empty s) (concat (first s) (flattenlist (rest s))))

(defn flattenlist-tr [s]
    (unwindrec flattenlist-tr-helper [s collect]
        (empty? s) collect
        (not-empty s) (flattenlist-tr-helper (rest s) (concat collect (first s))))
    (flattenlist-tr-helper s nil))

(unwindrec postfixes [l]
    (empty? l) '(())
    (not-empty l) (cons l (postfixes (rest l))))

(defn postfixes-tr [l]
    (unwindrec postfixes-tr-helper [l collect]
        (empty? l) (concat collect [()])
        (not-empty l) (postfixes-tr-helper (rest l) (concat collect [l])))
    (postfixes-tr-helper l nil))