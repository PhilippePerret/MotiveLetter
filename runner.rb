#!/usr/bin/env ruby
require './lib/_required'

begin

  builder = Builder.current
  builder.init
  builder.run
  
  # Après l'opération, on fait le rapport
  LMFile.report
  builder.report

rescue Exception => e
  puts e
  puts e.backtrace
ensure
  DBFile.close        rescue nil
  JSParagFile.close   rescue nil
end
