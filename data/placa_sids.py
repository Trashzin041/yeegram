def consulta(msg):
  dados = {}
  ################
  dados["placa"] = msg.split("PLACA: ")[1].split("\n")[0]
  dados["chassi"] = msg.split("CHASSI: ")[1].split("\n")[0]
  dados["renavam"] = msg.split("RENAVAM: ")[1].split("\n")[0]
  dados["uf"] = msg.split("UF: ")[1].split("\n")[0]
  dados["municipio"] = msg.split("MUNUCÍPIO: ")[1].split("\n")[0]
  dados["placa"] = msg.split("PLACA: ")[1].split("\n")[0]
  dados["anoDoModelo"] = msg.split("ANO DO MODELO: ")[1].split("\n")[0]
  dados["anoDeExercicio"] = msg.split("ANO DE EXERCICIO: ")[1].split("\n")[0]
  dados["anoDaFabricacao"] = msg.split("ANO DA FABRICAÇÃO: ")[1].split("\n")[0]
  dados["cor"] = msg.split("COR: ")[1].split("\n")[0]
  dados["categoria"] = msg.split("CATEGORIA: ")[1].split("\n")[0]
  dados["marcaEModelo"] = msg.split("MARCA e MODELO: ")[1].split("\n")[0]
  dados["localizacao"] = msg.split("LOCALIZAÇÃO: ")[1].split("\n")[0]
  dados["apreensao"] = msg.split("APRENSÃO: ")[1].split("\n")[0]
  dados["roubo"] = msg.split("ROUBO: ")[1].split("\n")[0]
  dados["sinalizacaoDeRoubo"] = msg.split("SINALIZAÇÃO DE ROUBO: ")[1].split("\n")[0]
  dados["ultimoPagamentoDoIPVA"] = msg.split("ÚLTIMO PAGAMENTO DO IPVA: ")[1].split("\n")[0]

  try:
    dadosDoDono = msg.split("「👤」DADOS DO DONO\n\n")[1].split("\n\n「🗣」DADOS DO ARRENDATÁRIO")[0]
    dados["dadosDoDono"] = {}

    dados["dadosDoDono"]["nome"] = dadosDoDono.split("NOME: ")[1].split("\n")[0]
    dados["dadosDoDono"]["cpfCnpj"] = dadosDoDono.split("CPF / CNPJ: ")[1].split("\n")[0]
    dados["dadosDoDono"]["tipoDoDono"] = dadosDoDono.split("TIPO DO DONO: ")[1].split("\n")[0]
  except:
    pass

  try:
    dadosDoArrendatario = msg.split("「🗣」DADOS DO ARRENDATÁRIO\n\n")[1]
    dados["dadosDoArrendatario"] = {}

    dados["dadosDoArrendatario"]["nome"] = dadosDoArrendatario.split("NOME: ")[1].split("\n")[0]
    dados["dadosDoArrendatario"]["cpfCnpj"] = dadosDoArrendatario.split("CPF / CNPJ: ")[1].split("\n")[0]
    dados["dadosDoArrendatario"]["tipoDoArrendatario"] = dadosDoArrendatario.split("TIPO DO ARRENDATÁRIO: ")[1].split("\n")[0]
  except:
    pass
  ################
  return dados
