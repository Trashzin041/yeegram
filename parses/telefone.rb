class Telefone_spc
  def main(param)
    msg = "**❲ ✅ ❳ - Telefone encontrado!**\n\n"
    msg += "❲ Dados Cadastrais ❳\n\n"
    msg += "**Nome ** -``` %s```\n" % param["nome"]
    msg += "**CPF/CNPJ ** -``` %s```\n" % param["cpfCnpj"]
    msg += "**Nascimento ** -``` %s```\n" % param["nascimento"]
    msg += "**Mãe ** -``` %s```\n" % param["mae"]
    msg += "**Pai ** -``` %s```" % param["pai"]
    return msg
  end
end

class Telefone_teldb
  def main(param)
    msg = "**❲ ✅ ❳ - Telefone encontrado!**\n\n"
    msg += "❲ Dados Cadastrais ❳\n\n"
    msg += "**Nome ** -``` %s```\n" % param["dadosCadastrais"]["nome"]
    msg += "**CPF/CNPJ ** -``` %s```\n" % param["dadosCadastrais"]["cpfCnpj"]
    msg += "**Operadora ** -``` %s```\n\n" % param["dadosCadastrais"]["operadora"]
    msg += "**❲ Endereço ❳**\n\n"
    msg += "**UF ** -``` %s```\n" % param["endereco"]["uf"]
    msg += "**Endereço ** -``` %s```\n" % param["endereco"]["endereco"]
    msg += "**Complemento ** -``` %s```\n" % param["endereco"]["complemento"]
    msg += "**Número ** -``` %s```\n" % param["endereco"]["numero"]
    msg += "**Bairro ** -``` %s```\n" % param["endereco"]["bairro"]
    msg += "**CEP ** -``` %s```" % param["endereco"]["cep"]
  end
end

class Telefone_credilink
  def main(param)
    msg = "**❲ ✅ ❳ - Telefone encontrado!**\n\n"
    msg += "❲ Dados Cadastrais ❳\n\n"
    msg += "**Nome ** -``` %s```\n" % param["nome"]
    msg += "**CPF ** -``` %s```\n" % param["cpf"]
    msg += "**Status na Receita ** -``` %s```\n" % param["statusNaReceita"]
    msg += "**Renda Presumida ** -``` %s```\n" % param["rendaPresumida"]
    msg += "**Cidade de Nascimento ** -``` %s```\n" % param["cidadeDeNascimento"]
    msg += "**Estado de Nascimento ** -``` %s```\n" % param["estadoDeNascimento"]
    msg += "**Data de Nascimento ** -``` %s```\n" % param["dataDeNascimento"]
    msg += "\n**❲ Telefones ❳**\n"
    for i in param["telefones"]
      msg += "\n**Nome ** -``` %s```\n" %i["nome"]
      msg += "\n**Numero ** -``` %s```" %i["numero"]
      msg += "\n**UF ** -``` %s```" %i["uf"]
      msg += "\n**Cidade ** -``` %s```" %i["cidade"]
      msg += "\n**Endereço ** -``` %s```" %i["endereco"]
      msg += "\n**Bairro ** -``` %s```" %i["bairro"]
      msg += "\n**CEP ** -``` %s```\n" %i["cep"]
    end
    return msg.chomp
  end
end
