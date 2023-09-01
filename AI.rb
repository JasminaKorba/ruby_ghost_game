require "set"

class Ai
    attr_reader :name

    def initialize(name, dictionary)
        @name = name
        @dictionary = dictionary
    end

    def guess(fragment, remaining_players, alphabet)
        winning = alphabet.map {|char| char if winning_move(fragment, char, remaining_players)}.compact
        return winning.sample if !winning.empty?

        good_enough = alphabet.map {|char| char if !losing_move_char(fragment, char) && !start_with(fragment, char).empty?}.compact
        return good_enough.sample if !good_enough.empty?

        losing = alphabet.map {|char| char if losing_move_char(fragment, char)}.compact
        losing.sample
    end

    def start_with(fragment, char)
        @dictionary.select {|word| word.start_with?(fragment + char)}
    end

    def winning_move(fragment, char, remaining_players)
        return false if @dictionary.include?(fragment + char)
        
        words = start_with(fragment, char)
        return false if words.empty?

        words.all? do |word|
            ending = word[(fragment + char).length..-1]
            ending.length < remaining_players
        end
    end

    def losing_move_char(fragment, char)
        @dictionary.include?(fragment + char)
    end

end







