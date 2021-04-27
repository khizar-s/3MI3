(load-file "./collection.clj")

(defn summingPairs [xs sum]
  (letfn [(summingPairsHelper [xs the_pairs]
            (if (empty? xs) the_pairs
                (let [[fst & rest] xs]
                  (recur
                   rest
                   (doall 
                    (let [remain (future (for [snd rest
                                  :when (<= (+ fst snd) sum)]
                                  [fst snd]))]
                      (concat the_pairs @remain
                            )))))))]
    (summingPairsHelper xs [])))