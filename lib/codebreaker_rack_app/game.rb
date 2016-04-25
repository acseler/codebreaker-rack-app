$LOAD_PATH << File.dirname(__FILE__)
require 'game_enums'

module CodebreakerRackApp
  # Class Game
  class Game
    include GameEnums
    attr_reader :turns, :success

    TUNS_DEFAULT = 5

    def initialize
      @secret_code = ''
      @turns = TUNS_DEFAULT
      @hint_count = 1
      start
    end

    def start
      4.times { @secret_code << rand_one_to_six.to_s }
    end

    def game_over?(code)
      return hash_out(CONTINUE, nil, code, hint_answer(code)) if code =~ /hint/
      res_of_match = match_code(code)
      hash_out(if success_code(res_of_match)
                 WIN
               else
                 @turns == 0 ? LOSE : CONTINUE
               end, res_of_match, code)
    end

    private

    def rand_one_to_six
      generator ||= Random.new
      generator.rand(1..6)
    end

    def match_code(code)
      result = ''
      code.chars.each_with_index do |item, index|
        result << check_code_position(index, item)
      end
      @turns -= 1
      result
    end

    def check_code_position(index, item)
      res = ''
      @secret_code.chars.each_with_index do |val, ind|
        if val == item
          index == ind ? (return '+') : res = '-'
        else
          res == '-' ? next : res = ' '
        end
      end
      res
    end

    def success_code(code_equality)
      @success = code_equality == '++++'
    end

    def hash_out(res_success, res_of_match, code, hint = nil)
      {
        res_success: res_success,
        res_of_match: res_of_match,
        turns: @turns,
        hint: hint,
        hint_count: @hint_count,
        code: code,
        date: Time.now
      }
    end

    def get_hint(position)
      @hint_count -= 1
      @secret_code[position.to_i - 1]
    end

    def hint_answer(code)
      if @hint_count == 0
        'You take all hints.'
      else
        get_hint(code.gsub(/[^\d]/, ''))
      end
    end
  end
end
