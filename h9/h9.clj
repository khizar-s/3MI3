(defrecord GuardedCommand [guard command])

(defn allowed-commands
  [commands]
  (if (empty? commands) nil
      (let [[command & rest] commands]
        (if (eval (.guard command)) (cons (.command command) (allowed-commands rest))
            (allowed-commands rest)))))

(defmacro guarded-if
  [& commands]
  `(eval
    (rand-nth
        (allowed-commands
        [~@commands]))))

(defmacro guarded-do
  [& commands]
  `(allowed-commands
    [~@commands]))

(defn gcd [x y]
  (guarded-if
   (GuardedCommand. `(zero?   ~y) x)
   (GuardedCommand. `(not (zero? ~y)) `(gcd ~y (mod ~x ~y)) )))