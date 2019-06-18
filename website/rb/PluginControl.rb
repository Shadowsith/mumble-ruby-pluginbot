require "fileutils"

module Bot
  class PluginControl
    PATH = File.dirname(File.expand_path(__FILE__)) + "/../../"

    def cutFilePath(path, files)
      for f in files
        f = f.to_s.gsub!(path, "")
        f = f.to_s.gsub!(".rb", "")
        f[0] = f[0].upcase!
      end
    end

    def getEnabledPlugins()
      path = PATH + "plugins/*.rb"
      files = Dir[path]
      cutFilePath(PATH + "plugins/", files)
      return files
    end

    def getDisabledPlugins()
      path = PATH + "disabled/*.rb"
      files = Dir[path]
      cutFilePath(PATH + "disabled/", files)
      return files
    end

    def enablePlugin(name)
      file_disabled = PATH + "disabled/#{name}.rb"
      file_enabled = path + "plugins/#{name}.rb"
      FileUtils.mv(file_disabled, file_enabled)
    end

    def disablePlugin(name)
      file_disabled = PATH + "disabled/#{name}.rb"
      file_enabled = path + "plugins/#{name}.rb"
      FileUtils.mv(file_enabled, file_disabled)
    end
  end
end
