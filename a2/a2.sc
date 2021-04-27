import $file.a2_ulterm, a2_ulterm._ 

sealed trait STTerm
case class STVar(index: Int) extends STTerm {
    override def toString() = index.toString()
}
case class STApp(t1: STTerm, t2: STTerm) extends STTerm {
    override def toString() = "(" + t1.toString() + ") (" + t2.toString() + ")"
}
case class STAbs(t: STType, t1: STTerm) extends STTerm {
    override def toString() = "lambda " + t.toString + " . " + t1.toString()
}
case object STZero extends STTerm {
    override def toString() = "0"
}
case class STSuc(t: STTerm) extends STTerm {
    override def toString() = "S " + t.toString()
}
case class STIsZero(t: STTerm) extends STTerm {
    override def toString() = t.toString() + " ?"
}
case object STTrue extends STTerm {
    override def toString() = "True"
}
case object STFalse extends STTerm {
    override def toString() = "False"
}
case class STTest(t1: STTerm, t2: STTerm, t3: STTerm) extends STTerm {
    override def toString() = "test " + t1.toString() + " " + t2.toString() + " " + t3.toString()
}

sealed trait STType
case object STNat extends STType {
    override def toString() = "nat"
}
case object STBool extends STType {
    override def toString() = "bool"
}
case class STFun(dom: STType, codom: STType) extends STType {
    override def toString() = "(" + dom.toString + ") -> (" + codom.toString + ")"
}

def typecheck(term: STTerm): Boolean = {
    def typeOf(env: List[STType], exp: STTerm): Option[STType] = exp match {
        case STVar(index) => (env.length > index) match {
            case true => Some(env(index))
            case false => None
        }
        case STAbs(t, t1) => {
            val newenv = List(t) ++ env
            val newtype = typeOf(newenv, t1)
            newtype match {
                case Some(value) => Some(STFun(t, value))
                case None => None
            }
        }
        case STApp(t1, t2) => typeOf(env, t1) match {
            case Some(value) => value match {
                case STBool => None
                case STNat => None
                case STFun(dom, codom) => typeOf(env, t2) match {
                    case Some(value) if (value == dom) => Some(codom)
                    case Some(value) => None
                    case None => None
                }
            } 
            case None => None
        }
        case STZero => Some(STNat)
        case STSuc(t) => typeOf(env, t) match {
            case Some(value) if (value == STNat) => Some(STNat)
            case Some(value) => None
            case None => None
        }
        case STIsZero(t) => typeOf(env, t) match {
            case Some(value) if (value == STNat) => Some(STBool)
            case Some(value) => None
            case None => None
        }
        case STTrue => Some(STBool)
        case STFalse => Some(STBool)
        case STTest(t1, t2, t3) => typeOf(env, t1) match {
            case Some(value1) if (value1 == STBool) => typeOf(env, t2) match {
                case Some(value2) => typeOf(env, t3) match {
                    case Some(value3) if (value2 == value3) => Some(value2)
                    case Some(value) => None
                    case None => None
                }
                case Some(value) => None
                case None => None
            }
            case Some(value) => None
            case None => None
        }
    }
    
    typeOf(List[STType](), term) match {
        case Some(value) => true
        case None => false
    }
}

def eraseTypes(term: STTerm): ULTerm = term match {
    case STVar(index) => ULVar(index)
    case STAbs(t, t1) => ULAbs(eraseTypes(t1))
    case STApp(t1, t2) => ULApp(eraseTypes(t1), eraseTypes(t2))
    case STZero => ULAbs(ULAbs(ULVar(0)))
    case STSuc(t) => ULApp(ULAbs(ULAbs(ULAbs(ULApp(ULVar(1),ULApp(ULApp(ULVar(2),ULVar(1)),ULVar(0)))))),eraseTypes(t))
    case STIsZero(t) => ULApp(ULAbs(ULApp(ULApp(ULVar(0),ULAbs(eraseTypes(STFalse))),eraseTypes(STTrue))), eraseTypes(t))
    case STTrue => ULAbs(ULAbs(ULVar(1)))
    case STFalse => ULAbs(ULAbs(ULVar(0)))
    case STTest(t1, t2, t3) => ULApp(ULApp(ULApp(ULAbs(ULAbs(ULAbs(ULApp(ULApp(ULVar(2), ULVar(1)), ULVar(0))))), eraseTypes(t1)), eraseTypes(t2)), eraseTypes(t3))
}