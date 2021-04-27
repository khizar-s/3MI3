class VarExpr
    def interpret
        return 0
    end
end

class Const < VarExpr
    attr_accessor :c
    def initialize(c)
        @c = c
    end
    def interpret
        return c
    end
end

class Neg < VarExpr
    attr_accessor :c
    def initialize(c)
        @c = c
    end
    def interpret
        return -1 * c.interpret
    end
end

class Abs < VarExpr
    attr_accessor :c
    def initialize(c)
        @c = c
    end
    def interpret
        return c.interpret.abs
    end
end

class Plus < VarExpr
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

class Times < VarExpr
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

class Minus < VarExpr
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

class Exp < VarExpr
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

# We assume our variable is represented by a string
class Var < VarExpr
    attr_accessor :c
    def initialize(c)
        @c = c
    end
end

class Subst < VarExpr
    attr_accessor :a
    attr_accessor :b
    attr_accessor :c
    def initialize(a, b, c)
        @a = a
        @b = b
        @c = c
    end
    def interpret
        return substitute(a, b, c).interpret
    end
end

def substitute(x, y, z)
    if x.class == Const
        Const.new(x.c)
    elsif x.class == Neg
        Neg.new(substitute(x.c, y, z))
    elsif x.class == Abs
        Abs.new(substitute(x.c, y, z))
    elsif x.class == Plus
        Plus.new(substitute(x.c1, y, z), substitute(x.c2, y, z))
    elsif x.class == Times
        Times.new(substitute(x.c1, y, z), substitute(x.c2, y, z))
    elsif x.class == Minus
        Minus.new(substitute(x.c1, y, z), substitute(x.c2, y, z))
    elsif x.class == Exp
        Exp.new(substitute(x.c1, y, z), substitute(x.c2, y, z))
    elsif x.class == Var
        if (x.c == y)
            z
        else
            Var.new(x.c)
        end
    elsif x.class == Subst
        substitute(substitute(x.a, x.b, x.c), y, z)
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

def construct_var(c)
    return Var.new(c)
end

def construct_subst(x, y, z)
    return Subst.new(x, y, z)
end