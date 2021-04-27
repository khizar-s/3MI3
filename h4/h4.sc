sealed trait Stream[+A]
case object SNil extends Stream[Nothing]
case class Cons[A](a: A, f: Unit => Stream[A]) extends Stream[A]

def filter[A](p: (A) => Boolean, s: => Stream[A]): Stream[A] = s match {
    case SNil => SNil
    case Cons(a, f) => p(a) match {
        case true => Cons(a, _ => filter(p, f()))
        case false => filter(p, f())
    }
}

def merge[A](l: => Stream[A], r: => Stream[A]): Stream[A] = l match {
    case SNil => r
    case Cons(a, f) => Cons(a, _ => merge(r, f()))
}

def zip[A,B](l: => Stream[A], r: => Stream[B]): Stream[(A,B)] = l match {
    case SNil => SNil
    case Cons (a, f) => r match {
        case SNil => SNil
        case Cons(b, g) => Cons((a, b), _ => zip(f(), g()))
    }
}

def all[A](p: (A) => Boolean, s: => Stream[A]): Boolean = s match {
    case SNil => true
    case Cons(a, f) => p(a) match {
        case true => all(p, f())
        case false => false
    }
}

def exists[A](p: (A) => Boolean, s: => Stream[A]): Boolean = s match {
    case SNil => false
    case Cons(a, f) => p(a) match {
        case true => true
        case false => exists(p, f())
    }
}