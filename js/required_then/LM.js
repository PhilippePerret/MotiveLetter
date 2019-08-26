'use strict'
/**
  const LM
  Gestion de la lettre de motivation
**/

const LM = {
  name: 'LM'

, add(ui){
    console.log("Je vais ajouter le paragraphe ", ui);
    const par_id = parseInt($(ui.helper).data('id'),10)
    const par = Paragraph.get(par_id)
    UI.lettre.append(par.div)
    par.div.draggable({disabled:true})
  }
}
