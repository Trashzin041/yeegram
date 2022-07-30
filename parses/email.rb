class Email_luarsearch
  def main(param)
    msg = "**❲ ✅ ❳ - Email encontrado!**\n\n"
    msg += "**CPF ** -``` %s```\n" %param["cpf"]
    msg += "**Email ** -``` %s```" %param["email"]
    return msg
  end
end
