def consulta(msg):
  dados = {}
  ################
  dados["nome"] = msg.split("NOME: ")[1].split("\n")[0]
  dados["cpfCnpj"] = msg.split("CPF / CNPJ: ")[1].split("\n")[0]
  dados["nascimento"] = msg.split("NASCIMENTO: ")[1].split("\n")[0]
  dados["mae"] = msg.split("MÃE: ")[1].split("\n")[0]
  dados["pai"] = msg.split("PAI: ")[1].split("\n")[0]
  ################
  return dados
