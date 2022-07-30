 #!/usr/bin/env ruby
#########################################
def require_all(*gems) g = *gems; g.each { |gem| require gem }; end

require_all 'telegram/bot', 'http', 'json/ext', 'faraday', 'base64'

$TOKEN = File.read("token.txt").chomp

pattern_message = File.read("pattern_message.txt").chomp
blocklist_message = File.read("blocklist_message.txt").chomp
notadmin_message = File.read("notadmin_message.txt").chomp
captcha_message = JSON.load(File.read("captcha_message.json").chomp)
#########################################

require_relative 'captcha'
require_relative 'parses/foto'
require_relative 'parses/telefone'
require_relative 'parses/cpf'
require_relative 'parses/email'
#require_relative 'parses/cns'
require_relative 'parses/placa'

$Captcha = Captcha.new
$Foto = Foto.new
$Telefone_spc = Telefone_spc.new
$Telefone_teldb = Telefone_teldb.new
$Telefone_credilink = Telefone_credilink.new
$CPF_luarsearch = CPF_luarsearch.new
$CPF_datasus = CPF_datasus.new
$CPF_cnh = CPF_cnh.new
$Email_luarsearch = Email_luarsearch.new
#$CNS_datasus = CNS_datasus.new
$Placa_SIDS = Placa_SIDS.new

#require_relative 'consultas/response_test'
#########################################

basic_commands = ['/start',
                  '/menu']
admin_commands = ['/add', 
                  '/discount', 
                  '/remove', 
                  '/removecaptcha', 
                  '/addblocklist', 
                  '/removeblocklist', 
                  '/addadmin', 
                  '/removeadmin']
principal_commands = ['/foto',
                      '/telefone',
                      '/cpf',
                      '/email',
                      '/cns',
                      '/placa',
                      '/nome']

$path = "database/"
$luar_photo = Faraday::UploadIO.new("luar.jpg",  "image/jpeg")

$error = "❲ ❌ ❳"
$warning = "❲ ⚠️ ❳"
$blocked = "❲ 🚫 ❳"
$success = "❲ ✅ ❳"

$status = {200=> $success,
           500=> $warning,
           403=> $blocked,
           400=> $error,
           402=> $error}

$blocklist = JSON.load(File.read($path + 'blocklist.json').chomp)
$captcha_list = JSON.load(File.read($path + 'captcha_list.json').chomp)
$admin = JSON.load(File.read($path + 'admin.json').chomp)
$clientes = JSON.load(File.read($path + 'clientes.json').chomp)
#########################################

def update(function, id, value = 0)
  case function
    when "/add"
      if !($clientes.key? id.to_s)
        $clientes[id] = value
        infos = [$clientes, "clientes.json"]
        msg = "%s - ID adicionado com sucesso na lista de clientes!" %$success
      else
        return "%s - Este ID já está na lista de clientes!" %$error
      end
    when "/discount"
      if ($clientes.key? id.to_s)
        $clientes["%s" %id] = ($clientes["%s" %id] - value)
        infos = [$clientes, "clientes.json"]
        msg = "%s - O saldo com descontado com sucesso do ID!" %$success
      else
        return "%s - Este ID não está na lista de clientes!" %$error 
      end
    when "/remove"
      if ($clientes.key? id.to_s)
        $clientes.delete(id)
        infos = [$clientes, "cliente.json"]
        msg = "%s - ID removido com sucesso da lista de clientes!" %$success
      else
        return "%s - Este ID não está na lista de clientes!" %$error
      end
    when "/removecaptcha"
      if ($captcha_list.key? id.to_s)
        $clientes.delete(id)
        infos = [$clientes, "cliente.json"]
        msg = "%s - ID removido com sucesso da lista do captcha!" %$success
      else
        return "%s - Este ID não está no captcha!" %$error
      end
    when "/addblocklist"
      if !($blocklist.include? id.to_s)
        $blocklist.append(id)
        infos = [$blocklist, "blocklist.json"]
        msg = "%s - ID adicionado com sucesso na blocklist!" %$success
      else
        return "%s - Este ID já está na blocklist!" %$error
      end
    when "/removeblocklist"
      if ($blocklist.include? id.to_s)
        $blocklist.delete(id)
        infos = [$blocklist, "blocklist.json"]
        msg = "%s - ID removido com sucesso da blocklist!" %$success
      else
        return "%s - Este ID não está na blocklist!!" %$error
      end
    when "/addadmin"
      if !($admin.include? id.to_s)
        $admin.append(id)
        infos = [$admin, "admin.json"]
        msg = "%s - ID adicionado com sucesso da lista de Admins!" %$success
      else
        return "%s - Este ID já está na lista de Admin!" %$error
      end
    when "/removeadmin"
      if ($admin.include? id.to_s)
        $admin.delete(id)
        infos = [$admin, "admin.json"]
        msg = "%s - ID removido com sucesso da lista de Admins!" %$success
      else
        return "%s - Este ID não está na lista de Admin!" %$error
      end
  end

  File.open($path + infos[1], "w+") do |f|
    f.write(JSON.generate(infos[0]))
  end

  return msg
