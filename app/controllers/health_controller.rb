class HealthController < ApplicationController
  def marco
    require 'net/https'

    uri = URI.parse 'https://dj-marco.herokuapp.com/'

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true if uri.scheme == 'https'

    req = Net::HTTP::Get.new uri.request_uri
    http.request req

    render plain: 'OK'
  end
end
