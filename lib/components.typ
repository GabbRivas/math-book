#import "theme.typ": *
#import "template.typ": layout_state, column_positions, in_column, in_rail_at_block_start, label_text, numbered, statement_counter, exercise_counter, has_rail_titles

#let rail_label(body, fill: auto) = context {
  let layout = layout_state.get()
  if layout.rail > 0pt {
    in_rail_at_block_start(label_text(body, fill: fill))
  } else {
    block(below: 0.6em, sticky: true, label_text(body, fill: fill))
  }
}

#let aside(body) = context {
  let layout = layout_state.get()
  let styled_note = {
    set text(size: size.small, fill: palette.muted)
    set par(leading: 0.55em, spacing: 0.7em)
    body
  }
  if layout.note > 0pt { in_column("note", styled_note) }
  else if layout.rail > 0pt { in_column("rail", styled_note) }
  else { text(size: size.small, fill: palette.muted)[ (#body)] }
}

#let labelled(kind, counter_to_display, fill: auto, kind_in_text: true, body) = context {
  let layout = layout_state.get()
  let number = numbered(counter_to_display)
  if layout.rail == 0pt {
    block(below: 0.6em, sticky: true, label_text(fill: fill)[#kind #number])
    body
  } else if has_rail_titles(layout) {
    in_rail_at_block_start(label_text(fill: fill)[#kind #number])
    body
  } else {
    in_rail_at_block_start(label_text(fill: fill, number))
    if kind_in_text { label_text(fill: fill, kind); h(0.7em) }
    body
  }
}

#let wide(body) = context {
  let layout = layout_state.get()
  block(width: layout.main + layout.gap_note + layout.note, body)
}

#let todo(body) = text(fill: palette.faint, style: "italic")[[#body]]

#let key(body) = block(above: block_spacing, below: block_spacing, text(fill: palette.key, body))

#let caution(body) = block(above: block_spacing, below: block_spacing, {
  rail_label(fill: palette.caution)[Careful]
  body
})

#let question(body) = block(above: block_spacing, below: block_spacing, {
  rail_label[Question]
  text(font: fonts.display, style: "italic", weight: "regular", size: size.h3 * 0.9, body)
})

#let definition(term, body) = block(above: block_spacing, below: block_spacing, {
  statement_counter.step()
  labelled([Definition], statement_counter, {
    text(fill: palette.key, style: "italic", term)
    [ --- ]
    body
  })
})

#let claim(kind: "Proposition", name: none, body) = block(above: block_spacing, below: block_spacing, {
  statement_counter.step()
  labelled(kind, statement_counter, {
    if name != none { text(style: "italic")[#name. ] }
    body
  })
})

#let axiom(name: none, body) = claim(kind: "Axiom", name: name, body)
#let theorem(name: none, body) = claim(kind: "Theorem", name: name, body)
#let lemma(name: none, body) = claim(kind: "Lemma", name: name, body)

#let proof(sketch: false, body) = block(above: 0.8em, below: block_spacing, {
  rail_label(fill: palette.faint)[#if sketch [Sketch] else [Proof]]
  body
  h(1fr)
  text(font: fonts.math, fill: palette.faint, sym.square.filled)
})

#let translate(..rows) = {
  let all_rows = rows.pos()
  let column_count = all_rows.first().len()
  block(above: block_spacing, below: block_spacing, grid(
    columns: column_count, column-gutter: 1.2em, row-gutter: 0.7em, align: center + horizon,
    ..all_rows.enumerate().map(((row_index, row)) => row.map(cell =>
      if row_index == 0 { cell } else { text(fill: palette.muted, cell) })).flatten()))
}

#let step(label, body) = block(above: 1.4em, below: 1.1em, {
  rail_label(label)
  body
})

#let answer(body) = block(above: 1.7em, below: block_spacing, width: 100%, inset: (y: 0.6em),
  stroke: (top: 0.6pt + palette.key, bottom: 0.6pt + palette.key), {
    rail_label(fill: palette.key)[Answer]
    text(fill: palette.key, body)
  })

#let exercise(body) = block(above: 1.1em, below: 1.1em, {
  exercise_counter.step()
  labelled([Exercise], exercise_counter, fill: palette.muted, kind_in_text: false, body)
})

#let pause(statement, caption: none) = {
  let layout = format.layouts.default
  let positions = column_positions(layout)
  page(background: none, fill: inverse_palette.background, margin: 0pt, {
    place(dx: positions.main, dy: format.height * 0.4, block(width: layout.main + layout.gap_note + layout.note, {
      text(fill: inverse_palette.key, size: size.pause, statement)
      if caption != none {
        v(0.4in)
        text(font: fonts.label, size: size.small, fill: inverse_palette.muted,
             tracking: tracking_label, features: label_features, upper(caption))
      }
    }))
  })
}
