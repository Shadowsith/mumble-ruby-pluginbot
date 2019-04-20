require "fileutils"

module Bot
  module PluginControl
    def cutFilePath(path, files)
      for f in files
        f = f.to_s.gsub!(path, "")
        f = f.to_s.gsub!(".rb", "")
        f[0] = f[0].upcase!
      end
    end

    def getRootPath
      File.dirname(File.expand_path(__FILE__)) + "/../../"
    end

    def getEnabledPlugins
      path = getRootPath + "plugins/*.rb"
      files = Dir[path]
      cutFilePath(getRootPath + "plugins/", files)
      return files
    end

    def getDisabledPlugins()
      path = getRootPath + "disabled/*.rb"
      files = Dir[path]
      cutFilePath(getRootPath + "disabled/", files)
      return files
    end

    def enablePlugin(name)
      file_disabled = getRootPath + "disabled/#{name}.rb"
      file_enabled = path + "plugins/#{name}.rb"
      FileUtils.mv(file_disabled, file_enabled)
    end

    def disablePlugin(name)
      file_disabled = getRootPath + "disabled/#{name}.rb"
      file_enabled = path + "plugins/#{name}.rb"
      FileUtils.mv(file_enabled, file_disabled)
    end
  end
end
