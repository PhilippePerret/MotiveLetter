# encoding: UTF-8

# Ecrit en rouge dans la console
def error msg
  puts "\033[0;31m#{msg}\033[0m"
end


def notice msg
  puts "\033[1;32m#{msg}\033[0m"
end
