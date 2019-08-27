'use strict'
/**
  const LM
  Gestion de la lettre de motivation
**/

const LM = {
  name: 'LM'

, add(ui){
    const par_id = parseInt($(ui.helper).data('id'),10)
    const par = Paragraph.get(par_id)
    UI.lettre.append(par.div)
    par.div.draggable({disabled:true})
  }

  /**
    Méthode mettant le texte final dans le presse-papier et dans un
    champ textarea pour le copier.
  **/
, copyTexteOrIds(for_ids){
    const my = this
    var contenu = [], confMsg
    if ( for_ids ) {
      UI.lettre.forEachParagraph(function(parag){contenu.push(parag.id)})
      contenu = `[${contenu.join(', ')}]`
      confMsg = "La liste des identifiants de paragraphes"
    } else {
      UI.lettre.forEachParagraph(function(parag){contenu.push(parag.contenu)})
      contenu = contenu.join(RC+RC)
      confMsg = "La lettre de motivation"
    }
    navigator.permissions.query({name: "clipboard-write"}).then(res => {
      // if (res.state == "granted" || res.state == "prompt") {
      if (false) {
        if (navigator.clipboard.writeText){
          navigator.clipboard.writeText(contenu).then(function(){
            my.confirmCopyInClipboard(confMsg)
          }, function(){
            my.denyCopyInClipboard()
          })
        } else if ( navigator.clipboard.write ) {

        }
      } else {
        // Si on ne possède pas les droits, on place le texte dans un
        // textarea qu'on sélectionne et qu'on copie.
        UI.clipboardField.val(contenu)
        UI.clipboardField.show().focus().select()
        $('button#btn-toggle-clipboard-field').show()
        document.execCommand('copy');
        my.confirmCopyInTextarea(confMsg)
      }
    });
  }
, confirmCopyInClipboard(confMsg){
    UI.dialog(`${confMsg} se trouve dans le presse-papier. Il suffit de la coller à l'endroit voulu.`,
    {icon: 'marion.png', title: 'Liste dans le presse-papier'})
  }
, confirmCopyInTextarea(confMsg){
    UI.dialog(`${confMsg} se trouve dans le champ de texte. Il suffit de la copier-coller à l'endroit voulu.`,
    {icon: 'marion.png', title: 'Liste dans le champ de texte'})
  }
, denyCopyInClipboard(){
    UI.clipboardField.show()
    UI.dialog("Malheureusement, le texte de la lettre n'a pas pu être copié dans le presse-papier. Merci de le récupérer dans le champ de saisie ouvert.",
    {icon: 'marion.png'})
  }
  // Pour fermer le champ de saisie (le textarea)
, closeTextarea(){
    UI.clipboardField.hide()
    $('button#btn-toggle-clipboard-field').hide()
  }
}
