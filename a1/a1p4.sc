sealed trait MixedExpr
case class Const(x: Int) extends MixedExpr
case class Neg(x: MixedExpr) extends MixedExpr
case class Abs(x: MixedExpr) extends MixedExpr
case class Plus(x: MixedExpr, y: MixedExpr) extends MixedExpr
case class Times(x: MixedExpr, y: MixedExpr) extends MixedExpr
case class Minus(x: MixedExpr, y: MixedExpr) extends MixedExpr
case class Exp(x: MixedExpr, y: MixedExpr) extends MixedExpr
case object TT extends MixedExpr
case object FF extends MixedExpr
case class Bnot(x: MixedExpr) extends MixedExpr
case class Bor(x1: MixedExpr, x2: MixedExpr) extends MixedExpr
case class Band(x1: MixedExpr, x2: MixedExpr) extends MixedExpr

def interpretMixedExpr(e: MixedExpr): Option[Either[Int, Boolean]] = e match {
    case Const(x) => Some(Left(x))
    case Neg(x) => interpretMixedExpr(x) match {
        case Some(Left(c)) => Some(Left((c * -1)))
        case Some(Right(c)) => None
        case None => None
    }
    case Abs(x) => interpretMixedExpr(x) match {
        case Some(Left(c)) => {
            if (c < 0) {
                Some(Left(c * -1))
            } else {
                Some(Left(c))
            }
        }
        case Some(Right(c)) => None
        case None => None
    }
    case Plus(x, y) => interpretMixedExpr(x) match {
        case Some(Left(c1)) => interpretMixedExpr(y) match {
            case Some(Left(c2)) => Some(Left(c1 + c2))
            case Some(Right(c2)) => None
            case None => None
        }
        case Some(Right(c1)) => None
        case None => None 
    }
    case Times(x, y) => interpretMixedExpr(x) match {
        case Some(Left(c1)) => interpretMixedExpr(y) match {
            case Some(Left(c2)) => Some(Left(c1 * c2))
            case Some(Right(c2)) => None
            case None => None
        }
        case Some(Right(c1)) => None
        case None => None
    }
    case Minus(x, y) => interpretMixedExpr(x) match {
        case Some(Left(c1)) => interpretMixedExpr(y) match {
            case Some(Left(c2)) => Some(Left(c1 - c2))
            case Some(Right(c2)) => None
            case None => None
        }
        case Some(Right(c1)) => None
        case None => None
    }
    case Exp(x, y) => interpretMixedExpr(x) match {
        case Some(Left(c1)) => interpretMixedExpr(y) match {
            case Some(Left(c2)) => Some(Left(Math.pow(c1, c2).toInt))
            case Some(Right(c2)) => None
            case None => None
        }
        case Some(Right(c1)) => None
        case None => None
    }
    case TT => Some(Right(true))
    case FF => Some(Right(false))
    case Bnot(x) => interpretMixedExpr(x) match {
        case Some(Right(true)) => Some(Right(false))
        case Some(Right(false)) => Some(Right(true))
        case Some(Left(x)) => None
        case None => None 
    }
    case Bor(x1, x2) => interpretMixedExpr(x1) match {
        case Some(Right(true)) => Some(Right(true))
        case Some(Right(false)) => interpretMixedExpr(x2) match {
            case Some(Right(true)) => Some(Right(true))
            case Some(Right(false)) => Some(Right(false))
            case Some(Left(x)) => None
            case None => None
        }
        case Some(Left(x)) => None
        case None => None
    }
    case Band(x1, x2) => interpretMixedExpr(x1) match {
        case Some(Right(false)) => Some(Right(false))
        case Some(Right(true)) => interpretMixedExpr(x2) match {
            case Some(Right(true)) => Some(Right(true))
            case Some(Right(false)) => Some(Right(false))
            case Some(Left(x)) => None
            case None => None
        }
        case Some(Left(x)) => None
        case None => None
    }
}