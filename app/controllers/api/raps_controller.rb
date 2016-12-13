class Api::RapsController < ApplicationController
  def battle
    render json: {}, status: :ok
  end
end
