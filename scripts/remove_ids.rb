# encoding: UTF-8
=begin
Script permettant de supprimer une liste d'identifiants dans le fichier
data_paragraphes.yml et qui actualise ensuite la liste js.
=end
require_relative 'xrequired'

liste_ids_to_removed = [769, 825, 1159, 1169, 1168, 1170, 1171, 1167, 1166, 1163, 1160, 998,
  1157, 1003, 824, 822, 823, 821, 820, 816, 817, 819, 818, 815, 781, 779, 780, 775, 778,
  774, 773, 772, 771, 770, 754, 784, 171, 767, 766, 765, 764, 763, 762, 760, 759, 757, 753,
  752, 735, 683, 685, 682, 681, 679, 678, 677, 676, 674, 672, 671, 10, 1125, 575, 563, 552,
  1125, 658, 391, 390, 629, 628, 624, 621, 618, 612, 615, 614, 611, 610, 608, 412, 607, 605,
  503, 537, 470, 421, 471, 422, 433, 423, 420, 419, 627, 1035, 1138, 980, 933, 918, 903, 888,
  860, 504, 544, 830, 845, 845, 873, 1158, 761, 807, 777, 323, 372, 371, 370, 338, 317, 332,
  325, 184, 359, 175, 182, 181, 180, 178, 177, 173, 161, 172, 170, 169, 168, 167, 165, 166,
  700, 164, 163, 162, 159, 160, 156, 59, 791, 150, 158, 153, 155, 149, 152, 146, 148, 689,
  171, 48, 143, 1122, 139, 140, 142, 121, 122, 137, 136, 134, 131, 115, 118, 109, 106, 1112,
  114, 105, 104, 1104, 1080, 1062, 726, 655, 646, 637, 603, 528, 409, 399, 298, 265, 237, 217,
  185, 84, 68, 335, 358, 324, 1, 1162, 210, 77, 719, 326, 62, 133, 21, 40, 26, 616, 30, 29, 135,
  28, 22, 36, 27, 24, 25, 34, 622]

# Ajoutés suite aux erreurs rencontrées ci-dessous
liste_ids_to_removed += [108, 247, 268, 369, 472, 500, 540, 776, 806, 826, 841, 1073, 1164, 1165, 1173, 1183,
  1229, 1244, 1250,1252,1267,1269,1275,1276,1285,1289,1297,1298,1299,
  1325, 1436,1586,1605,1618,1620,1628,1634,1641,1642,1644]

LIST_REMOVED = liste_ids_to_removed

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

# Un premier effacement des "Rue du commerce"
erased_by_text = []
data_paragraphs_yaml.reject! do |dparag|
  not_ok = dparag[:contenu].downcase == 'rue du commerce' ||
    dparag[:contenu].include?('michel31@free') ||
    dparag[:contenu].downcase == 'ingénieur en horticulture' ||
    dparag[:contenu].include?('La boite à outils de l’auteur')
  if not_ok
    erased_by_text << dparag[:id]
  end
  not_ok
end
puts "= Liste des identifiants supprimés par le texte : #{erased_by_text}"
nombre_erased_by_text = erased_by_text.count

# Pour effacer les données, il faut vérifier que les paragraphes supprimés ne
# soit pas les paragraphes référents de paragraphes restants.
data_paragraphs_yaml.each do |dparag|
  if LIST_REMOVED.include?(dparag[:grpAffinite]) && !LIST_REMOVED.include?(dparag[:id])
    puts "PARAGRAPHE ##{dparag[:id]} : #{dparag[:contenu]}"
    grp_id = dparag[:grpAffinite]
    puts "PARAGRAPHE ##{grp_id} : #{DATA_PARAGRAPHES[grp_id][:contenu]}"
    error "Le paragraphe ##{dparag[:id]} va se retrouver sans groupe d'affinité, car il appartient au groupe ##{dparag[:grpAffinite]} dont le référent va être détruit."
    error "Je ne peux pas procéder à la destruction."
    puts "\n\n"
    exit
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

# if nombre_after != (nombre_init - (nombre_a_removed + nombre_erased_by_text))
#   puts "=== data_paragraphs_yaml après (#{nombre_after}): #{data_paragraphs_yaml}"
#   error "#{LIST_REMOVED.count + nombre_erased_by_text} paragraphes auraient dû être supprimés"
#   error "Seulement #{nombre_init - nombre_after} paragraphes ont pu être supprimés (#{ids_founds.inspect})…"
#   puts "Ids qui n'ont pas pu être supprimés : #{LIST_REMOVED}"
#   puts "\n\n"
#   exit 1
# end

puts "Nombre de paragraphes restants : #{nombre_after}"

backup_paragraphes_yaml
File.open(PARAGS_YAML_DATA_PATH,'wb'){|f| f.write YAML.dump(data_paragraphs_yaml)}

puts "\n= OPÉRATION TERMINÉE ="
