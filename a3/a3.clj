(defrecord GCConst [c])
(defrecord GCVar [v])
(defrecord GCOp [e1 e2 op])

(defrecord GCComp [e1 e2 op])
(defrecord GCAnd [t1 t2])
(defrecord GCOr [t1 t2])
(defrecord GCTrue [])
(defrecord GCFalse [])

(defrecord GCSkip [])
(defrecord GCAssign [v e])
(defrecord GCCompose [s1 s2])
(defrecord GCIf [guards])
(defrecord GCDo [guards])

(defrecord Config [stmt sig])

(defn drop-nth [n coll]
  (concat 
    (take n coll)
    (drop (inc n) coll)))

(defn emptyState []
    (fn [x] 0))

(defn updateState [sig x n]
    (fn [c] (if (= c x) n ((sig) c))))

(defn reduce [some]
    (let [command (.stmt some)]
        (cond
        (instance? GCVar command)
            (Config. ((.sig some) (.v command)) (.sig some))
        (instance? GCOp command)
            (if (instance? GCConst (.e1 command))
                (if (instance? GCConst (.e2 command))
                    (cond
                    (= :plus  (.op command)) (Config. (+ (.c (.e1 command)) (.c (.e2 command))) (.sig some))
                    (= :minus (.op command)) (Config. (- (.c (.e1 command)) (.c (.e2 command))) (.sig some))
                    (= :times (.op command)) (Config. (* (.c (.e1 command)) (.c (.e2 command))) (.sig some))
                    (= :div   (.op command)) (Config. (/ (.c (.e1 command)) (.c (.e2 command))) (.sig some))
                    )
                        (let [newcommand (reduce (Config. (.e2 command) (.sig some)))]
                        (Config. (GCOp. (.e1 command) (.stmt newcommand) (.op command)) (.sig newcommand))
                        ))
                            (let [newercommand (reduce (Config. (.e1 command) (.sig some)))]
                            (Config. (GCOp. (.stmt newercommand) (.e2 command) (.op command)) (.sig newercommand))
                            ))
        (instance? GCComp command)
            (if (instance? GCConst (.e1 command))
                (if (instance? GCConst (.e2 command))
                    (cond
                    (= :eq      (.op command)) (Config. (= (.c (.e1 command)) (.c (.e2 command))) (.sig some))
                    (= :less    (.op command)) (Config. (< (.c (.e1 command)) (.c (.e2 command))) (.sig some))
                    (= :greater (.op command)) (Config. (> (.c (.e1 command)) (.c (.e2 command))) (.sig some))
                    )
                        (let [newcommand (reduce (Config. (.e2 command) (.sig some)))]
                        (Config. (GCOp. (.e1 command) (.stmt newcommand) (.op command)) (.sig newcommand))
                        ))
                            (let [newercommand (reduce (Config. (.e1 command) (.sig some)))]
                            (Config. (GCOp. (.stmt newercommand) (.e2 command) (.op command)) (.sig newercommand))
                            ))
        (instance? GCAnd command)
            (if (or (instance? GCTrue (.t1 command)) (instance? GCFalse (.t1 command)))
                (if (or (instance? GCTrue (.t2 command)) (instance? GCFalse (.t2 command)))
                    (if (and (instance? GCTrue (.t1 command)) (instance? GCTrue (.t2 command)))
                        (Config. (GCTrue.) (.sig some))
                            (Config. (GCFalse.) (.sig some))) 
                                (let [newcommand (reduce (Config. (.t2 command) (.sig some)))]
                                (Config. (GCAnd. (.t1 command) (.stmt newcommand)) (.sig newcommand))
                                ))
                                    (let [newcommand (reduce (Config. (.t1 command) (.sig some)))]
                                    (Config. (GCAnd. (.stmt newcommand) (.t2 command)) (.sig newcommand))
                                    ))
        (instance? GCOr command)
            (if (or (instance? GCTrue (.t1 command)) (instance? GCFalse (.t1 command)))
                (if (or (instance? GCTrue (.t2 command)) (instance? GCFalse (.t2 command)))
                    (if (or (instance? GCTrue (.t1 command)) (instance? GCTrue (.t2 command)))
                        (Config. (GCTrue.) (.sig some))
                            (Config. (GCFalse.) (.sig some))) 
                                (let [newcommand (reduce (Config. (.t2 command) (.sig some)))]
                                (Config. (GCAnd. (.t1 command) (.stmt newcommand)) (.sig newcommand))
                                ))
                                    (let [newcommand (reduce (Config. (.t1 command) (.sig some)))]
                                    (Config. (GCAnd. (.stmt newcommand) (.t2 command)) (.sig newcommand))
                                    ))
        (instance? GCAssign command)
            (if (instance? GCConst (.e command))
                (Config. (GCSkip.) (updateState (.sig some) (.v command) (.c (.e command))))
                    (let [newcommand (reduce (Config. (.e command) (.sig some)))]
                    (Config. (GCAssign. (.v command) (.stmt newcommand)) (.sig newcommand))
                    ))
        (instance? GCCompose command)
            (if (instance? GCSkip (.s1 command))
                (Config. (.s2 command) (.sig some))
                    (let [newcommand (reduce (Config. (.s1 command) (.sig some)))]
                    (Config. (GCCompose. (.stmt newcommand) (.s2 command)) (.sig newcommand))
                    ))
        (instance? GCIf command)
            (if (= 0 (count (.guards command)))
                (Config. (GCSkip.) (.sig some))
                    (let [random (rand-int (count (.guards command)))]
                    (if (instance? GCTrue (get (get (.guards command) random) 0))
                        (Config. (get (get (.guards command) random) 1) (.sig some))
                            (if (instance? GCFalse (get (get (.guards command) random) 0))
                                (Config. (GCIf. (drop-nth random (.guards command))) (.sig some))
                                    (let [newcommand (reduce (Config. (get (get (.guards command) random) 0) (.sig some)))]
                                    (Config. (assoc-in (.guards command) [random 0] (.stmt newcommand)) (.sig newcommand))
                                    )))
                    ))
        (instance? GCDo command)
            (if (= 0 (count (.guards command)))
                (Config. (GCSkip.) (.sig some))
                    (let [allguards (.guards command)
                        newguards (.guards command)
                        length    (count allguards)
                        ifguards  (loop [x 0]
                                        (when (< x length)
                                            (assoc-in (newguards) [x 1] (GCCompose. (get (get allguards x) 1) command))
                                            (recur (+ x 1))
                                            ))]
                    (Config. (GCIf. ifguards) (.sig some))
                    ))
        )))