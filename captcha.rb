require 'http'

URLs = ["https://fakecaptcha.com",
        "https://fakecaptcha.com/generate.php",
        "https://fakecaptcha.com/result.php"]

class Captcha
  def spliter(msg, start, _end)
    return msg.split(start)[1].split(_end)[0]
  end

  def main(codigo)
    begin
      HTTP.get(URLs[0])
    ###################################
      _words = HTTP.post(URLs[1], :form => { :words=> codigo, :force=> '0', :color => 'red' })
      words = spliter(_words.body.to_s, '<input type="hidden" name="words" value="', '"')
    ###################################
      _foto = HTTP.post(URLs[2], :form => { :words=> words })
      foto = spliter(_foto.body.to_s, 'src="data:image/jpg;base64,', '"')
    ###################################
    rescue Exception => e
      return { :status=> 400, :msg=> "Error generating captcha!" }
    end

    return { :status=> 200, :msg=> foto }
  end
end
