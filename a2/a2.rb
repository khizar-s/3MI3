require_relative "a2"
require_relative "a2_ulterm"

class STTerm
    def typecheck
        (typeOf(Array.new)) ? true : false
    end
    
    def eraseTypes; nil end
end

class STVar < STTerm
    attr_reader :index

    def initialize(i)
        unless i.is_a?(Integer)
          throw "Constructing a lambda term out of non-lambda terms"
        end
        @index = i
    end

    def ==(r); r.is_a?(ULVar) && r.index == @index end

    def typeOf(env)
        (env.length > @index) ? env[@index] : nil
    end

    def eraseTypes
        ULVar.new(@index)
    end
end

class STApp < STTerm
    attr_reader :t1
    attr_reader :t2

    def initialize(t1, t2)
        unless t1.is_a?(STTerm) && t2.is_a?(STTerm)
          throw "Constructing a lambda term out of non-lambda terms"
        end
        @t1 = t1
        @t2 = t2
    end

    def ==(r); r.is_a?(STApp) && r.t1 == @t1 && r.t2 == @t2 end

    def typeOf(env)
        val1 = @t1.typeOf(env)
        val2 = @t2.typeOf(env)
        if (val1.is_a?(STFun))
            if (val2 == val1.dom)
                val1.codom
            else
                nil
            end
        else
            nil
        end
    end

    def eraseTypes
        ULApp.new(@t1.eraseTypes, @t2.eraseTypes)
    end
end

class STAbs < STTerm
    attr_reader :t
    attr_reader :t1

    def initialize(t, t1)
        unless t.is_a?(STType) && t1.is_a?(STTerm)
            throw "Constructing a lambda term out of non-lambda terms"
        end
        @t = t
        @t1 = t1
    end

    def ==(r); r.is_a?(STAbs) && r.t == @t && r.t1 == @t1 end

    def typeOf(env)
        newenv = env.unshift(@t)
        (@t1.typeOf(newenv)) ? STFun.new(@t, @t1.typeOf(newenv)) : nil
    end

    def eraseTypes
        ULAbs.new(@t1.eraseTypes)
    end
end

class STZero < STTerm
    def ==(r); r.is_a?(STZero) end

    def typeOf(env); STNat.new end

    def eraseTypes
        ULAbs.new(ULAbs.new(ULVar.new(0)))
    end
end

class STSuc < STTerm
    attr_reader :t

    def initialize(t)
        unless t.is_a?(STTerm)
            throw "Constructing a lambda term out of non-lambda terms"
        end
        @t = t
    end

    def ==(r); r.is_a?(STSuc) && r.t == @t end

    def typeOf(env)
        (@t.typeOf(env) == STNat.new) ? STNat.new : nil
    end

    def eraseTypes
        ULApp.new(ULAbs.new(ULAbs.new(ULAbs.new(ULApp.new(ULVar.new(1),ULApp.new(ULApp.new(ULVar.new(2),ULVar.new(1)),ULVar.new(0)))))), @t.eraseTypes)
    end
end

class STIsZero < STTerm
    attr_reader :t

    def initialize(t)
        unless t.is_a?(STTerm)
            throw "Constructing a lambda term out of non-lambda terms"
        end
        @t = t
    end

    def ==(r); r.is_a?(STIsZero) && r.t == @t end

    def typeOf(env)
        (@t.typeOf(env) == STNat.new) ? STBool.new : nil
    end

    def eraseTypes
        ULApp.new(ULAbs.new(ULApp.new(ULApp.new(ULVar.new(0), ULAbs.new(STFalse.eraseTypes)), STTrue.eraseTypes)), @t.eraseTypes)
    end
end

class STTrue < STTerm
    def ==(r); r.is_a?(STTrue) end

    def typeOf(env); STBool.new end

    def eraseTypes
        ULAbs.new(ULAbs.new(ULVar.new(1)))
    end
end

class STFalse < STTerm
    def ==(r); r.is_a?(STFalse) end

    def typeOf(env); STBool.new end

    def eraseTypes
        ULAbs.new(ULAbs.new(ULVar.new(0)))
    end
end

class STTest < STTerm
    attr_reader :t1
    attr_reader :t2
    attr_reader :t3

    def initialize(t1, t2, t3)
        unless t1.is_a?(STTerm) && t2.is_a?(STTerm) && t3.is_a?(STTerm)
            throw "Constructing a lambda term out of non-lambda terms"
        end
        @t1 = t1
        @t2 = t2
        @t3 = t3
    end

    def ==(r); r.is_a?(STTest) && r.t1 == @t1 && r.t2 == @t2 && r.t3 == @t3 end

    def typeOf(env)
        type1 = @t1.typeOf(env)
        type2 = @t2.typeOf(env)
        type3 = @t3.typeOf(env)
        if (type1 == STBool.new) && (type2 == type3)
            type2
        else
            nil
        end
    end

    def eraseTypes
        ULApp.new(ULApp.new(ULApp.new(ULAbs.new(ULAbs.new(ULAbs.new(ULApp.new(ULApp.new(ULVar.new(2), ULVar.new(1)), ULVar.new(0))))), @t1.eraseTypes), @t2.eraseTypes), @t3.eraseTypes)
    end
end

class STType end

class STNat < STType
    def ==(type); type.is_a?(STNat) end
    def to_s; "nat" end
end

class STBool < STType
    def ==(type); type.is_a?(STBool) end
    def to_s; "bool" end
end

class STFun < STType
    attr_reader :dom
    attr_reader :codom
    
    def initialize(dom, codom)
        unless dom.is_a?(STType) && dom.is_a?(STType)
            throw "Constructing a type out of non-types"
        end
        @dom = dom; @codom = codom
    end

    def ==(type); type.is_a?(STFun) && type.dom == @dom && type.codom == @codom end 
    def to_s; "(" + dom.to_s + ") -> (" + codom.to_s + ")" end
end