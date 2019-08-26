# encoding: UTF-8

=begin
  Classe pour la construction de la page HTML permettant de construire
  la lettre de motivation.
=end
class HTMLPage
class << self
  def init
    File.unlink(path) if File.exists?(path)
    code = TEMPLATE_HTML
    scripts = []
    Dir["#{APPFOLDER}/js/required_first/*.js"].each do |fpath|
      fname = File.basename(fpath)
      scripts << "<script type='text/javascript' src='js/required_first/#{fname}'></script>"
    end
    Dir["#{APPFOLDER}/js/required_then/*.js"].each do |fpath|
      fname = File.basename(fpath)
      scripts << "<script type='text/javascript' src='js/required_then/#{fname}'></script>"
    end
    code.sub!(/__SCRIPTS__/,scripts.join("\n"))
    csss = []
    Dir["#{APPFOLDER}/css/*.css"].each do |fpath|
      fname = File.basename(fpath)
      csss << "<link rel=\"stylesheet\" href=\"css/#{fname}\">"
    end
    code.sub!(/__CSS__/,csss.join("\n"))
    # On écrit le code dans le fichier
    File.open(path,'wb'){|f| f.write code}
  end
  def path
    @path ||= File.join(APPFOLDER,'LM_BUILDER.HTML')
  end
end #/<< self
end #/HTMLPage

TEMPLATE_HTML = <<-HTML
<!DOCTYPE html>
<html lang="fr" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>L.M. BUILDER</title>
    __CSS__
  </head>
  <body>


    <section id="section-lettre">
      <div id="lettre" class="connectedParagraphs"></div>
    </section>



    <section id="section-paragraphes">
      <div id="div-search">

      </div>
      <div id="paragraphs" class="connectedParagraphs">

      </div>
    </section>



    <section id="section-tools">
      <div id="similaires" class="connectedParagraphs"></div>
    </section>



    __SCRIPTS__

  </body>
</html>
HTML
