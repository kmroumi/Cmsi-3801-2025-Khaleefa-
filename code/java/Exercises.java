import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.function.Predicate;

public class Exercises {

    public static Optional<String> firstThenLowerCase(List<String> xs, Predicate<String> p) {
        for (String s : xs) {
            if (p.test(s)) return Optional.of(s.toLowerCase());
        }
        return Optional.empty();
    }

    public static Say say() { return new Say(""); }
    public static Say say(String first) { return new Say(first); }

    public static final class Say {
        private final String built;
        private Say(String built) { this.built = built; }
        public Say and(String next) { return new Say(built + " " + next); }
        public String phrase() { return built; }
    }

    public static int meaningfulLineCount(String path) throws IOException {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            int count = 0;
            String line;
            while ((line = br.readLine()) != null) {
                String t = line.trim();
                if (t.isEmpty()) continue;
                if (t.startsWith("#")) continue;
                if (t.startsWith("//")) continue;
                count++;
            }
            return count;
        } catch (FileNotFoundException e) {
            FileNotFoundException x = new FileNotFoundException("No such file: " + path);
            x.initCause(e);
            throw x;
        }
    }
}

final class Quaternion {
    private final double a, b, c, d; 

    static final Quaternion ZERO = new Quaternion(0,0,0,0);
    static final Quaternion I    = new Quaternion(0,1,0,0);
    static final Quaternion J    = new Quaternion(0,0,1,0);
    static final Quaternion K    = new Quaternion(0,0,0,1);

    Quaternion(double a, double b, double c, double d) {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d))
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        this.a = a; this.b = b; this.c = c; this.d = d;
    }

    double a() { return a; }
    double b() { return b; }
    double c() { return c; }
    double d() { return d; }

    List<Double> coefficients() { return List.of(a, b, c, d); }

    Quaternion plus(Quaternion q) {
        return new Quaternion(a + q.a, b + q.b, c + q.c, d + q.d);
    }

    Quaternion times(Quaternion q) {
        double e = q.a, f = q.b, g = q.c, h = q.d;
        double ra = a*e - b*f - c*g - d*h;
        double rb = a*f + b*e + c*h - d*g;
        double rc = a*g - b*h + c*e + d*f;
        double rd = a*h + b*g - c*f + d*e;
        return new Quaternion(ra, rb, rc, rd);
    }

    Quaternion conjugate() { return new Quaternion(a, -b, -c, -d); }

    @Override
    public boolean equals(Object o) {
        if (!(o instanceof Quaternion q)) return false;
        return Double.compare(a, q.a) == 0 &&
               Double.compare(b, q.b) == 0 &&
               Double.compare(c, q.c) == 0 &&
               Double.compare(d, q.d) == 0;
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(a,b,c,d);
    }

    @Override
    public String toString() {
        if (a == 0.0 && b == 0.0 && c == 0.0 && d == 0.0) return "0";

        StringBuilder s = new StringBuilder();

        if (a != 0.0) s.append(Double.toString(a));

        appendImag(s, c, 'j');
        appendImag(s, b, 'i');
        appendImag(s, d, 'k');

        return s.length() == 0 ? "0" : s.toString();
    }

    private static void appendImag(StringBuilder s, double coef, char unit) {
        if (coef == 0.0) return;
        String sign = coef < 0 ? "-" : (s.length() == 0 ? "" : "+");
        double mag = Math.abs(coef);
        s.append(sign);
        if (mag == 1.0) s.append(unit);
        else s.append(Double.toString(mag)).append(unit);
    }
}

interface BinarySearchTree {
    int size();
    boolean contains(String s);
    BinarySearchTree insert(String s);
}

final class Empty implements BinarySearchTree {
    @Override public int size() { return 0; }
    @Override public boolean contains(String s) { return false; }
    @Override public BinarySearchTree insert(String s) { return new Node(s, this, this); }
    @Override public String toString() { return "()"; }
}

final class Node implements BinarySearchTree {
    private final String value;
    private final BinarySearchTree left, right;

    Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value; this.left = left; this.right = right;
    }

    @Override public int size() { return 1 + left.size() + right.size(); }

    @Override public boolean contains(String s) {
        int cmp = s.compareTo(value);
        if (cmp == 0) return true;
        return (cmp < 0) ? left.contains(s) : right.contains(s);
    }

    @Override public BinarySearchTree insert(String s) {
        int cmp = s.compareTo(value);
        if (cmp == 0) return this; 
        if (cmp < 0)  return new Node(value, left.insert(s), right);
        else          return new Node(value, left, right.insert(s));
    }

    @Override public String toString() {
        String l = (left instanceof Empty) ? "" : left.toString();
        String r = (right instanceof Empty) ? "" : right.toString();
        return "(" + l + value + r + ")";
    }
}
