sealed trait LeafTree[A]
case class Leaf[A](item: A) extends LeafTree[A]
case class Branch[A](left_tree: LeafTree[A], right_tree: LeafTree[A]) extends LeafTree[A]

sealed trait BinTree[A]
case class Empty[A]() extends BinTree[A]
case class Node[A](item: A, left_tree: BinTree[A], right_tree: BinTree[A]) extends BinTree[A]

//In this tree, we must specify the type when constructing unlike the previous trees
sealed trait StructTree[A, B]
case class LeafNode[A, B](item: B) extends StructTree[A, B]
case class nonLeafNode[A, B](item: A, left_tree: StructTree[A, B], right_tree: StructTree[A, B]) extends StructTree[A, B]

def flatten[A](tree: LeafTree[A]): List[A] = tree match {
  case Leaf(item) => List(item)
  case Branch(left_tree, right_tree) => flatten(left_tree) ++ flatten(right_tree)
}

def flatten[A](tree: BinTree[A]): List[A] = tree match {
  case Empty() => List()
  case Node(item, left_tree, right_tree) => flatten(left_tree) ++ List(item) ++ flatten(right_tree)
}

def orderedElems(tree: LeafTree[Int]): List[Int] = {

  var list = flatten(tree)
  var result = List[Int]()
  val l = list.length

  //Used a variation of selection sort where I kept adding the maximum element(s) to the end of a new List
  while(result.length < l) {
    //Each iteration brings a new maximum
    var num = list.filter(_ == list.max)
    //Each maximum is appended to the end of the list
    result = num ++ result
    //Modified a list by using filter and assigning it to a variable that changes every iteration
    list = list.filter(_ < list.max)
  }

  result
}

def orderedElems(tree: BinTree[Int]): List[Int] = {

  var list = flatten(tree)
  var result = List[Int]()
  val l = list.length

  //Used a variation of selection sort where I kept adding the maximum element(s) to the end of a new List
  while(result.length < l) {
    //Each iteration brings a new maximum
    var num = list.filter(_ == list.max)
    //Each maximum is appended to the end of the list
    result = num ++ result
    //Modified a list by using filter and assigning it to a variable that changes every iteration
    list = list.filter(_ < list.max)
  }

  result
}
