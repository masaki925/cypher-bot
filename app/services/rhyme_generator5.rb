require 'net/https'

class RhymeGenerator5
  def initialize(user_text)
    @user_text = user_text
  end

  def get_rhyme
    uri = URI.parse("https://dokaben-test01-irmo53kxyq-an.a.run.app/rap")
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 300
    http.read_timeout = 300

    http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data({verse: @user_text})

    res = http.request(req)
    res_json = JSON.parse(res.body.force_encoding('utf-8'))
    if res_json['code'] == 'INVALID_VERSE'
      return res_json['msg']
    end

    rd = res_json['receive_distance'].to_i
    gd = res_json['gen_distance'].to_i
    result = rd > gd ? "YOU WIN!" : (rd < gd ? "YOU LOSE!" : "DRAW!")

    "記録: #{rd}m\n\n----\n\n#{res_json['gen_text']}\n\n記録: #{gd}m\n\n#{result}"
  end
end
