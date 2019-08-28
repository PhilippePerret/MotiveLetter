# encoding: UTF-8

def data_paragraphs_yaml
  @data_paragraphs_yaml ||= YAML.load_file(PARAGS_YAML_DATA_PATH)
end

def backup_paragraphes_yaml
  FileUtils.mv(PARAGS_YAML_DATA_PATH, "#{PARAGS_YAML_DATA_PATH}.bckup.yml")
end

def backup_paragraphes_js
  FileUtils.mv(PARAGS_JS_DATA_PATH, "#{PARAGS_JS_DATA_PATH}.bckup.js")
end
