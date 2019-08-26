# encoding: UTF-8
=begin

  Traitement d'un fichier de lettre de motivation

=end
class LMFile
  class << self

    attr_reader :nombre_dossiers, :nombre_fichiers

    def each_file
      all_files.each do |lmfile|
        yield lmfile
      end
    end

    def init
      @nombre_dossiers = Dir["#{folder}/*"].count
      @nombre_fichiers = 0
    end

    # Toutes les lettres de motivation
    def all_files
      @all_files ||= begin
        Dir["#{folder}/**/*.docx"].collect do |fpath|
          affixe = File.basename(fpath,File.extname(fpath)).downcase
          next if affixe === 'annonce' || affixe.match('~')
          @nombre_fichiers += 1
          LMFile.new(fpath)
        end.compact
      end
    end

    # Rapport de fin
    def report
      puts "Nombre dossiers traités : #{nombre_dossiers}"
      puts "Nombre de fichiers      : #{nombre_fichiers}"
    end

    # Dossier contenant toutes les lettres de motivation
    def folder
      @folder ||= File.expand_path(File.join(%w{. originales}))
    end
  end #/<< self


  # ---------------------------------------------------------------------
  attr_reader :path

  def initialize path
    @path = path
  end

  # Boucle sur tous les paragraphes du fichier
  def each_paragraphe
    paragraphes.each do |paragraphe|
      yield paragraphe
    end
  end

  # On traite la lettre de motivation, c'est-à-dire qu'on
  # met les paragraphes en base de données ou en fichier javascript
  def treate
    each_paragraphe do |para|
      para.calc_affinite_et_similarite || next
      DBFile.add("INSERT INTO extraits (contenu, affinite, similarite) VALUES (\"#{para.contenu}\", #{para.affinite}, #{para.similarite});")
      JSParagFile.add(para)
    end
  end

  # Tous les paragraphes du fichier, après épuration
  def paragraphes
    @paragraphes ||= begin
      code.split("\n").collect do |parag|
        parag = parag.strip
        parag != "" || next
        parag.gsub!(/\*/, '')
        parag.gsub!(/"/, '\"')
        # parag.gsub!(/\n/, ' ')
        parag.gsub!(/  +/, ' ')

        next if [
          "marion michel",
          "227 chemin de fromontal",
          "82230 la salvetat-belmontet",
          "82230 la salvetat belmontet",
          "tel : 06 06 92 12 23",
          "56 avenue phénix haut brion",
          "33600 pessac",
          "email : marion.michel@agrocampus-ouest.fr",
          "email : marion.michel31@free.fr",
          "monsieur,", "madame,", "madame, monsieur,",
          "étudiante ingénieure en m2 horticulture à agrocampus-ouest angers",
          "option protection des plantes et environnement",
          "14 rue de menespey",
          "résidence ecrin de jade, appt c28",
          "33185 le haillan",
          "marion michel",
          "ingénieure en horticulture"
        ].include?(parag.downcase)

        Paragraph.new(parag)
      end.compact # pour retirer les nil
    end
  end
  # Code simple texte du fichier
  def code
    @code ||= `textutil -stdout -convert txt "#{path}"`
  end

end #/LMFile
