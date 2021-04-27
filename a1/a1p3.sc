sealed trait VarExpr
case class Const(x: Int) extends VarExpr
case class Neg(x: VarExpr) extends VarExpr
case class Abs(x: VarExpr) extends VarExpr
case class Plus(x: VarExpr, y: VarExpr) extends VarExpr
case class Times(x: VarExpr, y: VarExpr) extends VarExpr
case class Minus(x: VarExpr, y: VarExpr) extends VarExpr
case class Exp(x: VarExpr, y: VarExpr) extends VarExpr
case class Var(x: Symbol) extends VarExpr
case class Subst(x: VarExpr, y: Symbol, z: VarExpr) extends VarExpr
    
def interpretVarExpr(e: VarExpr): Int = e match {
    case Const(x) => x
    case Neg(x) => interpretVarExpr(x) * -1
    case Abs(x) => if (interpretVarExpr(x) < 0) {
        interpretVarExpr(x) * -1
    } else {
        interpretVarExpr(x)
    }
    case Plus(x, y) => interpretVarExpr(x) + interpretVarExpr(y)
    case Times(x, y) => interpretVarExpr(x) * interpretVarExpr(y)
    case Minus(x, y) => interpretVarExpr(x) - interpretVarExpr(y)
    case Exp(x, y) => Math.pow(interpretVarExpr(x), interpretVarExpr(y)).toInt
    case Subst(x, y, z) => interpretVarExpr(substitute(x, y, z))
}

def substitute(x: VarExpr, y: Symbol, z: VarExpr): VarExpr = x match {
    case Const(c) => Const(c)
    case Neg(c) => Neg(substitute(c, y, z))
    case Abs(c) => Abs(substitute(c, y, z))
    case Plus(c1, c2) => Plus(substitute(c1, y, z), substitute(c2, y, z))
    case Times(c1, c2) => Times(substitute(c1, y, z), substitute(c2, y, z))
    case Minus(c1, c2) => Minus(substitute(c1, y, z), substitute(c2, y, z))
    case Exp(c1, c2) => Exp(substitute(c1, y, z), substitute(c2, y, z))
    case Var(c) => {
        if (c == y) {
            z
        } else {
            Var(c)
        }
    }
    case Subst(a, b, c) => substitute(substitute(a, b, c), y, z)
}