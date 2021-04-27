module GCL
    class GCExpr; end
    class GCTest; end
    class GCStmt; end

    class GCConst < GCExpr
        attr_reader :val

        def initialize(x)
            unless x.is_a?(Integer)
                throw "Constructing a constant out of a non integer value"
            end
            @val = x
        end
    end

    class GCVar < GCExpr
        attr_reader :val

        def initialize(x)
            unless x.is_a?(Symbol)
                throw "Constructing a variable out of a non symbol value"
            end
            @val = x
        end
    end

    class GCOp < GCExpr
        attr_reader :val1
        attr_reader :val2
        attr_reader :op

        def initialize(x, y, z)
            unless x.is_a?(GCExpr) and y.is_a?(GCExpr) and [:plus, :minus, :times, :div].include? z
                throw "Constructing an operation out of incorrect values"
            end
            @val1 = x
            @val2 = y
            @op = z
        end
    end

    class GCComp < GCTest
        attr_reader :val1
        attr_reader :val2
        attr_reader :op

        def initialize(x, y, z)
            unless x.is_a?(GCExpr) and y.is_a?(GCExpr) and [:eq, :less, :greater].include?(z)
                throw "Constructing a comparison out of incorrect values"
            end
            @val1 = x
            @val2 = y
            @op = z
        end
    end

    class GCAnd < GCTest
        attr_reader :val1
        attr_reader :val2

        def initialize(x, y)
            unless x.is_a?(GCTest) and y.is_a?(GCTest)
                throw "Constructing AND with non GCExpr values"
            end
            @val1 = x
            @val2 = y
        end
    end

    class GCOr < GCTest
        attr_reader :val1
        attr_reader :val2

        def initialize(x, y)
            unless x.is_a?(GCTest) and y.is_a?(GCTest)
                throw "Constructing OR with non GCExpr values"
            end
            @val1 = x
            @val2 = y
        end
    end

    class GCTrue < GCTest
    end

    class GCFalse < GCTest
    end

    class GCSkip < GCStmt; end

    class GCAssign < GCStmt
        attr_reader :var
        attr_reader :expr

        def initialize(x, y)
            unless x.is_a?(Symbol) and y.is_a?(GCExpr)
                throw "Constructing an assignment out of incorrect values"
            end
            @var  = x
            @expr = y
        end    
    end

    class GCCompose < GCStmt
        attr_reader :val1
        attr_reader :val2

        def initialize(x, y)
            unless x.is_a?(GCStmt) and y.is_a?(GCStmt)
                throw "Constructing a compose out of non GCStmt values"
            end
            @val1 = x
            @val2 = y
        end  
    end

    class GCIf < GCStmt
        attr_reader :guards

        def initialize(x)
            unless checker?(x)
                throw "Constructing IF out of incorrect values"
            end
            @guards = x
        end

        def checker?(val)
            val.each do |v|
                unless v[0].is_a?(GCTest) and v[1].is_a?(GCStmt)
                    return false
                end
            end
            return true
        end
    end

    class GCDo < GCStmt
        attr_reader :guards

        def initialize(x)
            unless checker?(x)
                throw "Constructing DO out of incorrect values"
            end
            @guards = x
        end

        def checker?(val)
            val.each do |v|
                unless v[0].is_a?(GCTest) and v[1].is_a?(GCStmt)
                    return false
                end
            end
            return true
        end
    end

    def stackEval(commands, result, memory)

        if commands.length() == 0
            return memory
        end

        command = commands.shift
        case command
        when GCConst
            result.unshift(command.val)
            stackEval(commands, result, memory)
        when GCVar
            stackEval(commands, result.unshift(memory.call(command.val)), memory)
        when GCOp
            commands.unshift(command.op).unshift(command.val1).unshift(command.val2)
            stackEval(commands, result, memory)
        when GCComp
            commands.unshift(command.op).unshift(command.val1).unshift(command.val2)
            stackEval(commands, result, memory)
        when GCAnd
            commands.unshift(:and).unshift(command.val1).unshift(command.val2)
            stackEval(commands, result, memory)
        when GCOr
            commands.unshift(:or).unshift(command.val1).unshift(command.val2)
            stackEval(commands, result, memory)
        when GCTrue
            result.unshift(true)
            stackEval(commands, result, memory)
        when GCFalse
            result.unshift(false)
            stackEval(commands, result, memory)
        when GCSkip
            stackEval(commands, result, memory)
        when GCAssign
            commands.unshift(:assign).unshift(command.expr)
            result.unshift(command.var)
            stackEval(commands, result, memory)
        when GCCompose
            commands.unshift(command.val2).unshift(command.val1)
            stackEval(commands, result, memory)
        when GCIf
            allguards = command.guards
            result.unshift(:ifstop)
            commands.unshift(:if)
            allguards.each do |guard|
                commands.unshift(guard[1])
                commands.unshift(:ifguard)
                commands.unshift(guard[0])
            end
            stackEval(commands, result, memory)
        when GCDo
            allguards = command.guards
            result.unshift(:dostop)
            commands.unshift(command)
            commands.unshift(:do)
            allguards.each do |guard|
                commands.unshift(guard[1])
                commands.unshift(:doguard)
                commands.unshift(guard[0])
            end
            stackEval(commands, result, memory)
        when :doguard
            bval = result.shift
            stmt = commands.shift
            if bval == true
                result.unshift(stmt)    
            end
            stackEval(commands, result, memory)
        when :do
            trueguards = []
            result.each do |guard|
                trueguards.push(guard)
                break if guard == :dostop
            end
            removestop = trueguards.pop
            if trueguards.length() > 0
                r = rand(0..trueguards.length()-1)
                commands.unshift(trueguards[r])
            else
                removedo = commands.shift
            end 
            stackEval(commands, result, memory)                   
        when :ifguard
            bval = result.shift
            stmt = commands.shift
            if bval == true    
                result.unshift(stmt)    
            end
            stackEval(commands, result, memory)
        when :if
            trueguards = []
            result.each do |guard|
                trueguards.push(guard)
                break if guard == :ifstop
            end
            removestop = trueguards.pop
            if trueguards.length() > 0
                r = rand(0..trueguards.length()-1)
                commands.unshift(trueguards[r])
                stackEval(commands, result, memory)
            else
                stackEval(commands, result, memory)
            end
        when :plus
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1+val2)
            stackEval(commands, result, memory)
        when :times
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1*val2)
            stackEval(commands, result, memory)
        when :minus
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1-val2)
            stackEval(commands, result, memory)
        when :div
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1/val2)
            stackEval(commands, result, memory)
        when :eq
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1==val2)
            stackEval(commands, result, memory)
        when :less
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1<val2)
            stackEval(commands, result, memory)
        when :greater
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1>val2)
            stackEval(commands, result, memory)
        when :and
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1&&val2)
            stackEval(commands, result, memory)
        when :or
            val1 = result.shift
            val2 = result.shift
            result.unshift(val1||val2)
            stackEval(commands, result, memory)
        when :assign
            solution = result.shift
            variable = result.shift
            stackEval(commands, result, updateState(memory, variable, solution))
        end
    end

    def emptyState
        lambda { |c|
            0
        }
    end

    def updateState(sigma, x, n)
        lambda { |c|
            if (c == x)
                n
            else
                sigma.call(c)
            end
        }
    end

    module_function :emptyState
    module_function :stackEval
    module_function :updateState