end

def send_message(bot, id, message_id, text)
  _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %i %i'%[ id, message_id ] )]
  keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)
  return bot.api.send_message(chat_id: id, reply_to_message_id: message_id, text: text, reply_markup: keyboard)
end

def token_generator()
  string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  _token = ""
  len = string.length

  for _ in 1..4
    for _ in 1..4
      index = (rand(len) - 1)
      _token += string[index]
    end

    _token += "-"
  end

  token = _token.chomp("-")
  return token
end

def consulta(key, msg)
  token = token_generator()

  message = "python3 scrapper.py %s %s %s" %[ token, key, msg ]
  system message

  _response = File.read("consultas/%s-consulta.json" % token).chomp
  response = JSON.load(_response)
  response["token"] = token

  return response
end

def delete_message(ids = [], chat_id = nil, bot = nil)
  ids.each{
    |gem| bot.api.deleteMessage(chat_id: chat_id, message_id: gem)
  }
end

def cap_gen(initial)
  if (initial)
    _choice = ["true", "false", "true", "false", "true", "false", "false", "true", "false", "false", "true", "false", "false"]
    choice = _choice[rand(_choice.length - 1)]; p choice
    if (choice == "false")
      return false
    end
  end

  numbers = "0123456789"
  len = (numbers.length - 1)

  list = []
  for i in 1..6
    number = ""
    for _ in 1..5
      number += numbers[rand(len)]
    end
    list.append(number)
  end

  index = rand(list.count - 1)
  codigo = list[index]

  _foto = $Captcha.main(codigo)[:msg]
  path = "media/%s-captcha.jpg" % token_generator
  foto = Base64.decode64(_foto)

  File.open(path, "wb+") do |file|
    file.write(foto)
  end

  return {"path"=>path, "answer"=>codigo, "values"=>list}
end

def cap_reload()
  File.open($path + "captcha_list.json", "w+") do |file|
    file.write(JSON.generate($captcha_list))
  end
end

def blocklist_reload()
  File.open($path + "blocklist.json", "w+") do |file|
    file.write(JSON.generate($blocklist))
  end
end

#########################################

def nome(bot, message, message_id, msg, keyboard) 
  url = "http://api.lkzn.tk/api/nome.php?token=c2f45952-a973-4c85-88a6-bc65bfda3c8c&nome=%s" %msg.gsub(" ", "%20").chomp("%20")
  _response = HTTP.get(url)
  response = JSON.load(_response.body.to_s)

  if !(response["status"] == 200)
    return bot.api.edit_message_text(chat_id: message.message.chat.id, message_id: message_id, text: "**%s - Nome não encontrado na base LuarSearch!**" %$error, reply_markup: keyboard, parse_mode: 'Markdown')
  end

  delete_message(ids = [message.message.message_id], chat_id = message.message.chat.id, bot = bot)
  
  token = token_generator()

  msg = ""

  for i in response["msg"]
    msg += "CPF - %s\n" %i["cpf"]
    msg += "Nome - %s\n" %i["nome"]
    msg += "Sexo - %s\n" %i["sexo"]
    msg += "Nascimento - %s\n\n" %i["nascimento"]
  end

  for _ in 1..2
    msg = msg.chomp
  end

  path = "consultas/%s-consulta.txt"%token

  File.open(path, "w+") { |file| file.write(msg) }
  document = Faraday::UploadIO.new(path, "text/plain")

  bot.api.send_document(
    chat_id: message.message.chat.id,
    message_id: message.message.message_id,
    reply_to_message_id: message_id,
    reply_markup: keyboard,
    document: document,
    caption: "%s - Nome encontrado!" %$success,
    parse_mode: "Markdown")
