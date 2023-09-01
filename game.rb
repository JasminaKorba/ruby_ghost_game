require "set"
require_relative "player"
require_relative "Ai"

 
class Game  

    ALPHABET = ("a".."z").to_a # //  ALPHABET = Set.new("a".."z")
    MAX_LOSS_COUNT = 5

    attr_reader :dictionary, :fragment, :losses, :players

    def initialize(players)
        words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = Set.new(words)
        @fragment = ""
        @losses = Hash.new { |losses, player| losses[player] = 0 }
        @players = players.map {|name, computer| computer == true ? Ai.new(name + "(comp)", dictionary) : Player.new(name)}
    end

    def run
        welcome
        play_round until game_over?
        puts "#{winner} wins!  ♕"
    end

    private

    def play_round
        @fragment = ""

        until round_over?
            take_turn
            next_player
        end

        update_standings
    end

    def game_over?
        remaining_players == 1
    end

    # helper methods

    def current_player
        players.first
    end

    def previous_player
        (players.count - 1).downto(0).each do |idx|
            player = players[idx]
            return player if losses[player] < MAX_LOSS_COUNT
        end
    end

    def next_player
        players.rotate!
        players.rotate! until losses[current_player] < MAX_LOSS_COUNT
    end

    def valid_guess?(letter)
        return false unless ALPHABET.include?(letter)

        potential_fragment = fragment + letter
        dictionary.any? { |word| word.start_with?(potential_fragment) }
    end

    def is_word?(fragment)
        dictionary.include?(fragment)
    end

    def round_over?
        is_word?(fragment)
    end

    def record(player)
        length = losses[player]
        return nil if length == 0 
        "GHOST".slice(0, length)
    end

    def remaining_players
        losses.count { |player, count| count < MAX_LOSS_COUNT }
    end

    def winner
        losses.each { |player, count| return player.name if count < MAX_LOSS_COUNT }
    end

    # UI methods
    def welcome
        system("clear")
        puts "Let the GAME begin!"
        display_standings
    end

    def take_turn
        system("clear")
        puts "It is a #{current_player.name}'s turn."
        letter = nil 
        sleep(2)
        
            until letter
            letter = current_player.guess(fragment, remaining_players, ALPHABET)
            
                unless valid_guess?(letter)
                    current_player.invalid_guess(letter)
                    letter = nil
                end
            end
            
        fragment << letter
        puts "#{current_player.name} added a letter '#{letter}'."
        puts "Current fragment is: '#{fragment}'."
        sleep(4)
    end

    def display_standings
        puts "Current standings:"
        players.each do |player|
            puts "#{player.name}: #{record(player)}"
        end

        sleep(3)
    end

    def update_standings
        puts "#{previous_player.name} spelled #{fragment}."
        puts "#{previous_player.name} gets a letter!"
        sleep(3)

            if losses[previous_player] == MAX_LOSS_COUNT - 1
                puts "☠  #{previous_player.name} ☠  has been eliminated! 👻 "
                sleep(3)
            end
        
        losses[previous_player] += 1
        display_standings
    end
    
 end

if $PROGRAM_NAME == __FILE__
    game = Game.new(
        "Gizmo" => false,
        "Felix" => true 
        )
    game.run
end
