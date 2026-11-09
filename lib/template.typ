//
//Made by Gab Pérez-Rivas 18-Oct-26
//Page Setup (Size, Show, Set-rules) and general page customization for chapters and others.
//

#import "theme.typ": *

#let layout_state = state("layout", format.layouts.default)
#let statement_counter = counter("statement")
#let exercise_counter = counter("exercise")

#let column_positions(layout) = {
  let rail_x = layout.margin_left
  let main_x = rail_x + layout.rail + layout.gap_rail
  let note_x = main_x + layout.main + layout.gap_note
  (rail: rail_x, main: main_x, note: note_x)
}

#let page_margins(layout) = {
  let positions = column_positions(layout)
  (left: positions.main, right: format.width - positions.main - layout.main,
   top: format.margin_top, bottom: format.margin_bottom)
}

#let has_rail_titles(layout) = layout.rail >= minimum_rail_for_titles

#let label_text(body, fill: auto, weight: "regular") = text(
  font: fonts.label, size: size.small, weight: weight, tracking: tracking_label, features: label_features,
  fill: if fill == auto { palette.title } else { fill }, upper(body))

#let numbered(counter_to_display) = context {
  let chapter_number = counter(heading).get().first()
  [#chapter_number.#counter_to_display.display()]
}

#let page_background(short_title) = context {
  let layout = layout_state.get()
  let positions = column_positions(layout)
  let text_top = format.margin_top
  let text_height = format.height - format.margin_top - format.margin_bottom

  if layout.rail > 0pt {
    place(dx: positions.main - layout.gap_rail / 2, dy: text_top,
      line(length: text_height, angle: 90deg, stroke: 0.5pt + palette.hairline))
  }

  if draft {
    let zone_style = (fill: palette.key.transparentize(92%), stroke: 0.4pt + palette.key.transparentize(60%))
    for (zone_x, zone_width) in ((positions.rail, layout.rail), (positions.main, layout.main), (positions.note, layout.note)) {
      if zone_width > 0pt { place(dx: zone_x, dy: text_top, rect(width: zone_width, height: text_height, ..zone_style)) }
    }
  }

  let folio_y = format.height - format.margin_bottom + 0.3in
  set text(font: fonts.label, size: size.small - 1pt, fill: palette.faint, tracking: tracking_label, features: label_features)
  let folio_left = if layout.rail > 0pt { positions.rail } else { positions.main }
  let folio_right = if layout.note > 0pt { positions.note + layout.note } else { positions.main + layout.main }
  place(dx: folio_left, dy: folio_y, upper(short_title))
  place(dx: folio_right - 1in, dy: folio_y, box(width: 1in, align(right, counter(page).display())))
}

#let column_stack_state = state("column_stack", (note: (page: 0, bottom: 0pt), rail: (page: 0, bottom: 0pt)))
#let minimum_gap_between_side_items = 0.9em

#let place_in_column(column, body, vertical_offset) = context {
  let layout = layout_state.get()
  let positions = column_positions(layout)
  let column_width = if column == "note" { layout.note } else { layout.rail }
  let column_x = if column == "note" { positions.note } else { positions.rail }
  let here_position = here().position()
  let natural_y = here_position.y + vertical_offset.to-absolute()
  let previous = column_stack_state.get().at(column)
  let gap = minimum_gap_between_side_items.to-absolute()
  let item_y = if previous.page == here_position.page and previous.bottom + gap > natural_y {
    previous.bottom + gap
  } else { natural_y }
  let item = block(width: column_width, body)
  let item_height = measure(item).height
  place(dx: column_x - here_position.x, dy: item_y - here_position.y, item)
  column_stack_state.update(stack => {
    stack.insert(column, (page: here_position.page, bottom: item_y + item_height))
    stack
  })
}

#let in_column(column, body, vertical_offset: -0.78em) = box(width: 0pt,
  place_in_column(column, body, vertical_offset))

#let in_rail_at_block_start(body, vertical_offset: 0.2em) = place_in_column("rail", body, vertical_offset)

