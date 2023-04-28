# Marmoset

Marmosets are very cute little monkeys, certainly in comparison with our cousin the Gorrilla.

This library is a very cute little implementation of [Facebook's Time Series Database](https://web.archive.org/web/20210811185230/https://www.vldb.org/pvldb/vol8/p1816-teller.pdf).

The purpose of this library is to compactly store Orchestrator-local time series data on disk. The idea
is to use Gorrilla's compaction to deflate data, and then have some sort of data storage scheme around it.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `marmoset` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:marmoset, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/marmoset>.