end

#########################################
Telegram::Bot::Client.run($TOKEN) do |bot|
  bot.listen do |message|
    begin
      case message
        when Telegram::Bot::Types::CallbackQuery
          info = message.data.gsub("  ", " ").split

          key = info[0]
          user_id = info[1]
          message_id = info[2]
          base = info[3]
        
          begin
            _msg = ""
            for i in info[4..]
              _msg += (i + " ")
            end
            msg = _msg.chomp
          rescue
          end

          if (message.from.id.to_s == user_id) || ($admin.include? user_id)
            case key
              when "/captcha"
                tentativas = $captcha_list[user_id]["tentativas"]
                _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ] )]
                keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)
                if base == $captcha_list[user_id]["answer"]
                  $captcha_list.delete(user_id)
                  delete_message(ids = [message.message.message_id], chat_id = message.message.chat.id, bot = bot)
                  cap_reload()
                  bot.api.send_message(
                    chat_id: message.message.chat.id,
                    reply_to_message_id: message_id.to_i,
                    text: '**%s - Captcha verificado com sucesso!**' %$success, 
                    reply_markup: keyboard,
                    parse_mode: 'Markdown'
                  )
                elsif tentativas >= 2
                  $blocklist.append(user_id)
                  $captcha_list.delete(user_id)
                  delete_message(ids = [message.message.message_id], chat_id = message.message.chat.id, bot = bot)
                  cap_reload();blocklist_reload()
                  bot.api.send_message(
                    chat_id: message.message.chat.id,
                    reply_to_message_id: message_id.to_i,
                    text: '**%s - Não foi possível verificar o captcha.**' %$error,
                    reply_markup: keyboard,
                    parse_mode: 'Markdown'
                  )
                else
                  captcha = cap_gen(false)
                  foto = Faraday::UploadIO.new(captcha["path"],  "image/jpeg")
                  cap_reload()
                  photo = Telegram::Bot::Types::InputMediaPhoto.new
                  photo.media = "attach://image"
                  photo.type = 'photo'
                  photo.caption = '**%s - Resolva o captcha!**' %$warning
                  photo.parse_mode = 'Markdown'

                  _markup = [
[
Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][0], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][0]]),
Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][1], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][1]])],
[
Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][2], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][2]]),
Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][3], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][3]])],
[
Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][4], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][4]]),
Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][5], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][5]])]
]
                  markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _markup)

                  $captcha_list[user_id]["tentativas"] = (tentativas + 1)
                  $captcha_list[user_id]["answer"] = captcha["answer"]

                  bot.api.edit_message_media(
                    chat_id: message.message.chat.id,
                    message_id: message.message.message_id,
                    reply_to_message_id: message_id.to_i,
                    reply_markup: markup,
                    media: photo.to_json,
                    image: foto)
                end
              when "/apagar"
                chat_id = message.message.chat.id
                ids = [message.message.message_id, message_id.to_i]
                delete_message(ids = ids, chat_id = message.message.chat.id, bot = bot)
              when "/foto"
                response = consulta(key, msg)
              
                _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ] )]
                keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)

                if !(response["status"] == 200)
                  status_code = $status[response["status"]]
                  msg = "**%s - %s**" %[status_code, response["message"]]
                  bot.api.edit_message_text(chat_id: message.message.chat.id, message_id: message.message.message_id, text: msg, reply_markup: keyboard, parse_mode: 'Markdown')
                else
                  msg = $Foto.main(response["message"]["dadosPessoais"])
                  foto = Faraday::UploadIO.new("media/%s-foto.jpg"%response["token"], "image/jpeg")

                  delete_message(ids = [message.message.message_id], chat_id = message.message.chat.id, bot = bot)
                  bot.api.send_photo(
                    chat_id: message.message.chat.id,
                    message_id: message.message.message_id,
                    reply_to_message_id: message_id.to_i,
                    reply_markup: keyboard,
                    photo: foto,
                    caption: msg,
                    parse_mode: "Markdown")
                end
              when "/telefone"
                response = consulta("%s_%s"%[key, base], msg)
                _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ] )]
                keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)
                if !(response["status"] == 200)
                  status_code = $status[response["status"]]
                  msg = "**%s - %s**" %[status_code, response["message"]]
                else
                  case base
                    when "spc"
                      msg = $Telefone_spc.main(response["message"])
                    when "teldb"
                      msg = $Telefone_teldb.main(response["message"])                    
                    when "credilink"
                      #msg = $Telefone_credilink.main(response["message"])
                      msg = "**%s - Consulta Offline!**" %$error
                  end
                end
                bot.api.edit_message_text(chat_id: message.message.chat.id, message_id: message.message.message_id, text: msg, reply_markup: keyboard, parse_mode: 'Markdown')
              when "/cpf"
                response = consulta("%s_%s"%[key, base], msg)
                _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ] )]
                keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)
                if !(response["status"] == 200)
                  status_code = $status[response["status"]]
                  msg = "**%s - %s**" %[status_code, response["message"]]
                else
                  case base
                   when "luarsearch"
                     msg = $CPF_luarsearch.main(response["message"])
                     #msg = "**%s - Consulta Offline!**" %$error
                   when "datasus"
                     msg = $CPF_datasus.main(response["message"])
                   when "cnh"
                     #msg = $CPF_cnh.main(response["message"])
                     msg = "**%s - Consulta Offline!**" %$error
                  end
                end
                bot.api.edit_message_text(chat_id: message.message.chat.id, message_id: message.message.message_id, text: msg, reply_markup: keyboard, parse_mode: 'Markdown')
              when "/email"
                response = consulta("%s_%s"%[key, base], msg)
                _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ] )]
                keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)
                if !(response["status"] == 200)
                  status_code = $status[response["status"]]
                  msg = "**%s - %s**" %[status_code, response["message"]]
                else
                  case base
                   when "luarsearch"
                     msg = $Email_luarsearch.main(response["message"])
                  end
                end
                bot.api.edit_message_text(chat_id: message.message.chat.id, message_id: message.message.message_id, text: msg, reply_markup: keyboard, parse_mode: 'Markdown')
              when "/cns"
                response = consulta("%s_%s"%[key, base], msg)
                _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ] )]
                keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)
                if !(response["status"] == 200)
                  status_code = $status[response["status"]]
                  msg = "**%s - %s**" %[status_code, response["message"]]
                else
                  case base
                   when "datasus"
                     msg = ($CPF_datasus.main(response["message"])).gsub("CPF encontrado!", "CNS encontrado!")
                  end
                end
                bot.api.edit_message_text(chat_id: message.message.chat.id, message_id: message.message.message_id, text: msg, reply_markup: keyboard, parse_mode: 'Markdown')
              when "/placa"
                response = consulta("%s_%s"%[key, base], msg)
                _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ] )]
                keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)
                if !(response["status"] == 200)
                  status_code = $status[response["status"]]
                  msg = "**%s - %s**" %[status_code, response["message"]]
                else
                  case base
                   when "seseg"
                     msg = "**%s - Consulta Offline!**" %$error
                   when "sids"
                     msg = $Placa_SIDS.main(response["message"])
                  end
                end
                bot.api.edit_message_text(chat_id: message.message.chat.id, message_id: message.message.message_id, text: msg, reply_markup: keyboard, parse_mode: 'Markdown')
              when "/nome"
                _keyboard = [ Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ] )]
                keyboard = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _keyboard)
                nome(bot, message, message_id.to_i, msg.gsub("  ", " "), keyboard)
            end
          end

        #bot.api.edit_message_text(chat_id: message.from.id, message_id: message.message.message_id, text: "What would you like Athena to do?")
        when Telegram::Bot::Types::Message
          _message = message.text.split
        
          key = _message[0]
          other_message = _message[1..]

          id = message.chat.id
          user_id = message.from.id
          message_id = message.message_id

          if ($blocklist.include? user_id.to_s) and (principal_commands.include? key)
            send_message(bot, id, message_id, blocklist_message)
          elsif ($captcha_list.key? id.to_s) and (principal_commands.include? key)
            cap_user_info = $captcha_list["%s" %id.to_s]
            case cap_user_info["chat_id"]
              when message.chat.id
                send_message(bot, id, message_id, captcha_message[0])
              else
                send_message(bot, id, message_id, captcha_message[1])
            end
          elsif (basic_commands.include? key)
            keyboard = [
              [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Consultas', url: 'https://github.com/LuarSearch/LuarSearch/blob/main/consultas/main.md'),
               Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Planos', url: 'https://github.com/LuarSearch/LuarSearch/blob/main/planos.md')],
              [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Grupo', url: 'https://t.me/luarsearch'),
               Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Criador', url: 'https://t.me/k_iny')]
              ]
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
            bot.api.send_photo(
              chat_id: id,
              photo: $luar_photo,
              reply_to_message_id: message_id,
              caption: "**Seja bem-vindo(a) ao menu, %s**\n❲ ID - ```%i``` | Chat ID - ```%i``` ❳" %[message.from.first_name, message.from.id, message.chat.id],
              reply_markup: markup,
              parse_mode: "Markdown")
          elsif (admin_commands.include? key)
            if ($admin.include? user_id.to_s)
              _id = _message[1]
              if ["/add", "/discount"].include? key
                value = _message[2].to_i
                retorno = update(key, _id, value = value)
              else
                retorno = update(key, _id)
              end
            else
              retorno = notadmin_message
            end
            send_message(bot, id, message_id, retorno)
          elsif ($clientes.key? id.to_s and $clientes[id.to_s] > 0) || ($admin.include? user_id.to_s)
            if (principal_commands.include? key)
              captcha = cap_gen(true)
              if ($admin.include? user_id.to_s) || !(captcha)
                if !($admin.include? user_id.to_s)
                  update("/discount", id.to_s, value = 1)
                end

                if other_message.length == 0
                 send_message(bot, id, message_id, $error + " - Alguns parâmetros estão faltando.")
                else
                  _msg = ""
                  for i in other_message
                    _msg += (i + " ")
                  end

                  msg = _msg.chomp

                  case key
                    when "/foto"
                      keyboard = [
                      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'SESEG', callback_data: '/foto %s %s seseg %s' %[ user_id, message_id, msg ]),
                      Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ])
                      ]

                      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
                      bot.api.send_message(chat_id: id, reply_to_message_id: message_id, text: "❲ 🔎 ❳ - Selecione o módulo abaixo para realizar a consulta", reply_markup: markup)
                    when "/telefone"
                      keyboard = [
                      [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'SPC', callback_data: '/telefone %s %s spc %s' %[ user_id, message_id, msg ]),
                       Telegram::Bot::Types::InlineKeyboardButton.new(text: 'TELDB', callback_data: '/telefone %s %s teldb %s' %[ user_id, message_id, msg ])],
                       Telegram::Bot::Types::InlineKeyboardButton.new(text: 'CREDILINK', callback_data: '/telefone %s %s credilink %s' %[ user_id, message_id, msg ]),
                       Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ])]

                      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
                      bot.api.send_message(chat_id: id, reply_to_message_id: message_id, text: "❲ 🔎 ❳ - Selecione o módulo abaixo para realizar a consulta", reply_markup: markup)
                    when "/cpf"
                      keyboard = [
                        [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'LuarSearch', callback_data: '/cpf %s %s luarsearch %s' %[ user_id, message_id, msg ]),
                        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'CNH', callback_data: '/cpf %s %s cnh %s' %[ user_id, message_id, msg ])],
                       [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Datasus', callback_data: '/cpf %s %s datasus %s' %[ user_id, message_id, msg ])],
                       Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ])]

                      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
                      bot.api.send_message(chat_id: id, reply_to_message_id: message_id, text: "❲ 🔎 ❳ - Selecione o módulo abaixo para realizar a consulta", reply_markup: markup)
                    when "/email"
                      keyboard = [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'LuarSearch', callback_data: '/email %s %s luarsearch %s' %[ user_id, message_id, msg ]),
                      Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ])]
                      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
                      bot.api.send_message(chat_id: id, reply_to_message_id: message_id, text: "❲ 🔎 ❳ - Selecione o módulo abaixo para realizar a consulta", reply_markup: markup)
                    when "/cns"
                      keyboard = [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Datasus', callback_data: '/cns %s %s datasus %s' %[ user_id, message_id, msg ]),
                      Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ])]
                      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
                      bot.api.send_message(chat_id: id, reply_to_message_id: message_id, text: "❲ 🔎 ❳ - Selecione o módulo abaixo para realizar a consulta", reply_markup: markup)
                    when "/placa"
                      keyboard = [
                      [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'SESEG', callback_data: '/placa %s %s seseg %s' %[ user_id, message_id, msg ]),
                       Telegram::Bot::Types::InlineKeyboardButton.new(text: 'SIDS', callback_data: '/placa %s %s sids %s' %[ user_id, message_id, msg ])],
                       Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ])]

                      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
                      bot.api.send_message(chat_id: id, reply_to_message_id: message_id, text: "❲ 🔎 ❳ - Selecione o módulo abaixo para realizar a consulta", reply_markup: markup)
                    when "/nome"
                      keyboard = [
                      Telegram::Bot::Types::InlineKeyboardButton.new(text: 'LuarSearch', callback_data: '/nome %s %s luarsearch %s' %[ user_id, message_id, msg ]),
                      Telegram::Bot::Types::InlineKeyboardButton.new(text: '❲ 🗑 ❳', callback_data: '/apagar %s %s'%[ user_id, message_id ])
                      ]
                      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: keyboard)
                      bot.api.send_message(chat_id: id, reply_to_message_id: message_id, text: "❲ 🔎 ❳ - Selecione o módulo abaixo para realizar a consulta", reply_markup: markup)
                  end
                end
              else
                foto = foto = Faraday::UploadIO.new(captcha["path"], "image/jpeg")

                _markup = [
  [
  Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][0], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][0]]),
  Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][1], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][1]])],
  [
  Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][2], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][2]]),
  Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][3], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][3]])],
  [
  Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][4], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][4]]),
  Telegram::Bot::Types::InlineKeyboardButton.new(text: captcha["values"][5], callback_data: '/captcha %s %s %s'%[user_id, message_id, captcha["values"][5]])]
  ]
                markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: _markup)
                $captcha_list["%s"%user_id.to_s] = {"chat_id"=>message.chat.id, "tentativas"=>0, "answer"=>captcha["answer"]}; p $captcha_list
                bot.api.send_photo(
                  chat_id: message.chat.id,
                  reply_to_message_id: message_id,
                  reply_markup: markup,
                  photo: foto,
                  caption: '**%s - Resolva o captcha!**'%$warning,
                  parse_mode: "Markdown")
                cap_reload()              
              end
            end
          elsif (not $clientes.key? id.to_s) and principal_commands.include? key
            send_message(bot, id, message_id, "%s - Você precisa adquirir um plano!" %$warning)
          elsif (admin_commands.include? key)
            p user_id.to_s
            if ($admin.include? user_id.to_s)
              _id = _message[1]
              if ["/add", "/discount"].include? key
                value = _message[2].to_i
                retorno = update(key, _id, value = value) 
              else
                retorno = update(key, _id)
              end
            else
              retorno = notadmin_message
            end

            send_message(bot, id, message_id, retorno)
          end
      end
    rescue Exception => e
      p e.to_s
    end
  end
end

 
