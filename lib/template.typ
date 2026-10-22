//
//Made by Gab Pérez-Rivas 18-Oct-26
//Page Setup (Size, Show, Set-rules) and general page customization for chapters and others.
//

#import "theme.typ": *

#let book(body) = {
  set page(width: 8.5in, height:8.5in, fill: palette_background, margin: (x:0.8in, y:0.9in))
  set text(font: font_serif, fill: palette_ink)
  set par(justify: false, leading: 0.75em, first-line-indent:1em)
  show math.equation: set text(font: font_math, fill: palette_ink)
  body
}
