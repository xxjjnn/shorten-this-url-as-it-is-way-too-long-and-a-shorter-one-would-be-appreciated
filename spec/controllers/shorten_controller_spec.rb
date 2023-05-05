require 'rails_helper'

describe ShortenController do
  describe "POST create" do
    it 'creates a redis key for a value' do
      redis_keys = $redis.keys('*')
      expect(redis_keys).to eq []

      post :create, params: { data: 'hello world' }

      redis_keys = $redis.keys('*')
      expect(redis_keys.length).to eq 1

      expect(JSON.parse(response.body)['data']).to eq "http://test.host/g/#{redis_keys.last}"
    end

    it 'uses a longer string if it does not find an available shorter string' do
      ShortenController::RANDOMSTRING.each{|x| $redis.set(x, 'nope', ex: 30)}
      redis_keys = $redis.keys('*')
      expect(redis_keys.length).to be > 1
      expect(redis_keys.map(&:length).uniq).to eq [1]

      post :create, params: { data: 'hello world' }

      redis_keys = $redis.keys('*')
      expect(redis_keys.map(&:length).uniq.sort).to eq [1,2]
      the_long_key = redis_keys.select{|x| x.length > 1}.first

      expect(JSON.parse(response.body)['data']).to eq "http://test.host/g/#{the_long_key}"
    end
  end

  describe "GET show" do
    it 'fetches the value' do
      $redis.set('hello', 'world', ex: 30)
      get :show, params: { key: 'hello' }

      expect(JSON.parse(response.body)['data']).to eq 'world'

      get :show, params: { key: 'blargle' }

      expect(JSON.parse(response.body)['data']).to be_nil
    end
  end
end
