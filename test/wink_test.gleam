import gleeunit
import birdie
import wink.{Border, Config, Custom}

pub fn main() {
  gleeunit.main()
}

pub fn draw_test() {
  "(>ᴗ•)"
  |> wink.draw
  |> birdie.snap("draw_test")
}

pub fn custom_config_test() {
  let wink =
    wink.init(
      Config(
        ..wink.default_config,
        style: Custom(Border(
          top_right: "◝",
          top_left: "◜",
          bottom_right: "◞",
          bottom_left: "◟",
          horizontal: "―",
          vertical: "⸾",
        )),
      ),
    )

  "(>ᴗ•)"
  |> wink.draw
  |> birdie.snap("custom_config_test")
}
