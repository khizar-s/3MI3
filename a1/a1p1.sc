sealed trait Expr
case class Const(x: Int) extends Expr
case class Neg(x: Expr) extends Expr
case class Abs(x: Expr) extends Expr
case class Plus(x: Expr, y: Expr) extends Expr
case class Times(x: Expr, y: Expr) extends Expr
case class Minus(x: Expr, y: Expr) extends Expr
case class Exp(x: Expr, y: Expr) extends Expr

def interpretExpr(e: Expr): Int = e match {
    case Const(x) => x
    case Neg(x) => interpretExpr(x) * -1
    case Abs(x) => if (interpretExpr(x) < 0) {
        interpretExpr(x) * -1
    } else {
        interpretExpr(x)
    }
    case Plus(x, y) => interpretExpr(x) + interpretExpr(y)
    case Times(x, y) => interpretExpr(x) * interpretExpr(y)
    case Minus(x, y) => interpretExpr(x) - interpretExpr(y)
    case Exp(x, y) => Math.pow(interpretExpr(x), interpretExpr(y)).toInt
}