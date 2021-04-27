def isPrime(x: Int): Boolean = {
    var c = x - 1
    while (c > 2) {
        if (x % c == 0) {
            return false
        }
        c -= 1
    }
    return true
}

def isPalindrome[A](l: List[A]): Boolean = {
    var start = 0
    var end = l.length - 1
    var mid = (l.length / 2).floor
    while (start < mid) {
        if (l(start) != l(end)) {
            return false
        }
        start += 1
        end -= 1
    }
    return true
}

def palindromechecker(x: Int): Boolean = {
    var t = x
    var r = 0

    while (t != 0) {
        r = r * 10;
        r = r + t%10;
        t = t/10;
    }

    if (x == r)
        return true;
    else
        return false;
}

def digitList(x: Int): List[Int] = {
    var result = List[Int]()
    var n = x
    while (n > 0) {
        println(result)
        println(n)
        result = result ++ List((n % 10))
        n = (n / 10)
    }
    return result
}

def primePalindrome(x: Int): Boolean = {
    var l = digitList(x)
    return (isPrime(x) && isPalindrome(l))
}