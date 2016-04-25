$LOAD_PATH << File.dirname(__FILE__)
require 'erb'
require 'json'
require 'game'
require 'game_enums'
require 'game_helper'
require 'score'

module CodebreakerRackApp
  # Class RackSystem
  class RackSystem
    include GameEnums
    include GameHelper
    @@score_table = []
    @@game ||= Game.new

    def self.call(env)
      new(env).response.finish
    end

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    def response
      return ajax_response(@request) if @request.xhr?
      case @request.path
      when '/' then
        @@game = Game.new
        p @@game
        Rack::Response.new(render('index.html.erb'))
      else
        Rack::Response.new('Not Found', 404)
      end
    end

    def render(template)
      path = File.expand_path("../../views/#{template}", __FILE__)
      ERB.new(File.read(path)).result(binding)
    end

    private

    def ajax_response(request)
      if request.post?
        case request.path
        when '/turn'
          turn_response(@request)
        when '/new_game'
          new_game_response
        when '/hint'
          hint_response(@request)
        when '/save_score'
          save_score_request(@request)
        end
      end
    end

    def add_score_to_table(name, success, turns)
      @@score_table << Score.new(name, success ? WIN : LOSE, turns)
      @@score_table = @@score_table.sort { |a, b| [b.success, a.turns] <=> [a.success, b.turns] }[0..9]
    end

    def turn_response(request)
      answer = try(@@game, request.params['code'])
      Rack::Response.new do |response|
        response.body << "#{answer[:res_of_match]}%"
        response.body << "#{answer[:turns]}%"
        response.body << answer[:res_success].to_s
      end
    end

    def new_game_response
      @@game = Game.new
      Rack::Response.new do |response|
        response.body << 'OK'
      end
    end

    def hint_response(request)
      answer = try(@@game, request.params['message'])
      Rack::Response.new do |response|
        response.body << answer[:hint]
      end
    end

    def save_score_request(request)
      name = request.params['name']
      turns = Game::TUNS_DEFAULT - @@game.turns
      success = @@game.success
      Rack::Response.new do |response|
        response.body << add_score_to_table(name, success, turns).to_json
      end
    end
  end
end
