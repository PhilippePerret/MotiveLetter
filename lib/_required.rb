# encoding: UTF-8
require 'fileutils'
require 'json'

THISFOLDER = File.dirname(__FILE__)
APPFOLDER = File.dirname(THISFOLDER)
puts "APPFOLDER: '#{APPFOLDER}'"

Dir["#{THISFOLDER}/required/**/*.rb"].each{|m|require m}

puts "LM folder : #{LMFile.folder}"
