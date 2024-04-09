//// A simple Gleam box drawing library
////

import gleam/string
import gleam/list

/// Represents different styles for drawing boxes.
///
pub type Style {
  Single
  Round
  Solid
  Frame
  Cross
  Spring
  Thick
  Double
  SingleDouble
  DoubleSingle
  Classic
  Hidden
  Custom(Border)
}

/// Represents the borders of a box.
///
pub type Border {
  Border(
    top_right: String,
    top_left: String,
    bottom_right: String,
    bottom_left: String,
    horizontal: String,
    vertical: String,
  )
}

/// Represents different colors for drawing boxes.
///
pub type Color {
  Black
  Red
  Green
  Yellow
  Blue
  Magenta
  Cyan
  White
  Default
  ResetColor
}

/// Represents different decorations for text.
///
pub type Decoration {
  Bold
  Dim
  Italic
  Underline
  Reversed
  ResetDecoration
}

/// Represents spacing around the content of a box.
///
pub type Spacing {
  Spacing(top: Int, right: Int, bottom: Int, left: Int)
}

/// Represents the configuration for drawing a box.
///
pub type Config {
  Config(
    style: Style,
    box_color: Color,
    text_color: Color,
    padding: Spacing,
    margin: Spacing,
    decorations: List(Decoration),
  )
}

/// Represents a box instance.
///
pub type Box {
  Box(draw: fn(String) -> String)
}

/// Initializes a box with the given configuration.
///
pub fn init(cfg: Config) -> Box {
  Box(draw: fn(msg: String) -> String { draw_box(msg, cfg) })
}

fn draw_top(width: Int, config: Config) -> String {
  get_color(config.box_color)
  |> string.append(string.repeat("\n", config.margin.top))
  |> string.append(string.repeat(" ", config.margin.left))
  |> string.append(get_style(config.style).top_left)
  |> string.append(string.repeat(get_style(config.style).horizontal, width))
  |> string.append(get_style(config.style).top_right)
  |> string.append(string.repeat(" ", config.margin.right))
  |> string.append("\n")
}

fn draw_row(width: Int, config: Config) -> String {
  " "
  |> string.repeat(config.margin.left)
  |> string.append(get_style(config.style).vertical)
  |> string.append(string.repeat(" ", width))
  |> string.append(get_style(config.style).vertical)
  |> string.append(string.repeat(" ", config.margin.right))
  |> string.append("\n")
}

fn draw_middle(msg: String, width: Int, config: Config) -> String {
  draw_row(width, config)
  |> string.repeat(config.padding.top)
  |> string.append(string.repeat(" ", config.margin.left))
  |> string.append(get_style(config.style).vertical)
  |> string.append(string.repeat(" ", config.padding.left))
  |> string.append(get_color(config.text_color))
  |> string.append(
    apply_ansis(msg, [
      get_color(config.text_color),
      apply_decorations(config.decorations),
    ]),
  )
  |> string.append(get_decoration(ResetDecoration))
  |> string.append(get_color(config.box_color))
  |> string.append(string.repeat(" ", config.padding.right))
  |> string.append(get_style(config.style).vertical)
  |> string.append(string.repeat(" ", config.margin.right))
  |> string.append("\n")
}

fn draw_bottom(width: Int, config: Config) -> String {
  draw_row(width, config)
  |> string.repeat(config.padding.bottom)
  |> string.append(string.repeat(" ", config.margin.left))
  |> string.append(get_style(config.style).bottom_left)
  |> string.append(string.repeat(get_style(config.style).horizontal, width))
  |> string.append(get_style(config.style).bottom_right)
  |> string.append(string.repeat(" ", config.margin.right))
  |> string.append(string.repeat("\n", config.margin.bottom))
}

fn draw_box(msg: String, config: Config) -> String {
  let length = string.length(msg)
  let width = config.padding.left + length + config.padding.right

  string.concat([
    draw_top(width, config),
    draw_middle(msg, width, config),
    draw_bottom(width, config),
  ])
}

fn apply_ansis(text: String, ansis: List(String)) -> String {
  ansis
  |> string.concat()
  |> string.append(text)
}

