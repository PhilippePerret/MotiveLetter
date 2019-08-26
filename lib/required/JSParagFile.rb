# encoding: UTF-8
=begin

Module gérant le fichier 'paragraph.js' qui contient toutes les données
des paragraphes traités

=end
class JSParagFile
class << self
  def init
    reffile.write("'use strict';\n\nconst PARAGRAPHS = [];\n\n")
  end
  # Ajoute l'instance +paragraph+ {Paragraphe} au fichier paragraphes.js
  def add paragraph
    reffile.write paragraph.js_data
  end
  def reffile
    @reffile ||= begin
      File.unlink(path) if File.exists?(path)
      File.open(path,'a')
    end
  end
  def close
    reffile.close
  end
  def path
    @path ||= File.join(APPFOLDER,'js','required_then','data_paragraphes.js')
  end
end #/<< self
end #/JSParagFile
