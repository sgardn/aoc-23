defmodule Aoc23Test.P04 do
  use ExUnit.Case

  import Aoc23.P04
  alias Aoc23.P04.TicketTally

  # @tag :focus
  # @tag :pending
  describe "P04 part one (counting matches for tickets)" do
    test "test input" do
      assert 13 == run(test_file())
    end

    test "real input" do
      assert 21558 == run(input_file())
    end
  end

  describe "P04 part two (counting matches for tickets, and applying bonuses)" do
    test "test input" do
      assert 30 == run2(test_file())
    end

    test "real input" do
      assert 10425665 == run2(input_file())
    end
  end


  @tt_one %TicketTally{line_number: 1, line_score: 1, multiplier: 1}
  @tt_two %TicketTally{line_number: 2, line_score: 2, multiplier: 2}
  @tt_three %TicketTally{line_number: 3, line_score: 0, multiplier: 1}
  @tt_four %TicketTally{line_number: 4, line_score: 1, multiplier: 1}

  @tallies [@tt_one, @tt_two, @tt_three, @tt_four]

  describe "distribute_line_score" do
    test "when a ticket doesn't score, shouldn't update followers" do
      updated_tallies = distribute_line_score(@tt_three, @tallies)
      assert updated_tallies == @tallies
    end

    test "when a ticket scores, should increment N following multipliers based on its multiplier" do
      updated_tallies = distribute_line_score(@tt_one, @tallies)

      assert updated_tallies == [
        @tt_one,
        %TicketTally{@tt_two | multiplier: 3},
        @tt_three,
        @tt_four,
      ]
    end

    test "when a ticket scores AND has a multiplier, should add its multiplier to the following N multipliers" do
      updated_tallies = distribute_line_score(@tt_two, @tallies)

      assert updated_tallies == [
        @tt_one,
        @tt_two,
        %TicketTally{@tt_three | multiplier: 3},
        %TicketTally{@tt_four | multiplier: 3},
      ]
    end
  end
end
