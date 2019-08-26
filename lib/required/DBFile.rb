#!/usr/bin/env ruby

class DBFile
class << self

  def init
    File.unlink(path) if File.exists?(path)

    reffile.write <<-MYSQL
  CREATE DATABASE IF NOT EXISTS jobs;

  USE jobs;

  DROP TABLE IF EXISTS extraits;
  CREATE TABLE extraits (
  id          INT PRIMARY KEY AUTO_INCREMENT,
  contenu     TEXT NOT NULL,
  qualite     TINYINT DEFAULT 3,
  similarite  INT,
  affinite    INT,
  ) CHARACTER SET utf8 AUTO_INCREMENT=1;

    MYSQL

  end

  # Pour ajouter du code au fichier
  def add str
    reffile.write("\n\n#{str}")
  end
  def close
    reffile.close
  end
  def reffile
    @reffile ||= File.open(path, "a")
  end
  def path
    @path ||=  File.join(%w{. paragraphes.sql})
  end
end #<< self
end #/DBFile
