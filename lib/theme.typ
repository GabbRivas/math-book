//
//Made by Gab Pérez-Rivas 18-Oct-26
//

#let palettes = (
  paper: (
    background: rgb("#F8F6F1"),
    surface:    rgb("#ECE8DF"),
    hairline:   rgb("#CCC5B7"),
    ink:        rgb("#1F1C18"),
    muted:      rgb("#5E5952"),
    faint:      rgb("#857F75"),
    key:        rgb("#7F611A"),
    title:      rgb("#3D6B5A"),
    link:       rgb("#3F5F8A"),
    caution:    rgb("#8E4A5C"),
    plot: ("#0072B2", "#D55E00", "#009E73", "#CC79A7", "#E69F00", "#56B4E9").map(rgb),
  ),
  night: (
    background: rgb("#0F0E0D"),
    surface:    rgb("#1A1816"),
    hairline:   rgb("#4A4540"),
    ink:        rgb("#E8E4DA"),
    muted:      rgb("#B5AFA2"),
    faint:      rgb("#8A8578"),
    key:        rgb("#D4AE5E"),
    title:      rgb("#7FA593"),
    link:       rgb("#8FA6CF"),
    caution:    rgb("#D08C9C"),
    plot: ("#56B4E9", "#F0E442", "#009E73", "#CC79A7", "#D55E00", "#0072B2").map(rgb),
  ),
)

#let fonts = (
  ink:     "STIX Two Text",
  math:    "STIX Two Math",
  display: "Bodoni Moda",
  label:   "STIX Two Text",
)

#let display_weight = "medium"
#let display_tracking = 0.02em
#let label_features = ("c2sc", "smcp")

#let size = (
  small: 9.5pt,
  body:  11.25pt,
  h3:    14pt,
  h2:    18pt,
  h1:    31pt,
  pause: 26pt,
)

#let leading = 0.68em
#let paragraph_spacing = 1.05em
#let tracking_label = 0.08em
#let equation_indent = 1.5em
#let block_spacing = 1.5em
#let minimum_rail_for_titles = 1.5in

#let formats = (
  portrait: (
    width: 8.5in, height: 11in,
    margin_top: 0.75in, margin_bottom: 0.85in,
    layouts: (
      default: (margin_left: 0.65in, rail: 0.8in, gap_rail: 0.2in, main: 4.35in, gap_note: 0.25in, note: 1.35in),
      sparse:  (margin_left: 2.05in, rail: 0in,   gap_rail: 0in,   main: 4.4in,  gap_note: 0in,    note: 0in),
      wide:    (margin_left: 0.65in, rail: 0.8in, gap_rail: 0.2in, main: 5.95in, gap_note: 0in,    note: 0in),
      full:    (margin_left: 0.75in, rail: 0in,   gap_rail: 0in,   main: 7.0in,  gap_note: 0in,    note: 0in),
    ),
  ),
  landscape: (
    width: 11in, height: 8.5in,
    margin_top: 0.75in, margin_bottom: 0.85in,
    layouts: (
      default: (margin_left: 0.9in, rail: 1.9in, gap_rail: 0.25in, main: 4.4in,  gap_note: 0.3in, note: 2.25in),
      sparse:  (margin_left: 3.3in, rail: 0in,   gap_rail: 0in,    main: 4.4in,  gap_note: 0in,   note: 0in),
      wide:    (margin_left: 0.9in, rail: 1.9in, gap_rail: 0.25in, main: 6.95in, gap_note: 0in,   note: 0in),
      full:    (margin_left: 0.9in, rail: 0in,   gap_rail: 0in,    main: 9.2in,  gap_note: 0in,   note: 0in),
    ),
  ),
  square: (
    width: 8.5in, height: 8.5in,
    margin_top: 0.85in, margin_bottom: 0.95in,
    layouts: (
      default: (margin_left: 0.75in, rail: 0in, gap_rail: 0in, main: 4.4in, gap_note: 0.3in, note: 2.3in),
      sparse:  (margin_left: 2.05in, rail: 0in, gap_rail: 0in, main: 4.4in, gap_note: 0in,   note: 0in),
      wide:    (margin_left: 0.75in, rail: 0in, gap_rail: 0in, main: 7.0in, gap_note: 0in,   note: 0in),
      full:    (margin_left: 0.75in, rail: 0in, gap_rail: 0in, main: 7.0in, gap_note: 0in,   note: 0in),
    ),
  ),
)

#let theme_name  = sys.inputs.at("theme",  default: "paper")
#let format_name = sys.inputs.at("format", default: "landscape")
#let draft       = sys.inputs.at("draft",  default: "false") == "true"

#let palette = palettes.at(theme_name)
#let inverse_palette = palettes.at(if theme_name == "paper" { "night" } else { "paper" })
#let format  = formats.at(format_name)