end

module GCLe
    include GCL

    class GCProgram
        include GCLe
        attr_reader :globals
        attr_reader :stmt

        def initialize(x, y)
            unless checker?(x, Symbol) and y.is_a?(GCL::GCStmt)
                throw "Constructing a program with incorrect values"
            end
            @globals = x
            @stmt = y
        end

        def checker?(val, type)
            val.each do |v|
                unless v.is_a?(type)
                    return false
                end
            end
            return true
        end
    end

    class GCLocal < GCStmt
        attr_reader :var
        attr_reader :stmt
        
        def initialize(x, y)
            unless x.is_a?(Symbol) and y.is_a?(GCL::GCStmt)
                throw "Constructing local value with incorect values"
            end
            @var = x
            @stmt = y
        end
    end

    def wellScoped(program)
        environment = program.globals
        helper(program.stmt, environment)
    end

    def helper(prog, env)
        case prog
        when GCSkip
            true
        when GCLocal
            helper(prog.stmt, env.push(prog.var))
        when GCAssign
            env.include?(prog.var) && helper(prog.expr, env)
        when GCCompose
            helper(prog.val1, env) && helper(prog.val2, env)
        when GCIf
            prog.each do |guard|
                helper(guard[0], env) && helper(guard[1], env)
            end
        when GCDo
            prog.each do |guard|
                helper(guard[0], env) && helper(guard[1], env)
            end
        when GCComp
            helper(prog.val1, env) && helper(prog.val2, env)
        when GCAnd
            helper(prog.val1, env) && helper(prog.val2, env)
        when GCOr
            helper(prog.val1, env) && helper(prog.val2, env)
        when GCTrue
            true
        when GCFalse
            true
        when GCConst
            true
        when GCVar
            env.include?(prog.val)
        when GCOp
            helper(prog.val1, env) && helper(prog.val2, env)
        end
    end

    def eval(program)
        environment = Hash.new do |hash, key|
            raise("Accessing a variable that doesn't exist!")
        end
        program.globals.each do |guard|
            environment[guard] = "something"
        end
        end_env = helper2(program.stmt, environment)
    end

    def helper2(prog, env)
        case prog
        when GCSkip
            return env
        when GCAssign
            variable = prog.var
            value = reduce(prog.expr, env)
            env[variable] = value
            return env
        when GCCompose
            res1 = helper2(prog.val1, env)
            helper2(prog.val2, res1)
        when GCLocal
            if env.include?(prog.var)
                tmp = env[prog.var]
                env[prog.var] = "no_value"
                newenv = helper2(prog.stmt, env)
                newenv[prog.var] = tmp
                return newenv
            else
                env[prog.var] = "no_value"
                newenv = helper2(prog.stmt, env)
                newenv.delete(prog.var)
                return newenv
            end
        when GCIf
            trueguards = []
            allguards = prog.guards
            allguards.each do |guard|
                if reduce(guard[0], env) == true
                    trueguards.push(guard[1])
                end
            end
            if trueguards.length() > 0
                helper2(trueguards.sample, env)
            else
                return env
            end
        when GCDo
            trueguards = []
            allguards = prog.guards
            allguards.each do |guard|
                if reduce(guard[0], env) == true
                    trueguards.push(guard[1])
                end
            end
            if trueguards.length() > 0
                newenv = helper2(trueguards.sample, env)
                recreate = GCDo.new(allguards)
                return helper2(recreate, newenv)
            else
                return env
            end
        end
    end

    def reduce(prog, env)
        case prog
        when GCConst
            prog.val
        when GCVar
            env[prog.val]
        when GCOp
            case prog.op
            when :plus
                reduce(prog.val1, env) + reduce(prog.val2, env)
            when :minus
                reduce(prog.val1, env) - reduce(prog.val2, env)
            when :times
                reduce(prog.val1, env) * reduce(prog.val2, env)
            when :div
                reduce(prog.val1, env) / reduce(prog.val2, env)
            end
        when GCComp
            case prog.op
            when :eq
                reduce(prog.val1, env) == reduce(prog.val2, env)
            when :less
                reduce(prog.val1, env) < reduce(prog.val2, env)
            when :greater
                reduce(prog.val1, env) > reduce(prog.val2, env)
            end
        when GCAnd
            reduce(prog.val1, env) && reduce(prog.val2, env)
        when GCOr
            reduce(prog.val1, env) || reduce(prog.val2, env)
        when GCTrue
            true
        when GCFalse
            false
        end
    end

    module_function :wellScoped
    module_function :helper
    module_function :eval
    module_function :helper2
    module_function :reduce
end