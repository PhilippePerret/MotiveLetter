'use strict';

const UI = {
  /**
    Pour afficher un message avec une icone
    TODO Faire plutôt une classe (utilisable partout)
  **/
  dialog(msg, options){
    const my = this
    options = options || {}
    const dialogId = `dialog-${Number(new Date())}`
    // Valeurs par défaut
    options.buttons || Object.assign(options,{buttons:[{text:'OK', onclick:`UI.onClickOk.call(UI,'${dialogId}')`}]})
    options.title   || Object.assign(options,{title: `Message de Motive-Letter`})
    options.icon    || Object.assign(options, {icon: 'message.png'})
    // On construit la boite
    var div = Dom.createDiv({class:'dialog', id:dialogId})
    div.append(Dom.createDiv({class:'title', text:options.title}))
    div.append(Dom.create('IMG',{src:`img/icons/${options.icon}`, class:'icon'}))
    div.append(Dom.createDiv({class:'message',text:msg}))
    var divBtns = Dom.createDiv({class:'buttons'})
    options.buttons.forEach(dbutton=>{
      divBtns.append(Dom.createButton(dbutton))
    })
    div.append(divBtns)
    document.body.append(div)
  }
, onClickOk(dialogId){
    $(`div#${dialogId}`).remove()
  }

};

Object.defineProperties(UI, {
  name: {get(){return'UI properties'}}
, lettre:{get(){
    if (undefined === this._lettre){
      this._lettre = new ParagraphsList('lettre')
    } return this._lettre
  }}
, paragraphs:{get(){
    if (undefined === this._paragraphs){
      this._paragraphs = new ParagraphsList('paragraphs')
    } return this._paragraphs
  }}
, similaires:{get(){
    if (undefined === this._similaires){
      this._similaires = new ParagraphsList('similaires')
    } return this._similaires
  }}
  // Sections
, section_lettre:{get(){return $('section#section-lettre')}}
, section_paragraphes:{get(){return $('section#section-paragraphes')}}
, section_tools:{get(){return $('section#section-tools')}}
, clipboardField:{get(){return $('textarea#clipboard-field')}}
})

class ParagraphsList {

  constructor(domId){
    this.domId = domId
  }

  /**
    Répète la fonction +fct+ sur chaque paragraphe du texte
  **/
  forEachParagraph(fct){
    this.jqObj.find('.par').each( (iparag, parag) => fct(Paragraph.getFromDom(parag)) )
  }

  append(domObj){
    this.jqObj.append(domObj)
  }

  sortable(options){
    this.jqObj.sortable(options)
  }

  // Affiche tous les paragraphes (qui ont pu être masqués suite à une
  // recherche)
  showAll(){
    this.jqObj.find('.par').show()
  }

  observe(){
    var my = this
    my.jqObj.find('.par').on('click', Paragraph.onClickParag.bind(Paragraph))
  }

  html(str){this.jqObj.html(str)}

  get jqObj(){return this._jqobj||(this._jqobj = $(`#${this.domId}`))}
}
