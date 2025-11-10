import Foundation

func firstThenLowerCase(of xs: [String], satisfying p: (String) -> Bool) -> String? {
    for s in xs where p(s) { return s.lowercased() }
    return nil
}

func say() -> Say { Say("") }
func say(_ first: String) -> Say { Say(first) }

struct Say {
    private let built: String
    init(_ built: String) { self.built = built }
    var phrase: String { built }
    func and(_ next: String) -> Say { Say(built + " " + next) }
}

func meaningfulLineCount(_ path: String) async -> Result<Int, Error> {
    do {
        let text = try String(contentsOfFile: path, encoding: .utf8)
        let count = text.split(separator: "\n", omittingEmptySubsequences: false)
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && !$0.hasPrefix("#") && !$0.hasPrefix("//") }
            .count
        return .success(count)
    } catch {
        return .failure(NSError(domain: "MeaningfulLineCount",
                                code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "No such file: \(path)"]))
    }
}

struct Quaternion: Equatable, CustomStringConvertible {
    let a: Double, b: Double, c: Double, d: Double
    var coefficients: [Double] { [a, b, c, d] }
    var conjugate: Quaternion { Quaternion(a: a, b: -b, c: -c, d: -d) }
    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a; self.b = b; self.c = c; self.d = d
    }
    static func + (x: Quaternion, y: Quaternion) -> Quaternion {
        Quaternion(a: x.a + y.a, b: x.b + y.b, c: x.c + y.c, d: x.d + y.d)
    }
    static func * (x: Quaternion, y: Quaternion) -> Quaternion {
        let (a,b,c,d) = (x.a, x.b, x.c, x.d)
        let (e,f,g,h) = (y.a, y.b, y.c, y.d)
        return Quaternion(
            a: a*e - b*f - c*g - d*h,
            b: a*f + b*e + c*h - d*g,
            c: a*g - b*h + c*e + d*f,
            d: a*h + b*g - c*f + d*e
        )
    }
    var description: String {
        var s = ""
        func appendImag(_ coef: Double, _ u: Character) {
            guard coef != 0 else { return }
            let sign = coef < 0 ? "-" : (s.isEmpty ? "" : "+")
            let mag = abs(coef)
            s += sign + (mag == 1.0 ? String(u) : String(mag) + String(u))
        }
        if a != 0 || (b == 0 && c == 0 && d == 0) { s += String(a) }
        appendImag(b, "i"); appendImag(c, "j"); appendImag(d, "k")
        return s.isEmpty ? "0" : s
    }
    static let ZERO = Quaternion()
    static let I = Quaternion(b: 1)
    static let J = Quaternion(c: 1)
    static let K = Quaternion(d: 1)
}

indirect enum BinarySearchTree: CustomStringConvertible, Equatable {
    case empty
    case node(String, BinarySearchTree, BinarySearchTree)

    var size: Int {
        switch self {
        case .empty: return 0
        case let .node(_, l, r): return 1 + l.size + r.size
        }
    }

    func contains(_ s: String) -> Bool {
        switch self {
        case .empty: return false
        case let .node(v, l, r):
            if s == v { return true }
            if s < v  { return l.contains(s) }
            return r.contains(s)
        }
    }

    func insert(_ s: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(s, .empty, .empty)
        case let .node(v, l, r):
            if s == v { return self }
            if s < v  { return .node(v, l.insert(s), r) }
            return .node(v, l, r.insert(s))
        }
    }

    var description: String {
        switch self {
        case .empty: return "()"
        case let .node(v, l, r):
            let L = (l == .empty) ? "" : "\(l)"
            let R = (r == .empty) ? "" : "\(r)"
            return "(\(L)\(v)\(R))"
        }
    }
}
