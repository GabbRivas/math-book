#import "/lib/template.typ": book, chapter
#import "/lib/components.typ": *
#import "/lib/theme.typ": palette, fonts

#show: book.with(title: [Specimen], short_title: "Specimen", author: "Gab Pérez-Rivas")
#show: chapter.with(layout: "default")

= Statements

We have statements, concretely _declarative statements_, which we hold either to be true or to be false.#assume[Every statement is either true or false.] Some of them cannot be true at the same time.#aside[Here $:=$ means "let the letter stand for". It names; it does not claim.]

$ p &:= "Rosemary is a cat" \
  q &:= "Rosemary is a dog" $

Rosemary cannot be both. She might be neither.

#question[What does it mean for two statements to be incompatible?]

== The stroke

#definition[Stroke][$p | q$ is false exactly when $p$ and $q$ are both true, and true otherwise.]

#translate(
  ([Rosemary is a cat], [is incompatible with], [Rosemary does not meow]),
  ($b$, $|$, $not c$),
)

#claim[$not p equiv p | p$.]

#proof[If $p$ is true, $p | p$ says "not both", and both are true, so $p | p$ is false. If $p$ is false, $p | p$ is true.]

#claim(status: "deferred")[Every connective can be written with the stroke alone.]

#axiom(name: [Extensionality])[Two sets with the same elements are equal.]

#caution["Incompatible" is a way to remember the stroke, not its definition. Two unrelated statements can be "incompatible" in this sense.]

#key[A single sign, the stroke, is enough to say everything the others say.]

#figure(rect(width: 100%, height: 1.3in, stroke: 0.5pt + palette.hairline)[#align(center + horizon, text(fill: palette.muted)[truth table])], caption: [The truth table of $p | q$.]) <fig-table>

=== Exercises

#exercise[Write $p and q$ using only the stroke. (Compare @fig-table.)]
#exercise[Is $p | (q | q)$ the same as $p -> q$?]

#ledger()

#pause([$e^(i pi) + 1 = 0$], caption: [Euler])

#show: chapter.with(layout: "sparse")

= A sparse chapter

One centred column, no rail and no notes.#aside[A note falls back to parentheses.]

#claim(kind: "Theorem")[Labels fall back above the text when there is no rail.]
