'use strict'
/**
  Classe Paragraph
  ----------------
  Pour la gestion des paragraphes
**/
class Paragraph {

  /**
    |
    | CLASSE
    |
    |
  **/

  // Retourne le paragraphe d'identifiant +par_id+
  static get(par_id){
    return this.items[par_id]
  }

  /**
    | Construction de la liste de tous les paragraphes.
    | Ils sont placés dans deux listes :
    |   - La table `items` qui contient tous les paragraphes avec en clé
    |     leur identifiant
    |   - La table `byAffinites` qui regroupe les paragraphes par affinité
    |     avec en clé l'affinité (qui correspond à l'identifiant du paragraphe
    |     référence, dans la plupart des cas)
  **/
  static instancyAndBuildAll(){
    const my = this
    my.items = {}
    my.byAffinites = {}
    PARAGRAPHS.forEach(parag => {
      Object.assign(my.items, {[parag.id]: parag})
      if ( undefined === my.byAffinites[parag.grpAffinite] ) {
        Object.assign(my.byAffinites, {[parag.grpAffinite]: {
            referent: null
          , items: []
          , count: 0
        }})
      }
      my.byAffinites[parag.grpAffinite].items.push(parag)
      my.byAffinites[parag.grpAffinite].count ++;
      // Est-ce le référent ? On le reconnait au fait que sa similarité est de
      // 100. Si c'est le cas, on l'enregistre comme référente et on l'affiche
      // dans la page.
      if ( parag.similarite === 100 ) {
        my.byAffinites[parag.grpAffinite].referent = parag;
      }
    })

    // Il faut classer les affinités par indice de similarité (les plus
    // proches en premier)
    // Et on en profite pour construire le référent, maintenant que tous les
    // paragraphes ont été traités
    for(var aff in my.byAffinites) {
      my.byAffinites[aff].items.sort(function(a,b){ return b.similarite - a.similarite})
      my.byAffinites[aff].referent.buildInReferents()
    }

    // console.log("my.byAffinites = ", my.byAffinites)

    my.observe()
  }

  // Retourne le nombre d'items par affinité pour l'affinité +affinite+
  static nombreOfAffinite(affinite){
    return this.byAffinites[affinite].count
  }
  /**
    Il faut observer les paragraphes, notamment pour pouvoir afficher leurs
    similaires.
  **/
  static observe(){
    const my = this
    UI.paragraphs.observe()
  }

  /**
    Méthode appelée quand on clique sur le paragraphe +jqParag+
  **/
  static onClickParag(ev){
    const my = this
    if ( my.currentParag ) my.currentParag.div.removeClass('selected')
    const parag = my.get(parseInt($(ev.currentTarget).data('id'),10))
    parag.div.addClass('selected')
    parag.showSimilaires()
    my.currentParag = parag
  }

  /**
    |
    | INSTANCE
    |
    |
  **/
  constructor(data){
    this.data = data
  }

  // Affiche les similaires du paragraphe courant
  showSimilaires(){
    const my = this
    var similaires = this.constructor.byAffinites[this.grpAffinite].items
    UI.similaires.html('')
    similaires.forEach(parag => parag.buildInSimilaires())
    UI.similaires.observe()
  }


  // Construit le paragraphe dans la liste des paragraphes référents
  buildInReferents(){
    UI.paragraphs.append(this.build())
  }

  // Construit le paragraphe dans la liste des similaires
  buildInSimilaires(){
    if ( this.isReferent ) return
    UI.similaires.append(this.build())
  }

  // Construit le paragraphe dans la page
  build(){
    let div = Dom.createDiv({id:this.domId, class:'par', 'data-id':this.id, title:`Paragraphe #${this.id}`})
    div.append(this.infosBloc())
    div.append(Dom.createDiv({class:'contenu', text:this.contenu, 'data-id':this.id}))
    this.div = $(div)
    return $(div)
  }

  infosBloc(){
    var divBloc = Dom.createDiv({class:'infos'})
    divBloc.append(Dom.createSpan({class:'id', text:`#${this.id}`}))
    if (this.nombre_similaires > 1) {
      var simi = ''
      if (this.similarite < 100) { simi += `${this.similarite}% de `}
      // simi += String(this.nombre_similaires)
      simi += String(this.grpAffinite)
      divBloc.append(Dom.createSpan({class:'simi', text:simi}))
    }
    return divBloc
  }

  get nombre_similaires(){
    if (undefined === this._nombre_similaires){
      this._nombre_similaires = this.constructor.nombreOfAffinite(this.grpAffinite)
    }
    return this._nombre_similaires
  }

  get id()          {return this.data.id}
  get contenu()     {return this.data.contenu}
  get grpAffinite() {return this.data.grpAffinite}
  get similarite()  {return this.data.similarite}
  get isReferent()  {return this.grpAffinite === this.id && this.similarite === 100}

  get domId()       {return `par-${this.id}`}
}
