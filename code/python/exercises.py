from __future__ import annotations

from dataclasses import dataclass
from typing import Callable, Iterable, Iterator, Optional, Sequence, Tuple, TypeVar

T = TypeVar("T")


def first_then_apply(
    strings: Sequence[str],
    predicate: Callable[[str], bool],
    function: Callable[[str], T],
) -> Optional[T]:
    for s in strings:
        if predicate(s):
            return function(s)
    return None


def powers_generator(*, base: int, limit: int) -> Iterator[int]:
    value = 1
    if limit < 1:
        return
        yield

    while value <= limit:
        yield value
        nxt = value * base
        if nxt == value:
            break
        value = nxt


def meaningful_line_count(filename: str, /) -> int:
    count = 0
    with open(filename, "r", encoding="utf-8") as fh:
        for line in fh:
            stripped_left = line.lstrip()
            if stripped_left == "" or stripped_left == "\n":
                continue
            if stripped_left.startswith("#"):
                continue
            if stripped_left.strip() == "":
                continue
            count += 1
    return count


_SENTINEL = object()


def say(word: object = _SENTINEL):
    words: list[str] = []
    if word is _SENTINEL:
        return ""

    words.append(str(word))

    def inner(next_word: object = _SENTINEL):
        if next_word is _SENTINEL:
            return " ".join(words)
        words.append(str(next_word))
        return inner

    return inner


def _is_zero(x: float) -> bool:
    return abs(x) < 1e-12


@dataclass(frozen=True, slots=True)
class Quaternion:
    a: float = 0.0
    b: float = 0.0
    c: float = 0.0
    d: float = 0.0

    @property
    def coefficients(self) -> Tuple[float, float, float, float]:
        return (self.a, self.b, self.c, self.d)

    @property
    def conjugate(self) -> "Quaternion":
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __add__(self, other: "Quaternion") -> "Quaternion":
        return Quaternion(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)

    def __mul__(self, other: "Quaternion") -> "Quaternion":
        a1, b1, c1, d1 = self.a, self.b, self.c, self.d
        a2, b2, c2, d2 = other.a, other.b, other.c, other.d
        return Quaternion(
            a1*a2 - b1*b2 - c1*c2 - d1*d2,
            a1*b2 + b1*a2 + c1*d2 - d1*c2,
            a1*c2 - b1*d2 + c1*a2 + d1*b2,
            a1*d2 + b1*c2 - c1*b2 + d1*a2,
        )

    def __str__(self) -> str:
        parts: list[str] = []

        if not _is_zero(self.a):
            a_val = 0.0 if _is_zero(self.a) else self.a
            parts.append(f"{a_val}")

        def add_term(coef: float, sym: str) -> None:
            if _is_zero(coef):
                return
            sign = "-" if coef < 0 else "+"
            absval = -coef if coef < 0 else coef
            if _is_zero(absval - 1.0):
                term = sym
            else:
                term = f"{absval}{sym}"
            if parts:
                parts.append(f"{sign}{term}")
            else:
                parts.append(term if coef > 0 else f"-{term}")

        add_term(self.b, "i")
        add_term(self.c, "j")
        add_term(self.d, "k")

        if not parts:
            return "0"
        return "".join(parts)
