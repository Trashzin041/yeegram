def consulta(msg):
  dados = {}
  ################
  dados["email"] = msg.split("EMAIL: ")[1].split("\n")[0]
  dados["cpf"] = msg.split("CPF: ")[1].split("\n")[0]
  ################
  return dados