#let figure_rule(it) = context {
  let layout = layout_state.get()
  let positions = column_positions(layout)
  let caption = {
    set text(font: fonts.label, size: size.small - 0.5pt, fill: palette.muted)
    set par(leading: 0.5em, spacing: 0.6em)
    if it.caption != none {
      text(fill: palette.title, tracking: tracking_label, features: label_features)[#it.supplement #it.counter.display(it.numbering)]
      linebreak()
      it.caption.body
    }
  }
  block(above: block_spacing, below: block_spacing, width: 100%, {
    set align(left)
    if layout.note > 0pt and it.caption != none {
      place(dx: positions.note - positions.main, box(width: layout.note, caption))
    }
    it.body
    if layout.note == 0pt and it.caption != none { v(0.6em); caption }
  })
}

#let chapter_title_rule(it) = {
  pagebreak(weak: true)
  statement_counter.update(0)
  exercise_counter.update(0)
  context {
    let layout = layout_state.get()
    let positions = column_positions(layout)
    let chapter_number = if it.numbering != none { counter(heading).display("1") } else { none }
    let number_style(body) = text(font: fonts.display, weight: display_weight, tracking: display_tracking, size: size.h1,
                                  fill: palette.title, number-type: "lining", body)
    v(0.8in)
    if chapter_number != none and layout.rail > 0pt {
      place(dx: positions.rail - positions.main, box(width: layout.rail, number_style(chapter_number)))
    } else if chapter_number != none {
      block(below: 0.6em, label_text[Chapter #chapter_number])
    }
    block(width: layout.main + layout.gap_note + layout.note, below: 0.65in,
      text(font: fonts.display, weight: display_weight, tracking: display_tracking, size: size.h1, fill: palette.title,
           number-type: "lining", hyphenate: false, it.body))
  }
}

#let section_title_rule(it) = context {
  let layout = layout_state.get()
  let positions = column_positions(layout)
  let number = if it.numbering != none { counter(heading).display(it.numbering) } else { none }
  let title = text(font: fonts.display, weight: display_weight, tracking: display_tracking, size: size.h2, fill: palette.title,
                   number-type: "lining", hyphenate: false, it.body)
  let number_label = if number != none {
    text(font: fonts.label, size: size.small, fill: palette.faint, tracking: tracking_label, number)
  }

  if has_rail_titles(layout) {
    let heading_content = { set par(leading: 0.45em); number_label; linebreak(); title }
    let heading_height = measure(box(width: layout.rail, heading_content)).height
    block(above: 2.4em, below: 1.2em, sticky: true, height: heading_height,
      place(dx: positions.rail - positions.main, box(width: layout.rail, heading_content)))
  } else {
    block(above: 2.4em, below: 1.1em, sticky: true, {
      set par(leading: 0.45em)
      if number_label != none { number_label; linebreak() }
      title
    })
  }
}

#let subsection_title_rule(it) = block(above: 1.9em, below: 0.8em, sticky: true,
  label_text(it.body))

#let book(title: none, short_title: "", author: (), body) = {
  set document(title: title, author: author)
  set page(
    width: format.width, height: format.height,
    fill: palette.background,
    margin: page_margins(format.layouts.default),
    background: page_background(short_title),
    footer: none,
  )
  set text(font: fonts.ink, size: size.body, fill: palette.ink, lang: "en", number-type: "old-style")
  set par(justify: false, leading: leading, spacing: paragraph_spacing, first-line-indent: 0pt)

  show math.equation: set text(font: fonts.math, number-type: "lining")
  show math.equation.where(block: true): set align(left)
  show math.equation.where(block: true): pad.with(left: equation_indent)

  show link: set text(fill: palette.link)
  show ref: set text(fill: palette.link)

  set heading(numbering: "1.1")
  show heading.where(level: 1): chapter_title_rule
  show heading.where(level: 2): section_title_rule
  show heading.where(level: 3): subsection_title_rule

  show figure: figure_rule
  show table: set text(number-type: "lining")
  set table(stroke: none)
  set list(marker: text(fill: palette.faint)[–], indent: 0.2em)
  set enum(indent: 0.2em)

  body
}

#let chapter(layout: "default", ..overrides, body) = {
  let chosen_layout = format.layouts.at(layout) + overrides.named()
  set page(margin: page_margins(chosen_layout))
  layout_state.update(chosen_layout)
  body
}
