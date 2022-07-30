def consulta(msg):
    dados = {}
    #######################
    dados["nome"] = msg.split('NOME: ')[1].split('\n')[0]
    dados["cpf"] = msg.split('CPF: ')[1].split('\n')[0]
    dados["statusNaReceita"] = msg.split('STATUS NA RECEITA: ')[1].split('\n')[0]
    dados["rendaPresumida"] = msg.split('RENDA PRESUMIDA: ')[1].split('\n')[0]
    dados["cidadeDeNascimento"] = msg.split('CIDADE DE NASCIMENTO: ')[1].split('\n')[0]
    dados["estadoDeNascimento"] = msg.split('ESTADO DE NASCIMENTO: ')[1].split('\n')[0]
    dados["dataDeNascimento"] = msg.split('DATA DE NASCIMENTO: ')[1].split('\n')[0]
    dados["telefones"] = []
    
    _telefones = msg.split('「📱」TELEFONES\n\n')[1].replace('\n\n• UF', '\nUF').split('\n\n• USUÁRIO: ')[0].split('\n\n')
    
    for i in _telefones:
        telefones = {}
        telefones["nome"] = i.split("NOME: ")[1].split("\n")[0]
        telefones["numero"] = i.split("NUMERO: ")[1].split("\n")[0]
        telefones["uf"] = i.split("UF: ")[1].split("\n")[0]
        telefones["cidade"] = i.split("CIDADE: ")[1].split("\n")[0]
        telefones["endereco"] = i.split("ENDEREÇO: ")[1].split("\n")[0]
        telefones["bairro"] = i.split("BAIRRO: ")[1].split("\n")[0]
        telefones["cep"] = i.split("CEP: ")[1].split("\n")[0]
        dados["telefones"].append(telefones)
    #######################
    return dados
