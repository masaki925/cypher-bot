require 'net/https'

class RhymeGenerator4
  def initialize(user_text)
    @user_text = user_text
  end

  def get_rhyme
    uri = URI.parse("http://34.84.14.181/rap")
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 300
    http.read_timeout = 300

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data({verse: @user_text})

    res = http.request(req)

    res.body.force_encoding('utf-8')
  end
end
