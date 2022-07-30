from telethon import TelegramClient, sync, events
import sys
import os
import ujson

with open("login.json", "r") as f:
  _contas = f.read()
  contas = ujson.loads(_contas)
try:
  if sys.argv[1] == "/deleteall":
    for k in contas:
      for v in [".session", ".session-journal"]:
        os.system("rm %s%s" % (k["numero"], v))
except: pass

for i in contas:
  client = TelegramClient(i["numero"], i["api_id"], i["api_hash"])
  ##############
  client.connect()
  client.send_code_request(i["numero"])
  ##############
  codigo = input("Número > %s\nDigite o código >>> " %i["numero"])

  client.sign_in(i["numero"], codigo)
  client.disconnect()
  ##############
