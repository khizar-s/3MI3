import scala.concurrent.{Await, Future}
import scala.concurrent.duration.Duration
import scala.concurrent.ExecutionContext.Implicits.global
import scala.util.{Try, Success, Failure}
import java.time.LocalDateTime
import $file.collection, collection._

def summingPairs(xs: Vector[Int], sum: Int): Future[Vector[Tuple2[Int,Int]]] = {
  def summingPairsHelper(xs: Vector[Int],
                         the_pairs: Vector[Tuple2[Int,Int]]): Future[Vector[Tuple2[Int,Int]]] =
    xs match {
      case fst +: rest =>
        val pairs_here = rest.collect({case snd if fst + snd <= sum => (fst,snd)})
        val res: Future[Vector[Tuple2[Int,Int]]] = summingPairsHelper(rest, the_pairs ++ pairs_here)
        res
      case _ => Future { the_pairs }
    }

    summingPairsHelper(xs, Vector())
}