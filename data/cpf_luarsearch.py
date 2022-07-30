def consulta(msg):
  dados = {"dadosCadastrais": {}, "registroGeral": {}, "enderecos": [], "beneficiosSociais": [], "profissoes": [], "veiculos": []}
  ################
  dados["dadosCadastrais"]["nome"] = msg.split("NOME: ")[1].split("\n")[0]
  dados["dadosCadastrais"]["cpf"] = msg.split("CPF: ")[1].split("\n")[0]
  dados["dadosCadastrais"]["nascimento"] = msg.split("NASCIMENTO: ")[1].split("\n")[0]
  dados["dadosCadastrais"]["sexo"] = msg.split("SEXO: ")[1].split("\n")[0]
  dados["dadosCadastrais"]["pai"] = msg.split("PAI: ")[1].split("\n")[0]
  dados["dadosCadastrais"]["mae"] = msg.split("MÃE: ")[1].split("\n")[0]

  registroGeral = msg.split("REGISTRO GERAL\n\n")[1].split("\n「🏡")[0]

  dados["registroGeral"]["numero"] = registroGeral.split("NÚMERO: ")[1].split("\n")[0]
  dados["registroGeral"]["orgaoEmissor"] = registroGeral.split("ORGÃO EMISSOR: ")[1].split("\n")[0]
  dados["registroGeral"]["uf"] = registroGeral.split("UF: ")[1].split("\n")[0]

  enderecos = msg.split("「🏡」ENDEREÇOS\n")[1].split("\n「😀」BENEFÍCIOS SOCIAIS")[0].split("\n\n")
  try:
    for i in enderecos:
      _enderecos = {}
      _enderecos["uf"] = i.split("UF: ")[1].split("\n")[0]
      _enderecos["cidade"] = i.split("CIDADE: ")[1].split("\n")[0]
      _enderecos["logradouro"] = i.split("LOGRADOURO: ")[1].split("\n")[0]
      _enderecos["complemento"] = i.split("COMPLEMENTO: ")[1].split("\n")[0]
      _enderecos["bairro"] = i.split("BAIRRO: ")[1].split("\n")[0]
      _enderecos["numero"] = i.split("NÚMERO: ")[1].split("\n")[0]
      _enderecos["cep"] = i.split("CEP: ")[1].split("\n")[0]
      dados["enderecos"].append(_enderecos)
  except:
    dados["enderecos"] = "Nada encontrado!"

  beneficiosSociais = msg.split("「😀」BENEFÍCIOS SOCIAIS\n")[1].split("\n「💰」PROFISSÕES")[0].split("\n\n")
  try:
    for i in beneficiosSociais:
      _beneficiosSociais = {}
      _beneficiosSociais["entidade"] = i.split("ENTIDADE: ")[1].split("\n")[0]
      _beneficiosSociais["especie"] = i.split("ESPECIE: ")[1].split("\n")[0]
      _beneficiosSociais["valor"] = i.split("VALOR: ")[1].split("\n")[0]
      dados["beneficiosSociais"].append(_beneficiosSociais)
  except:
    dados["beneficiosSociais"] = "Nada encontrado!"

  profissoes = msg.split("「💰」PROFISSÕES\n")[1].split("\n「🚗」VEÍCULOS")[0].split("\n\n")
  try:
    for i in profissoes:
      _profissoes = {}
      _profissoes["cnpj"] = i.split("CNPJ: ")[1].split("\n")[0]
      _profissoes["profissao"] = i.split("PROFISSÃO: ")[1].split("\n")[0]
      _profissoes["salario"] = i.split("SALÁRIO: ")[1].split("\n")[0]
      _profissoes["entrada"] = i.split("ENTRADA: ")[1].split("\n")[0]
      dados["profissoes"].append(_profissoes)
  except:
    dados["profissoes"] = "Nada encontrado!"

  veiculos = msg.split("「🚗」VEÍCULOS\n")[1].split("\n「📱」TELEFONES")[0].split("\n\n")
  try:
    for i in veiculos:
      _veiculos = {}
      _veiculos["chassi"] = i.split("CHASSI: ")[1].split("\n")[0]
      _veiculos["renavam"] = i.split("RENAVAM: ")[1].split("\n")[0]
      _veiculos["placa"] = i.split("PLACA: ")[1].split("\n")[0]
      _veiculos["marca"] = i.split("MARCA: ")[1].split("\n")[0]
      _veiculos["anoDeFabricacao"] = i.split("ANO DE FABRICAÇÃO: ")[1].split("\n")[0]
      _veiculos["anoDoModelo"] = i.split("ANO DO MODELO: ")[1].split("\n")[0]
      dados["veiculos"].append(_veiculos)
  except:
    dados["veiculos"] = "Nada encontrado!"

  dados["telefones"] = msg.split("「📱」TELEFONES\n\n")[1].split("\n\n「✉️」E-MAILS")[0].replace("  ", "").replace("\n\n", "\n").split("\n")
  dados["emails"] = msg.split("「✉️」E-MAILS\n \n")[1].split("\n\n• USUÁRIO:")[0].replace("  ", "").replace("\n\n", "\n").split("\n")
  ################
  return dados
