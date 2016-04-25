require 'spec_helper'
require 'codebreaker_rack_app/rack_system'

# Module CodebreakerRackApp
module CodebreakerRackApp
  RSpec.describe RackSystem do
    let(:code) { { code: '1234' } }
    let(:hint) { { message: 'hint 1' } }
    let(:name) { { name: 'Vasya' } }
    context 'GET /' do
      it 'should allow accessing home page' do
        get '/'
        expect(last_response).to be_ok
      end

      it "should contain 'Welcome to Codebreaker'" do
        get '/'
        expect(last_response.body).to match(/Welcome to Codebreaker/)
      end
    end

    context 'POST /turn' do
      it 'should return answer separated % character' do
        post '/turn', code, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
        expect(last_response.body).to match(/^[ +-]{4}%(\d)%(continue|win|lose)$/)
      end
    end

    context 'POST /new_game' do
      it "shuold return 'OK'" do
        post '/new_game', nil, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
        expect(last_response.body).to eq 'OK'
      end
    end

    context 'POST /hint' do
      it 'sholud return digit from 1 to 6' do
        post '/hint', hint, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
        expect(last_response.body).to match(/[1-6]/)
      end
    end

    context 'POST /save_score' do
      it 'it should return json with name, turns, success' do
        post '/save_score', name, 'HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'
        expect(last_response.body).to match(/{"name":("[A-Za-z]+"),"success":"(continue|win|lose)","turns":(\d)}/)
      end
    end
  end
end
