class Expr
    def interpret
        return 0
    end
end

class Const < Expr
    attr_accessor :c
    def initialize(c)
        @c = c
    end
    def interpret
        return c
    end
end

class Neg < Expr
    attr_accessor :c
    def initialize(c)
        @c = c
    end
    def interpret
        return -1 * c.interpret
    end
end

class Abs < Expr
    attr_accessor :c
    def initialize(c)
        @c = c
    end
    def interpret
        return c.interpret.abs
    end
end

class Plus < Expr
    attr_accessor :c1
    attr_accessor :c2
    def initialize(c1, c2)
        @c1 = c1
        @c2 = c2
    end
    def interpret
        return c1.interpret + c2.interpret
    end
end

class Times < Expr
    attr_accessor :c1
    attr_accessor :c2
    def initialize(c1, c2)
        @c1 = c1
        @c2 = c2
    end
    def interpret
        return c1.interpret * c2.interpret
    end
end

class Minus < Expr
    attr_accessor :c1
    attr_accessor :c2
    def initialize(c1, c2)
        @c1 = c1
        @c2 = c2
    end
    def interpret
        return c1.interpret - c2.interpret
    end
end

class Exp < Expr
    attr_accessor :c1
    attr_accessor :c2
    def initialize(c1, c2)
        @c1 = c1
        @c2 = c2
    end
    def interpret
        return c1.interpret ** c2.interpret
    end
end

def construct_const(c)
    return Const.new(c)
end

def construct_neg(c)
    return Neg.new(c)
end

def construct_abs(c)
    return Abs.new(c)
end

def construct_plus(c1, c2)
    return Plus.new(c1, c2)
end

def construct_times(c1, c2)
    return Times.new(c1, c2)
end

def construct_minus(c1, c2)
    return Minus.new(c1, c2)
end

def construct_exp(c1, c2)
    return Exp.new(c1, c2)
end