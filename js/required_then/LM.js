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
    this.addInDom(par)
  }

, addInDom(parag){
    console.log("Ajouter le paragraphe ", parag.jqObj)
    UI.lettre.append(parag.jqObj)
  }

  /**
    Méthode appelée au chargement de l'application qui regarde si une donnée
    `CURRENT_LM` existe, qui contiendrait les identifiants des paragraphes de
    la lettre courante. Si elle existe, la méthode "reconstruit" la lettre à
    partir de ces identifiants
  **/
, prepare(){
    console.log("-> prepare", CURRENT_LM)
    if ( 'undefined' === typeof CURRENT_LM ) return
    CURRENT_LM.forEach( paragId => this.addInDom(Paragraph.get(paragId)))
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

    // Si on ne possède pas les droits, on place le texte dans un
    // textarea qu'on sélectionne et qu'on copie.
    UI.clipboardField.val(contenu)
    UI.clipboardField.show().focus().select()
    $('button#btn-toggle-clipboard-field').show()
    document.execCommand('copy');

    navigator.permissions.query({name: "clipboard-write"}).then(res => {
      if (res.state == "granted" || res.state == "prompt") {
      // if (false) {
        if (navigator.clipboard.writeText){
          navigator.clipboard.writeText(contenu).then(function(){
            my.confirmCopyInClipboard(confMsg)
          }, function(){
            my.denyCopyInClipboard()
          })
        } else if ( navigator.clipboard.write ) {

        }
      } else {
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
