require 'spec_helper'
require 'codebreaker_rack_app/game'
require 'codebreaker_rack_app/game_enums'

# Module Codebreaker
module CodebreakerRackApp
  RSpec.describe Game do
    context '#start' do
      let(:game) { Game.new }

      it 'generates secret code' do
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end
      it 'saves 4 numbers secret code' do
        expect(game.instance_variable_get(:@secret_code).size).to eq 4
      end
      it 'saves secret code with numbers from 1 to 6' do
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
    end

    context '#game_over?' do
      let(:game) { Game.new }
      let(:correct_pass) { game.instance_variable_get(:@secret_code) }
      let(:wrong_pass) { '3333' }
      let(:hint) { 'hint 3' }
      let(:wrong_hint) { 'hint 22' }
      let(:hint_answer)  { 'You take all hints.' }

      before do
        game.start
        game.instance_variable_set(:@turns, 2)
        game.instance_variable_set(:@secret_code, '4444')
      end

      it 'should return WIN' do
        expect(game.game_over?(correct_pass).values[0]).to eq GameEnums::WIN
      end

      it 'should return CONTINUE' do
        expect(game.game_over?(wrong_pass).values[0]).to eq GameEnums::CONTINUE
      end

      it 'should return LOSE' do
        game.instance_variable_set(:@turns, 1)
        expect(game.game_over?(wrong_pass).values[0]).to eq GameEnums::LOSE
      end

      it 'should return hint 3' do
        expect(game.game_over?(hint).values[3]).to eq '4'
      end

      it 'should return You take all hints.' do
        game.instance_variable_set(:@hint_count, 0)
        expect(game.game_over?(hint).values[3]).to eq 'You take all hints.'
      end

      it 'should return nil on wrong hint' do
        expect(game.game_over?(wrong_hint)[3]).to be_nil
      end

      context '#match_code' do
        it 'should return ++++' do
          expect(game.send(:match_code, correct_pass)).to eq '++++'
        end

        it 'should return four spaces' do
          expect(game.send(:match_code, wrong_pass)).to eq '    '
        end

        it 'it should return ----' do
          game.instance_variable_set(:@secret_code, '1234')
          expect(game.send(:match_code, '4321')).to eq '----'
        end

        it 'should return +  +' do
          game.instance_variable_set(:@secret_code, '1001')
          expect(game.send(:match_code, '1221')).to eq '+  +'
        end

        it 'should return +--+' do
          game.instance_variable_set(:@secret_code, '1234')
          expect(game.send(:match_code, '1324')).to eq '+--+'
        end
      end

      context '#check_code_position' do
        it 'should return +' do
          expect(game.send(:check_code_position, 0, '4')).to eq '+'
        end

        it 'should return -' do
          game.instance_variable_set(:@secret_code, '1234')
          expect(game.send(:check_code_position, 1, '4')).to eq '-'
        end

        it 'should return space' do
          expect(game.send(:check_code_position, 1, 6)).to eq ' '
        end
      end

      context '#success_code' do
        it 'should return false' do
          expect(game.send(:success_code, '+-+-')).to eq false
        end

        it 'should return true' do
          expect(game.send(:success_code, '++++')).to eq true
        end
      end

      context '#hint_answer' do
        it "should return 'You take all hints.'" do
          game.instance_variable_set(:@hint_count, 0)
          expect(game.send(:hint_answer, 'hint 1')).to eq hint_answer
        end

        it 'should return 4' do
          expect(game.send(:hint_answer, 'hint 4')).to eq '4'
        end
      end

      context '#rand_one_to_six' do
        it 'should return number in range [1..6]' do
          expect(game.send(:rand_one_to_six)).to be_between(1, 6).inclusive
        end
      end
    end
  end
end
