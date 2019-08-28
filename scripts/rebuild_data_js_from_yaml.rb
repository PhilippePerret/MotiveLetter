# encoding: UTF-8
=begin
  Module qui reconstruit le fichier des données de paragraphes au format JS
  d'après le fichier YAML (sans repasser par l'analyse de toutes ces données)
=end
require_relative 'xrequired'

begin
  backup_paragraphes_js
  ref = File.open(PARAGS_JS_DATA_PATH,'a')
  ref.write "'use strict';\n\nconst PARAGRAPHS = [];\n\n"
  YAML.load_file(PARAGS_YAML_DATA_PATH).each do |dparag|
    ref.write "PARAGRAPHS.push(new Paragraph(#{dparag.to_json}));\n\n"
  end
rescue Exception => e
  raise e
ensure
  ref.close
end

puts "= Fichier js réactualisé avec succès ="
