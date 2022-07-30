class Foto
  def main(param)
    msg = "**❲ ✅ ❳ - Foto encontrada!**\n\n"
    msg += "**Pai ** -``` %s```\n" % param["pai"]
    msg += "**Mãe ** -``` %s```\n" % param["mae"]
    msg += "**Nascimento ** -``` %s```\n" % param["nascimento"]
    msg += "**Nome ** -``` %s```" % param["nome"]    
  end
end
