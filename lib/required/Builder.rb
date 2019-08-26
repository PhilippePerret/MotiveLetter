# encoding: UTF-8

class Builder
  def self.current
    @@current ||= new(Time.now)
  end

  attr_reader :start_time, :end_time

  def initialize start_time
    @start_time = start_time
  end
  def init
    print "Initialisation…"
    Paragraph.init
    JSParagFile.init
    DataParagFile.init
    DBFile.init
    LMFile.init
    HTMLPage.init
    puts "   OK"
  end

  # On traite l'opération
  def run
    # On traite chacune des (nouvelles) lettres de motivations
    puts "Traitement des lettres de motivation…"
    LMFile.each_file do |lmfile|
      LMFile.add_traited(lmfile) if lmfile.treate
    end
    # On enregistre les paragraphes dans le fichier yaml
    if DataParagFile.saveData
      LMFile.retire_traiteds
    end
  end

  # Rapport de fin d'opération
  def report
    @end_time = Time.now
    puts "\n\nDÉBUT : #{start_time}"
    puts "FIN : #{end_time}"
    puts "Durée : #{end_time - start_time}"
  end
end #/Builder
