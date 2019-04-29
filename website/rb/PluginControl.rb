require "fileutils"

module Bot
  module PluginControl
    class Config
      PATH = File.dirname(File.expand_path(__FILE__)) + "/../../"
    end

    def self.cutFilePath(path, files)
      for f in files
        f = f.to_s.gsub!(path, "")
        f = f.to_s.gsub!(".rb", "")
        f[0] = f[0].upcase!
      end
    end

    def getEnabledPlugins
      path = Config::PATH + "plugins/*.rb"
      files = Dir[path]
      PluginControl.cutFilePath(Config::PATH + "plugins/", files)
      return files
    end

    def getDisabledPlugins()
      path = Config::PATH + "disabled/*.rb"
      files = Dir[path]
      PluginControl.cutFilePath(Config::PATH + "disabled/", files)
      return files
    end

    def enablePlugin(name)
      file_disabled = Config::PATH + "disabled/#{name}.rb"
      file_enabled = path + "plugins/#{name}.rb"
      FileUtils.mv(file_disabled, file_enabled)
    end

    def disablePlugin(name)
      file_disabled = Config::PATH + "disabled/#{name}.rb"
      file_enabled = path + "plugins/#{name}.rb"
      FileUtils.mv(file_enabled, file_disabled)
    end
  end
end
