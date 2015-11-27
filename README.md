# Relief

A collection of Stream oriented relief mechanisms. Supported mechanisms include

- Relief.Valve
- _TODO: build more_

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add relief to your list of dependencies in `mix.exs`:

        def deps do
          [{:relief, "~> 0.0.1"}]
        end

  2. Ensure relief is started before your application:

        def application do
          [applications: [:relief]]
        end

## Usage

### Relief Valves

A Relief.Valve stream will allow a configurable threshold of terms to pile up before pressure is releived by dropping terms.

```elixir
1..100
    |> Stream.map(fn (i) -> "message #{i}" end)
    |> Enum.into(Relief.Valve.stream(50))
    |> Stream.chunk(5) |> Stream.run
```