fn get_style(style: Style) -> Border {
  case style {
    Single ->
      Border(
        top_right: "┐",
        top_left: "┌",
        bottom_right: "┘",
        bottom_left: "└",
        horizontal: "─",
        vertical: "│",
      )
    Frame ->
      Border(
        top_right: "◹",
        top_left: "◸",
        bottom_right: "◿",
        bottom_left: "◺",
        horizontal: "─",
        vertical: "│",
      )
    Cross ->
      Border(
        top_right: "┼",
        top_left: "┼",
        bottom_right: "┼",
        bottom_left: "┼",
        horizontal: "─",
        vertical: "│",
      )
    Spring ->
      Border(
        top_right: "╳",
        top_left: "╳",
        bottom_right: "╳",
        bottom_left: "╳",
        horizontal: "╳",
        vertical: "╳",
      )
    Thick ->
      Border(
        top_right: "█",
        top_left: "█",
        bottom_right: "█",
        bottom_left: "█",
        horizontal: "█",
        vertical: "█",
      )
    Double ->
      Border(
        top_right: "╗",
        top_left: "╔",
        bottom_right: "╝",
        bottom_left: "╚",
        horizontal: "═",
        vertical: "║",
      )
    Round ->
      Border(
        top_right: "╮",
        top_left: "╭",
        bottom_right: "╯",
        bottom_left: "╰",
        horizontal: "─",
        vertical: "│",
      )
    Solid ->
      Border(
        top_right: "┓",
        top_left: "┏",
        bottom_right: "┛",
        bottom_left: "┗",
        horizontal: "━",
        vertical: "┃",
      )
    SingleDouble ->
      Border(
        top_right: "╖",
        top_left: "╓",
        bottom_right: "╜",
        bottom_left: "╙",
        horizontal: "─",
        vertical: "║",
      )
    DoubleSingle ->
      Border(
        top_right: "╕",
        top_left: "╒",
        bottom_right: "╛",
        bottom_left: "╘",
        horizontal: "═",
        vertical: "│",
      )
    Classic ->
      Border(
        top_right: "+",
        top_left: "+",
        bottom_right: "+",
        bottom_left: "+",
        horizontal: "-",
        vertical: "|",
      )
    Hidden ->
      Border(
        top_right: "+",
        top_left: "+",
        bottom_right: "+",
        bottom_left: "+",
        horizontal: " ",
        vertical: " ",
      )
    Custom(border) -> border
  }
}

const black_code = "[30m"

const red_code = "[31m"

const green_code = "[32m"

const yellow_code = "[33m"

const blue_code = "[34m"

const magenta_code = "[35m"

const cyan_code = "[36m"

const white_code = "[37m"

const default_code = "[39m"

const reset_code = "[0m"

fn get_color(color: Color) -> String {
  "\u{001b}"
  <> case color {
    Black -> black_code
    Red -> red_code
    Green -> green_code
    Yellow -> yellow_code
    Blue -> blue_code
    Magenta -> magenta_code
    Cyan -> cyan_code
    White -> white_code
    Default -> default_code
    ResetColor -> reset_code
  }
}

const bold_code = "[1m"

const dim_code = "[1m"

const italic_code = "[3m"

const underline_code = "[4m"

const reversed_code = "[7m"

fn get_decoration(decoration: Decoration) -> String {
  "\u{001b}"
  <> case decoration {
    Bold -> bold_code
    Dim -> dim_code
    Italic -> italic_code
    Underline -> underline_code
    Reversed -> reversed_code
    ResetDecoration -> reset_code
  }
}

fn apply_decorations(decorations: List(Decoration)) -> String {
  decorations
  |> list.map(get_decoration)
  |> string.concat
}

/// Default configuration for drawing a box.
///
pub const default_config = Config(
  padding: Spacing(top: 1, right: 1, bottom: 1, left: 1),
  margin: Spacing(top: 1, right: 1, bottom: 1, left: 1),
  style: Round,
  box_color: Default,
  text_color: Default,
  decorations: [],
)

/// Draws a box with the default configuration.
///
pub fn draw(msg: String) -> String {
  draw_box(msg, default_config)
}
