class ShortenController < ApplicationController
  def create
    render json: {data: params['data'] + '123'}
  end
end
