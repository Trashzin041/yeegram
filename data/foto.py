import base64

def consulta(token, msg):

  dados = {}

  #######################

  with open('media/%s-foto.jpg' % token, 'rb') as f:

    foto = base64.b64encode(f.read())

  #######################

  dados["dadosPessoais"] = {

    "nome": msg.split("NOME: ")[1].split("\n")[0],

    "nascimento": msg.split("NASCIMENTO: ")[1].split("\n")[0], 

    "pai": msg.split("PAI: ")[1].split("\n")[0],

    "mae": msg.split("MÃE: ")[1].split("\n")[0]

  }

  dados["foto"] = foto.decode("utf-8")

  #######################

  return dados

