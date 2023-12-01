# AOC 23

(Advent of Code)[https://adventofcode.com/] in `Elixir`.

## Console

To load the project and all modules for tinkering, run:

```
iex -S mix
```

## Tests

The tests are all located in `/tests/*/{module}_test.exs` - run all tests by executing the following:

```
mix test
```

Tests marked with `@tag :pending` will be ignored by default.

You can run a single one by using the explicit path:

```
mix test test/aoc23_test.exs
```

Testing single cases marked with `@tag :focus` is possible with `--only focus`

```
mix test --only focus
```
