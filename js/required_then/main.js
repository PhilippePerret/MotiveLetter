$(document).ready(function(){

  Paragraph.instancyAndBuildAll()

  UI.lettre.jqObj.sortable({
    connectWith: ".connectedParagraphs"
  }).disableSelection();

  UI.paragraphs.jqObj.sortable({
    connectWith: ".connectedParagraphs"
  }).disableSelection();

  UI.similaires.jqObj.sortable({
    connectWith: ".connectedParagraphs"
  }).disableSelection();

  LM.prepare()
  
}) // Fin de ready
