#!/usr/bin/env ruby

class Paragraph

  MIN_PROXIMITE = 0.5
  SIMILARITE_DEFAULT = 100

  class << self

    attr_reader :tables_mots
    def init
      @tables_mots  = {}
      @lastId       = 0
    end

    # Retourne un identifiant unique
    def newId
      @lastId += 1
    end

    # Méthode qui compare la table des mots aux tables
    # déjà créées
    def compare iparagraphe

      nombre_mots = iparagraphe.table_mots.keys.count
      nombre_mots > 0 || begin
        return nil # On doit exclure ce paragraphe
      end

      longueur_paragraphe = iparagraphe.contenu.length

      # Pour conserver la meilleure proximité possible
      best_current_similarite = 0
      best_affinite_id = nil

      tables_mots.each do |affinite_id, data_affinite|
        nombre_founds = 0
        iparagraphe.table_mots.each do |mot, nombre|
          if data_affinite[:mots].key?(mot)
            nombre_founds += 1
          end
        end
        proximite = nombre_founds.to_f / nombre_mots

        # puts "Mots / founds / Proximité : #{nombre_mots} / #{nombre_founds} / #{proximite}"

        if proximite >= MIN_PROXIMITE
          # => Le paragraphe est en proximité avec le paragraphe testé

          # puts "-------- PROXIMITÉ TROUVÉE ENTRE:\n#{iparagraphe.contenu}\nET\n#{data_affinite[:contenu]}"

          # L'indice de similarité dépend de la longueur
          # de chaque chaine
          min = [data_affinite[:longueur], longueur_paragraphe].min
          max = [data_affinite[:longueur], longueur_paragraphe].max
          similarite = ((min.to_f / max) * 100).round

          if affinite_id && similarite == 100
            # <= Les deux paragraphes sont identiques
            # => On ne prend pas celui-ci
            return nil
          else
            # <= Il y a une affinité, mais les paragraphes ne sont pas identiques
            # => On conserve cette similarité courante pour voir s'il y a mieux
            if similarite > best_current_similarite
              best_current_similarite = similarite
              best_affinite_id = affinite_id
            end
          end
        else
          # <=  Le paragraphe n'est pas en proximité avec
          #     le paragraphe testé
          # =>  On continue
        end
      end #/ fin de boucle sur tous les paragraphes

      if best_affinite_id
        # <= Une affinité avec un autre paragraphe a été trouvée
        # => On renvoie les informations de cette affinité
        return [best_affinite_id, best_current_similarite]
      else
        # <= Aucune affinité n'a été trouvée
        # => On crée un nouveau paragraphe de référence
        @tables_mots.merge!(iparagraphe.id => {mots: iparagraphe.table_mots, contenu: iparagraphe.contenu, longueur: iparagraphe.contenu.length})
        return [iparagraphe.id, SIMILARITE_DEFAULT]
      end

    end

  end #/<< self

  attr_reader :contenu, :id, :affinite, :similarite

  def initialize contenu
    @contenu  = contenu
    @id       = self.class.newId
  end

  def calc_affinite_et_similarite
    if evaluation = self.class.compare(self)
      @affinite, @similarite = evaluation
    else
      return nil # pour ne pas en tenir compte
    end
  end

  # Retourne les données du paragraphe pour la donnée javascript
  def js_data
    @js_data ||= begin
      d = {id:id, contenu:contenu, grpAffinite:affinite, similarite:similarite}.to_json
      "PARAGRAPHS.push(new Paragraph(#{d}));\n\n"
    end
  end

  def table_mots
    @table_mots ||= begin
      h = {}
      mots.each do |m|
        next if m.length < 3
        h.key?(m) || h.merge!(m => 0)
        h[m] += 1
      end
      h
    end
  end

  def mots
    @mots ||= contenu.gsub(/[cCdl][‘’']/,'').gsub(/[[:punct:]]/,'').split(' ')
  end
end
