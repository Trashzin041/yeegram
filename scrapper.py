import ujson
import time
import sys
import os
import random

from data import foto, telefone_spc, telefone_teldb, telefone_credilink, cpf_luarsearch, cpf_datasus, email_luarsearch, placa_sids

from telethon import TelegramClient, connection, sync, events
from telethon.tl.functions.channels import JoinChannelRequest

#//--------------------------------------//#

def login(contas, contas_usadas = []):
  while len(contas_usadas) < len(contas):
    conta = random.choice(contas)
    try:
      if conta not in contas_usadas:
        print(conta)
        client = TelegramClient(conta["numero"], conta["api_id"], conta["api_hash"])
        client.start()
        return [client,
               conta]
    except Exception:
      if conta not in contas_usadas:
        contas_usadas.append(conta)

  return False

def reload(client, contas, conta):
  client.disconnect()
  return login(contas, contas_usadas = [conta])

def join(client, group):
  try:
    client(JoinChannelRequest(group))
  except Exception: return False
  return True

def leave(client, entity):
  try:
    client.delete_dialog(entity)
    client.disconnect()
  except Exception: return False
  return True

#//--------------------------------------//#

def main(token, key, message, group = [], bot_id = None, button_value = False, replace_value = False, replace_key = False):
  viewed = False
  message_sended = False
  process = True
  joined = False
  group = random.choice(group)

  errors = {
    '/foto': "Foto não encontrada!",
    '/telefone_credilink': "Telefone não encontrado na base CREDILINK!",
    '/telefone_spc': "Telefone não encontrado na base SPC!",
    '/telefone_teldb': "Telefone não encontrado na base TELDB!",
    '/cpf_luarsearch': "CPF não encontrado na base LuarSearch!",
    '/cpf_datasus': "CPF não encontrado na base DataSUS!",
    '/email_luarsearch': "Email não encontrado na base LuarSearch",
    '/cns_datasus': "CNS não encontrado na base Datasus",
    '/placa_sids': "Placa não encontrada na base SIDS"
  }

  if replace_value:
    message = message.replace(key, key+replace_value)
  if replace_key:
    message = message.replace(key, replace_key)
  #print(message)

  with open("login.json", "r") as f:
    _contas = f.read()
    contas = ujson.loads(_contas)

  response_login = login(contas)
  if not response_login:
    return {'status': 500, 'message': 'Erro no servidor!'}

  client = response_login[0]
  conta = response_login[1]

  while process:
    try:
      _join = join(client, group)
      if not _join:
        return {'status': 403, 'message': 'Erro ao entrar no grupo, verifique se sua conta foi banida do mesmo. ( %s )' % group}

      entity = entity = client.get_entity(group)
      joined = True
    except Exception:
      response_login = reload(client, contas, conta)
      if not response_login:
        return {'status': 500, 'message': 'Erro no servidor!'}

      client = response_login[0]
      conta = response_login[1]

    if joined:
      try:
        client.send_message(entity = entity, message = message)
        message_sended = True
      except Exception:
        joined = False; message_sended = False

      if message_sended:
        try:
          while True:
            messages = client.get_messages(entity)[0]
            id = messages.from_id.user_id
            msg = messages.message
            if id == bot_id:
              if type(button_value) == int:
                messages.click(button_value);time.sleep(3)
                messages = client.get_messages(entity)[0]
                msg = messages.message
              break
          viewed = True
        except Exception:
          joined = False; message_sended = False

        if viewed:
          match key:
            case "/foto":
              client.download_media(
                messages.media,
                "media/%s-foto.jpg" % token
              )
            #case "/telefone":
            #  client.download_media(
            #    messages.media,
            #    "media/%s-consulta.txt" % token
            #  )
          try: messages.click(0);leave(client, entity)
          except Exception: pass
          process = False
  try:
    #print(msg)
    match key:
      case "/foto":
        response = foto.consulta(token, msg)
      case "/telefone_credilink":
        return {"status": 500, "message": "Consulta Offline!"}
        response = telefone_credilink.consulta(msg)
      case "/telefone_spc":
        response = telefone_spc.consulta(msg)
      case "/telefone_teldb":
        response = telefone_teldb.consulta(msg)
      case "/cpf_luarsearch":
        response = cpf_luarsearch.consulta(msg)
      case "/cpf_datasus":
        response = cpf_datasus.consulta(msg)
      case "/email_luarsearch":
        response = email_luarsearch.consulta(msg)
      case "/cns_datasus":
        response = cpf_datasus.consulta(msg)
      case "/placa_sids":
        response = placa_sids.consulta(msg)
    msg = {"status": 200}
    msg["message"] = response
  except Exception as e:
    print("Erro no scrapper: %s" %e)
    msg = {'status': 400, 'message': errors[key]}

  return msg

def __init__(args):
  token = args[1]
  key = args[2]
  _message = ''
  for i in args[2:]:
    _message += (i + ' ')
  message = _message[:-1]

  match key:
    case "/foto":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 0, replace_value = "@OnlyBuscasBot")
    case "/telefone_credilink":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 3, replace_value = "@OnlyBuscasBot", replace_key = "/telefone")
    case "/telefone_spc":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 0, replace_value = "@OnlyBuscasBot", replace_key = "/telefone")
    case "/telefone_teldb":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 1, replace_value = "@OnlyBuscasBot", replace_key = "/telefone")
    case "/cpf_luarsearch":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 0, replace_value = "@OnlyBuscasBot", replace_key = "/cpf")
    case "/cpf_datasus":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 2, replace_value = "@OnlyBuscasBot", replace_key = "/cpf")
    case "/email_luarsearch":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 0, replace_value = "@OnlyBuscasBot", replace_key = "/email")
    case "/cns_datasus":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 0, replace_value = "@OnlyBuscasBot", replace_key = "/cns")
    case "/placa_sids":
      _retorno = main(token, key, message, group = ["@tropadolux"], bot_id = 5225772947, button_value = 1, replace_value = "@OnlyBuscasBot", replace_key = "/placa")
    case _:
      _retorno = {'status': 402, 'message': 'Consulta Off-line!'}

  retorno = ujson.dumps(_retorno, indent = 4, sort_keys = True)

  with open("consultas/%s-consulta.json" % token, "w+") as f:
    return f.write(retorno)

#//--------------------------------------//#

if __name__ == '__main__':
  __init__(sys.argv)
 
