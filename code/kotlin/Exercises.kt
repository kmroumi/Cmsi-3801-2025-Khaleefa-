import java.io.File
import java.io.FileNotFoundException
import java.io.IOException

fun firstThenLowerCase(xs: List<String>, p: (String) -> Boolean): String? {
    for (s in xs) if (p(s)) return s.lowercase()
    return null
}

fun say(): Say = Say("")
fun say(first: String): Say = Say(first)

class Say(private val built: String) {
    val phrase: String get() = built
    fun and(next: String): Say = Say("$built $next")
}

@Throws(IOException::class)
fun meaningfulLineCount(path: String): Long {
    try {
        val file = File(path)
        if (!file.exists()) throw FileNotFoundException("No such file: $path")
        return file.readLines().count {
            val t = it.trim()
            t.isNotEmpty() && !t.startsWith("#") && !t.startsWith("//")
        }.toLong()
    } catch (e: FileNotFoundException) {
        throw e
    }
}

data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {
    init {
        if (listOf(a, b, c, d).any { it.isNaN() })
            throw IllegalArgumentException("Coefficients cannot be NaN")
    }

    fun coefficients(): List<Double> = listOf(a, b, c, d)
    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)
    operator fun plus(q: Quaternion) = Quaternion(a + q.a, b + q.b, c + q.c, d + q.d)
    operator fun times(q: Quaternion): Quaternion {
        val e = q.a; val f = q.b; val g = q.c; val h = q.d
        return Quaternion(
            a * e - b * f - c * g - d * h,
            a * f + b * e + c * h - d * g,
            a * g - b * h + c * e + d * f,
            a * h + b * g - c * f + d * e
        )
    }

    override fun toString(): String {
        if (a == 0.0 && b == 0.0 && c == 0.0 && d == 0.0) return "0"
        val s = StringBuilder()
        if (a != 0.0) s.append(a)
        appendImag(s, b, 'i')
        appendImag(s, c, 'j')
        appendImag(s, d, 'k')
        return if (s.isEmpty()) "0" else s.toString()
    }

    private fun appendImag(sb: StringBuilder, coef: Double, unit: Char) {
        if (coef == 0.0) return
        val sign = if (coef < 0) "-" else if (sb.isEmpty()) "" else "+"
        val mag = kotlin.math.abs(coef)
        sb.append(sign)
        if (mag == 1.0) sb.append(unit)
        else sb.append(mag).append(unit)
    }

    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }
}

sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(s: String): Boolean
    fun insert(s: String): BinarySearchTree
    companion object { val Empty: BinarySearchTree = EmptyTree }
}

object EmptyTree : BinarySearchTree {
    override fun size() = 0
    override fun contains(s: String) = false
    override fun insert(s: String): BinarySearchTree = Node(s, this, this)
    override fun toString() = "()"
}

data class Node(val value: String, val left: BinarySearchTree, val right: BinarySearchTree) : BinarySearchTree {
    override fun size(): Int = 1 + left.size() + right.size()
    override fun contains(s: String): Boolean = when {
        s == value -> true
        s < value -> left.contains(s)
        else -> right.contains(s)
    }
    override fun insert(s: String): BinarySearchTree = when {
        s == value -> this
        s < value -> Node(value, left.insert(s), right)
        else -> Node(value, left, right.insert(s))
    }
    override fun toString(): String {
        val l = if (left == BinarySearchTree.Empty) "" else left.toString()
        val r = if (right == BinarySearchTree.Empty) "" else right.toString()
        return "($l$value$r)"
    }
}
