# wink

[![Package Version](https://img.shields.io/hexpm/v/wink)](https://hex.pm/packages/wink)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/wink/)

```sh
gleam add wink
```

```gleam
import gleam/io
import wink

pub fn main() {
    // draws a box with the default configuration
    "(>ᴗ•)"
    |> wink.draw
    |> io.println
}
```

will output:

```

 ╭───────╮ 
 │       │ 
 │ (>ᴗ•) │ 
 │       │ 
 ╰───────╯ 

```

```gleam
import gleam/io
import wink.{Border, Config, Custom}

pub fn main() {
    // or you can initialize a custom-styled box with specific config
    let box =
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
    |> box.draw
    |> io.println
}
```

Further documentation can be found at <https://hexdocs.pm/wink>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
