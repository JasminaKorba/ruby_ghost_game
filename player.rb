class Player
    attr_reader :name

    def initialize(name)
        @name = name
    end

    def guess(fragment, remaining_players, alphabet)
        puts "The current fragment is: '#{fragment}'." 
        puts "Add your letter: "
        gets.chomp.downcase
    end

    def invalid_guess(letter)
        puts "'#{letter}' is not valid move."
        puts "Your guess must be a letter of the alphabet."
        puts "You must be able to form a word starting with the new fragment."
    end
end