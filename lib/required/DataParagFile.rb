# encoding: UTF-8


class DataParagFile
class << self

  attr_reader :data

  def init
    # Dans tous les cas, on met les données à rien
    @data = []
    # À l'initialisation, il faut relever tous les paragraphes qui sont
    # consignés dans le fichier 'data_paragraphes.yml'. Les nouveaux
    # paragraphes seront ajoutés à ceux-là.
    traiteDataInit if File.exists?(path)
  end

  # Ajouter un paragraphe aux données
  def add parag
    @data << parag.yaml_data
  end

  # La méthode retourne true pour dire au runner de supprimer les fichiers
  # qui ont été traités correctement.
  def saveData
    print "Enregistrement des paragraphes dans le fichier YAML…"
    File.open(path,'w'){|f| YAML.dump(@data, f)}
    puts " OK"
    return true
  rescue Exception => e
    raise e
  end

  # Traitement des données initiales
  # On transforme tous les paragraphes en instance, comme s'ils venaient
  # des fichiers.
  def traiteDataInit
    initData = YAML.load_file(path)
    # On détruit tout de suite le fichier parce que des éléments devront
    # être ajoutés au cours du traitement.
    File.unlink(path)
    initData.each do |dparag|
      parag = Paragraph.new(dparag[:contenu], dparag)
      parag.treate
    end
  end

  def path
    @path ||= File.join(APPFOLDER,'data_paragraphes.yml')
  end

end #/<< self
end #/DataParagFile
