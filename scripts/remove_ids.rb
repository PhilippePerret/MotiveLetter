# encoding: UTF-8
=begin
Script permettant de supprimer une liste d'identifiants dans le fichier
data_paragraphes.yml et qui actualise ensuite la liste js.
=end
require_relative 'xrequired'

ADD_IF_GROUPE_AFFINITE = true
CONFIRMED = false


LIST_REMOVED = [117, 119, 640, 1504, 1538, 1500, 1462, 1631, 1630, 1632, 1624, 1635, 1619, 1637, 1617, 1441, 1413, 1439, 1418, 1414, 1398, 1409, 1395, 1404, 1393, 1394, 1380, 1391, 1384, 1368, 1372, 1379, 1371, 1370, 1366, 1367, 1365, 1364, 1360, 1363, 312, 1361, 1359, 1358, 808, 1356, 1357, 1355, 1354, 1268, 1295, 1293, 1292, 1291, 1290, 1288, 1283, 1282, 1281, 1280, 1279, 1277, 1278, 1274, 1273, 1188, 1284, 1270, 1265, 1286, 1272]

nombre_a_removed = LIST_REMOVED.count

puts "=== Identifiants à supprimer : #{LIST_REMOVED.sort}"

# On met les paragraphes dans une table pour pouvoir les retrouver plus
# facilement (seulement pour les messages d'erreur pour le moment)
DATA_PARAGRAPHES = {}
data_paragraphs_yaml.each do |dparag|
  DATA_PARAGRAPHES.merge!(dparag[:id] => dparag)
end

# Nombre avant
nombre_init = data_paragraphs_yaml.count
puts "Nombre initial de paragraphes : #{nombre_init}"

# Pour effacer les données, il faut vérifier que les paragraphes supprimés ne
# soit pas les paragraphes référents de paragraphes restants.
data_paragraphs_yaml.each do |dparag|
  if LIST_REMOVED.include?(dparag[:grpAffinite]) && !LIST_REMOVED.include?(dparag[:id])
    puts "PARAGRAPHE ##{dparag[:id]} : #{dparag[:contenu]}"
    grp_id = dparag[:grpAffinite]
    puts "PARAGRAPHE ##{grp_id} : #{DATA_PARAGRAPHES[grp_id][:contenu]}"
    if ADD_IF_GROUPE_AFFINITE
      LIST_REMOVED << dparag[:id]
      notice "--- paragraphe ##{dparag[:id]} ajouté car il appartient au groupe ##{dparag[:grpAffinite]} dont le référent va être détruit."
    else
      error "Le paragraphe ##{dparag[:id]} va se retrouver sans groupe d'affinité, car il appartient au groupe ##{dparag[:grpAffinite]} dont le référent va être détruit."
      error "Je ne peux pas procéder à la destruction."
      puts "\n\n"
      exit
    end
  end
end

# puts "=== data_paragraphs_yaml avant (#{nombre_init}): #{data_paragraphs_yaml.inspect}"

# On efface les identifiants de la liste
ids_founds = []
data_paragraphs_yaml.reject! do |dparag|
  not_ok = LIST_REMOVED.include?(dparag[:id])
  if not_ok
    ids_founds << dparag[:id]
    LIST_REMOVED.delete(dparag[:id])
  end
  not_ok
end

# Nombre de paragraphes après la modification
nombre_after = data_paragraphs_yaml.count

# if nombre_after != (nombre_init - nombre_a_removed)
#   puts "=== data_paragraphs_yaml après (#{nombre_after}): #{data_paragraphs_yaml}"
#   error "#{LIST_REMOVED.count + nombre_erased_by_text} paragraphes auraient dû être supprimés"
#   error "Seulement #{nombre_init - nombre_after} paragraphes ont pu être supprimés (#{ids_founds.inspect})…"
#   puts "Ids qui n'ont pas pu être supprimés : #{LIST_REMOVED}"
#   puts "\n\n"
#   exit 1
# end

puts "Nombre de paragraphes restants : #{nombre_after}"

if ADD_IF_GROUPE_AFFINITE && !CONFIRMED
  puts "Il faut confirmer les ajouts puis mettre CONFIRMED à true pour procéder réellement à l'opération."
  exit 0
end

backup_paragraphes_yaml
File.open(PARAGS_YAML_DATA_PATH,'wb'){|f| f.write YAML.dump(data_paragraphs_yaml)}

puts "\n= OPÉRATION TERMINÉE ="
