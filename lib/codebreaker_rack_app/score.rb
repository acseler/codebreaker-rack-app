require 'json'

module CodebreakerRackApp
  # Class Score
  class Score
    attr_accessor :name, :success, :turns

    def initialize(name, success, turns)
      @name = name
      @success = success
      @turns = turns
    end

    def to_json(_options)
      { name: @name, success: @success, turns: @turns }.to_json
    end
  end
end
