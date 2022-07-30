class CNS_datasus

  def main(param)

    msg = "**❲ ✅ ❳ - CNS encontrado!**\n\n"

    msg += "**❲ Dados Cadastrais ❳**\n\n"

    msg += "**Nome ** -``` %s```\n" %param["dadosPessoais"]["nome"]

    msg += "**Nascimento ** -``` %s```\n" %param["dadosPessoais"]["nascimento"]

    msg += "**Sexo ** -``` %s```\n" %param["dadosPessoais"]["sexo"]

    msg += "**CPF ** -``` %s```\n" %param["dadosPessoais"]["cpf"]

    msg += "**CNS ** -``` %s```\n\n" %param["dadosPessoais"]["cns"]

    msg += "**❲ Parentes ❳**\n\n"

    msg += "**Pai ** -``` %s```\n" %param["parentes"]["pai"]

    msg += "**Mãe ** -``` %s```\n\n" %param["parentes"]["mae"]

    return msg

  end

end

