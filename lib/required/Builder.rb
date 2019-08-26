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
    DBFile.init
    LMFile.init
    Paragraph.init
    JSParagFile.init
    HTMLPage.init
  end

  # On traite l'opération
  def run
    # On traite chacune des (nouvelles) lettres de motivations
    LMFile.each_file do |lmfile|
      lmfile.treate
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
