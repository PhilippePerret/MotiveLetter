$(document).ready(function(){

  UI.lettre.jqObj.sortable({
    connectWith: ".connectedParagraphs"
  }).disableSelection();

  UI.paragraphs.jqObj.sortable({
    connectWith: ".connectedParagraphs"
  }).disableSelection();

  UI.similaires.jqObj.sortable({
    connectWith: ".connectedParagraphs"
  }).disableSelection();

  if ( 'undefined' === typeof PARAGRAPHS ){
    UI.dialog(
      "Avant de pouvoir construire votre lettre, vous devez impérativement placer vos lettres de références dans le dossier `originales` et lancer le script `runner.rb` à l'aide de la commande :<br><code>ruby /path/to/MotiveLetter/runner.rb</code>."
    , {icon:'warning.png', title:'Préparation requise'})
  } else {
    Paragraph.instancyAndBuildAll()
    LM.prepare()
  }

}) // Fin de ready
