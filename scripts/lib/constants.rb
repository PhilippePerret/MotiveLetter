# encoding: UTF-8
=begin

Constantes pratiques

=end

APPFOLDER = File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__))))
puts "APPFOLDER: #{APPFOLDER}"

PARAGS_YAML_DATA_PATH = File.join(APPFOLDER,'data_paragraphes.yml')
PARAGS_JS_DATA_PATH = File.join(APPFOLDER,%w{js required_then data_paragraphes.js})
