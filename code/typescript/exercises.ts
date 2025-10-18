import * as fs from "fs";

export function firstThenApply<A, B>(
  arr: readonly A[],
  predicate: (x: A) => boolean,
  fn: (x: A) => B
): B | undefined {
  for (const x of arr) {
    if (predicate(x)) return fn(x);
  }
  return undefined;
}

export function* powersGenerator(base: bigint): Generator<bigint, never, void> {
  let current: bigint = 1n;
  while (true) {
    yield current;
    current = current * base;
  }
}

export async function meaningfulLineCount(path: string): Promise<number> {
  const stream: fs.ReadStream = fs.createReadStream(path, { encoding: "utf8" });
  let buffer: string = "";
  let count: number = 0;

  return await new Promise<number>((resolve, reject) => {
    stream.on("data", (chunk: string | Buffer) => {
      buffer += typeof chunk === "string" ? chunk : chunk.toString("utf8");
      const lines: string[] = buffer.split(/\r?\n/);
      buffer = lines.pop() ?? "";
      for (const line of lines) {
        const trimmed: string = line.trim();
        if (trimmed !== "" && !trimmed.startsWith("#")) count += 1;
      }
    });

    stream.on("end", () => {
      const trimmed: string = buffer.trim();
      if (trimmed !== "" && !trimmed.startsWith("#")) count += 1;
      resolve(count);
    });

    stream.on("error", (err: Error) => reject(err));
  });
}

export type Sphere = Readonly<{ kind: "Sphere"; radius: number }>;
export type Box = Readonly<{ kind: "Box"; width: number; length: number; depth: number }>;
export type Shape = Sphere | Box;

export function volume(s: Shape): number {
  switch (s.kind) {
    case "Sphere":
      return (4 / 3) * Math.PI * s.radius * s.radius * s.radius;
    case "Box":
      return s.width * s.length * s.depth;
  }
}

export function surfaceArea(s: Shape): number {
  switch (s.kind) {
    case "Sphere":
      return 4 * Math.PI * s.radius * s.radius;
    case "Box": {
      const { width, length, depth } = s;
      return 2 * (width * length + width * depth + length * depth);
    }
  }
}

type Comparable = string | number | boolean;

export abstract class BinarySearchTree<T extends Comparable> {
  public abstract insert(value: T): BinarySearchTree<T>;
  public abstract contains(value: T): boolean;
  public abstract size(): number;
  public abstract inorder(): Generator<T, void, unknown>;
  public abstract toString(): string;
}

export class Empty<T extends Comparable> extends BinarySearchTree<T> {
  public insert(value: T): BinarySearchTree<T> {
    return new Node<T>(value, new Empty<T>(), new Empty<T>());
  }
  public contains(_value: T): boolean {
    return false;
  }
  public size(): number {
    return 0;
  }
  public *inorder(): Generator<T, void, unknown> {}
  public toString(): string {
    return "()";
  }
}

class Node<T extends Comparable> extends BinarySearchTree<T> {
  private readonly value: T;
  private readonly left: BinarySearchTree<T>;
  private readonly right: BinarySearchTree<T>;

  public constructor(value: T, left: BinarySearchTree<T>, right: BinarySearchTree<T>) {
    super();
    this.value = value;
    this.left = left;
    this.right = right;
  }

  private toComparable(v: T): number | string {
    return typeof v === "boolean" ? Number(v) : v;
  }

  public insert(value: T): BinarySearchTree<T> {
    if (value === this.value) return this; 
    if (this.toComparable(value) < this.toComparable(this.value)) {
      return new Node<T>(this.value, this.left.insert(value), this.right);
    } else {
      return new Node<T>(this.value, this.left, this.right.insert(value));
    }
  }

  public contains(value: T): boolean {
    if (value === this.value) return true;
    if (this.toComparable(value) < this.toComparable(this.value)) {
      return this.left.contains(value);
    }
    return this.right.contains(value);
  }

  public size(): number {
    return 1 + this.left.size() + this.right.size();
  }

  public *inorder(): Generator<T, void, unknown> {
    yield* this.left.inorder();
    yield this.value;
    yield* this.right.inorder();
  }

  public toString(): string {
    const leftStr: string = this.left.toString();
    const rightStr: string = this.right.toString();
    const leftPart: string = leftStr === "()" ? "" : leftStr;
    const rightPart: string = rightStr === "()" ? "" : rightStr;
    return `(${leftPart}${this.value}${rightPart})`;
  }
}
