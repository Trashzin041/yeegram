def consulta(msg):
  dados = {"dadosPessoais": {}, "registroGeral": {}, "parentes": {}, "endereco": {}}
  ################
  dados["dadosPessoais"]["nome"] = msg.split("NOME: ")[1].split("\n")[0]
  dados["dadosPessoais"]["nascimento"] = msg.split("NASCIMENTO: ")[1].split("\n")[0]
  dados["dadosPessoais"]["sexo"] = msg.split("SEXO: ")[1].split("\n")[0]
  dados["dadosPessoais"]["cpf"] = msg.split("CPF: ")[1].split("\n")[0]
  dados["dadosPessoais"]["cns"] = msg.split("CNS: ")[1].split("\n")[0]
  dados["registroGeral"]["rg"] = msg.split("RG: ")[1].split("\n")[0]
  dados["registroGeral"]["emissor"] = msg.split("EMISSOR: ")[1].split("\n")[0]
  dados["registroGeral"]["dataDeEmissao"] = msg.split("DATA de Emissão: ")[1].split("\n")[0]
  dados["registroGeral"]["ufDoRg"] = msg.split("UF do RG: ")[1].split("\n")[0]
  dados["parentes"]["mae"] = msg.split("MÃE: ")[1].split("\n")[0]
  dados["parentes"]["pai"] = msg.split("PAI: ")[1].split("\n")[0]
  dados["endereco"]["municipio"] = msg.split("MUNICÍPIO: ")[1].split("\n")[0]
  dados["endereco"]["bairro"] = msg.split("BAIRRO: ")[1].split("\n")[0]
  dados["endereco"]["logradouro"] = msg.split("LOGRADOURO: ")[1].split("\n")[0]
  dados["endereco"]["numero"] = msg.split("Nº: ")[1].split("\n")[0]
  dados["endereco"]["cep"] = msg.split("CEP: ")[1].split("\n")[0]
  dados["municipioDeNascimento"] = msg.split("MUNICÍPIO DE NASCIMENTO: ")[1].split("\n")[0]
  dados["telefone"] = msg.split("TELEFONE: ")[1].split("\n")[0]
  ################
  return dados
