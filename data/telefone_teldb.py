def consulta(msg):
  dados = {"dadosCadastrais" :{}, "endereco": {}}
  ################
  dados["dadosCadastrais"]["nome"] = msg.split("NOME: ")[1].split("\n")[0]
  dados["dadosCadastrais"]["cpfCnpj"] = msg.split("CPF / CNPJ: ")[1].split("\n")[0]
  dados["dadosCadastrais"]["operadora"] = msg.split("OPERADORA: ")[1].split("\n")[0]
  dados["endereco"]["uf"] = msg.split("UF: ")[1].split("\n")[0]
  dados["endereco"]["endereco"] = msg.split("ENDEREÇO: ")[1].split("\n")[0]
  dados["endereco"]["complemento"] = msg.split("COMPLEMENTO: ")[1].split("\n")[0]
  dados["endereco"]["numero"] = msg.split("NÚMERO: ")[1].split("\n")[0]
  dados["endereco"]["bairro"] = msg.split("BAIRRO: ")[1].split("\n")[0]
  dados["endereco"]["cep"] = msg.split("CEP: ")[1].split("\n")[0]
  ################
  return dados
