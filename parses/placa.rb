class Placa_SIDS
  def main(param)
    msg = "**❲ ✅ ❳ - Placa encontrada!**\n\n"
    msg += "**Placa ** -``` %s```\n" %param["placa"]
    msg += "**Chassi ** -``` %s```\n" %param["chassi"]
    msg += "**Renavam ** -``` %s```\n" %param["renavam"]
    msg += "**UF ** -``` %s```\n" %param["uf"]
    msg += "**Município ** -``` %s```\n" %param["municipio"]
    msg += "**Ano do Modelo ** -``` %s```\n" %param["anoDoModelo"]
    msg += "**Ano de Exercício ** -``` %s```\n" %param["anoDeExercicio"]
    msg += "**Ano da Fabricação ** -``` %s```\n" %param["anoDaFabricacao"]
    msg += "**Cor ** -``` %s```\n" %param["cor"]
    msg += "**Categoria ** -``` %s```\n" %param["categoria"]
    msg += "**Marca e Modelo ** -``` %s```\n" %param["marcaEModelo"]
    msg += "**Localização ** -``` %s```\n" %param["localizacao"]
    msg += "**Apreensão ** -``` %s```\n" %param["apreensao"]
    msg += "**Roubo ** -``` %s```\n" %param["roubo"]
    msg += "**Sinalização de Roubo ** -``` %s```\n" %param["sinalizacaoDeRoubo"]
    msg += "**Último Pagamento do IPVA ** -``` %s```\n\n" %param["ultimoPagamentoDoIPVA"]
    msg += "**❲ Dados do Dono ❳**\n\n"
    msg += "**Nome ** -``` %s```\n" %param["dadosDoDono"]["nome"]
    msg += "**CPF/CNPJ ** -``` %s```\n" %param["dadosDoDono"]["cpfCnpj"]
    msg += "**Tipo do Dono ** -``` %s```\n\n" %param["dadosDoDono"]["tipoDoDono"]
    msg += "**❲ Dados do Arrendatário ❳**\n\n"
    msg += "**Nome ** -``` %s```\n" %param["dadosDoArrendatario"]["nome"]
    msg += "**CPF/CNPJ ** -``` %s```\n" %param["dadosDoArrendatario"]["cpfCnpj"]
    msg += "**Tipo do Arrendatario ** -``` %s```" %param["dadosDoArrendatario"]["tipoDoArrendatario"]
  end
end
