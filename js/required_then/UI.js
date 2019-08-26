'use strict';

const UI = {

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
})

class ParagraphsList {

  constructor(domId){
    this.domId = domId
  }

  append(domObj){
    this.jqObj.append(domObj)
  }

  sortable(options){
    this.jqObj.sortable(options)
  }

  observe(){
    var my = this
    my.jqObj.find('.par').on('click', Paragraph.onClickParag.bind(Paragraph))
  }

  html(str){this.jqObj.html(str)}

  get jqObj(){return this._jqobj||(this._jqobj = $(`#${this.domId}`))}
}
