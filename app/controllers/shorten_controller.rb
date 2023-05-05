class ShortenController < ApplicationController
  RANDOMSTRING='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.split('').map(&:freeze).freeze
  EXPIRY=20

  def create
    key = set_redis_value_and_return_key(params['data'])
    head 503 unless key # laziness FTW!

    render json: {data: url_for(action: 'show', key: key)}
  end

  def show
    render json: {data: $redis.get(params['key'])}
  end

  private

  def random_of_length(x)
    x.times.map{ RANDOMSTRING.sample }.join
  end

  def set_redis_value_and_return_key(value)
    result = nil
    success = false
    (1..100).each do |target_length|
      # 1 attempt for single character key...
      # 2 attempts to use an unclaimed double character key...
      # ...
      # 100 attempts to use an unclaimed 100-character key. What are the odds there isn't one available!
      target_length.times do
        result = random_of_length(target_length)
        success = $redis.set(result, value, nx: true, ex: EXPIRY)
        break if success
      end
      break if success
    end
    success && result
  end
end
