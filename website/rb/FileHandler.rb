require "pathname"

module Bot
  module FileHandler
    def self.tryWrite(path, conf, script, type = "YAML")
      if File.file?(path)
        if Pathname.new(path).writable?
          File.open(path, "w") { |f| f.write conf.to_yaml }
          return true
        else
          script.store_call("$.announce.danger('Fatal Error: #{type} file is not writable!')")
        end
      else
        script.store_call("$.announce.danger('Fatal Error: #{type} file does not exist!')")
      end
      return false
    end
  end
end
