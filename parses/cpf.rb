class CPF_luarsearch
  def main(param)
    msg = "**❲ ✅ ❳ - CPF encontrado!**\n\n"
    msg += "**❲ Dados Cadastrais ❳**\n\n"
    msg += "**Nome ** -``` %s```\n" %param["dadosCadastrais"]["nome"]
    msg += "**CPF ** -``` %s```\n" %param["dadosCadastrais"]["cpf"]
    msg += "**Nascimento ** -``` %s```\n" %param["dadosCadastrais"]["nascimento"]
    msg += "**Sexo ** -``` %s```\n\n" %param["dadosCadastrais"]["sexo"]
    msg += "**Pai ** -``` %s```\n" %param["dadosCadastrais"]["pai"]
    msg += "**Mãe ** -``` %s```\n\n" %param["dadosCadastrais"]["mae"]
    msg += "**❲ Registro Geral ❳**\n\n"
    msg += "**Número ** -``` %s```\n" %param["registroGeral"]["numero"]
    msg += "**Órgão Emissor ** -``` %s```\n" %param["registroGeral"]["orgaoEmissor"]
    msg += "**UF ** -``` %s```\n\n" %param["registroGeral"]["uf"]
    msg += "**❲ Endereços ❳**\n\n"

    enderecos = param["enderecos"]
    if enderecos.class == Array
      for i in enderecos
        msg += "**UF ** -``` %s```\n" %i["uf"]
        msg += "**Cidade ** -``` %s```\n" %i["cidade"]
        msg += "**Logradouro ** -``` %s```\n" %i["logradouro"]
        msg += "**Complemento ** -``` %s```\n" %i["complemento"]
        msg += "**Bairro ** -``` %s```\n" %i["bairro"]
        msg += "**Número ** -``` %s```\n" %i["numero"]
        msg += "**CEP ** -``` %s```\n\n" %i["cep"]
      end
    else
      msg += "``` %s```\n\n" %enderecos
    end

    msg += "**❲ Benefícios Sociais ❳**\n\n"

    beneficiosSociais = param["beneficiosSociais"]
    if beneficiosSociais.class == Array
      for i in beneficiosSociais
        msg += "**Entidade ** -``` %s```\n" %i["entidade"]
        msg += "**Espécie ** -``` %s```\n" %i["especie"]
        msg += "**Valor ** -``` %s```\n\n" %i["valor"]
      end
    else
      msg += "``` %s```\n\n" %beneficiosSociais
    end

    msg += "**❲ Profissões ❳**\n\n"

    profissoes = param["profissoes"]
    if profissoes.class == Array
      for i in profissoes
        msg += "**CNPJ ** -``` %s```\n" %i["cnpj"]
        msg += "**Profissão ** -``` %s```\n" %i["profissao"]
        msg += "**Salário ** -``` %s```\n" %i["salario"]
        msg += "**Entrada ** -``` %s```\n\n" %i["entrada"]
      end
    else
      msg += "``` %s```\n\n" %profissoes
    end

    msg += "**❲ Veículos ❳**\n\n"

    veiculos = param["veiculos"]
    if veiculos.class == Array
      for i in veiculos
        msg += "**Chassi ** -``` %s```\n" %i["chassi"]
        msg += "**Renavam ** -``` %s```\n" %i["renavam"]
        msg += "**Placa ** -``` %s```\n" %i["placa"]
        msg += "**Marca ** -``` %s```\n" %i["marca"]
        msg += "**Ano de Fabricaçao ** -``` %s```\n" %i["anoDeFabricacao"]
        msg += "**Ano do Modelo ** -``` %s```\n\n" %i["anoDoModelo"]
      end
    else
      msg += "``` %s```\n\n" %veiculos
    end

    msg += "**❲ Telefones ❳**\n\n"

    telefones = param["telefones"]
    for i in telefones
      msg += "``` %s```\n" %i
    end

    msg += "**\n❲ Emails ❳**\n\n"

    emails = param["emails"]
    for i in emails
      msg += "``` %s```\n" %i
    end
    
    return msg
  end
end

class CPF_cnh
  def main(param)
  end
end

class CPF_datasus
  def main(param)
    msg = "**❲ ✅ ❳ - CPF encontrado!**\n\n"
    msg += "**❲ Dados Pessoais ❳**\n\n"
    msg += "**Nome ** -``` %s```\n" %param["dadosPessoais"]["nome"]
    msg += "**Nascimento ** -``` %s```\n" %param["dadosPessoais"]["nascimento"]
    msg += "**Sexo ** -``` %s```\n" %param["dadosPessoais"]["sexo"]
    msg += "**CPF ** -``` %s```\n" %param["dadosPessoais"]["cpf"]
    msg += "**CNS ** -``` %s```\n\n" %param["dadosPessoais"]["cns"]
    msg += "**❲ Parentes ❳**\n\n"
    msg += "**Pai ** -``` %s```\n" %param["parentes"]["pai"]
    msg += "**Mãe ** -``` %s```\n\n" %param["parentes"]["mae"]
    msg += "**❲ Registro Geral ❳**\n\n"
    msg += "**RG ** -``` %s```\n" %param["registroGeral"]["rg"]
    msg += "**Emissor ** -``` %s```\n" %param["registroGeral"]["emissor"]
    msg += "**Data de Emissão ** -``` %s```\n" %param["registroGeral"]["dataDeEmissao"]
    msg += "**UF do RG ** -``` %s```\n\n" %param["registroGeral"]["ufDoRg"]
    msg += "**❲ Endereço ❳**\n\n"
    msg += "**Município ** -``` %s```\n" %param["endereco"]["municipio"]
    msg += "**Bairro ** -``` %s```\n" %param["endereco"]["bairro"]
    msg += "**Logradouro ** -``` %s```\n" %param["endereco"]["logradouro"]
    msg += "**N° ** -``` %s```\n" %param["endereco"]["numero"]
    msg += "**CEP ** -``` %s```\n\n" %param["endereco"]["cep"]
    msg += "**Município de Nascimento ** -``` %s```\n\n" %param["municipioDeNascimento"]
    msg += "**Telefone ** -``` %s```" %param["telefone"]
    return msg
  end
end
