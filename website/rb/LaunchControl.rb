module Bot
  module LaunchControl
    class Config
      PATH = File.dirname(File.expand_path(__FILE__))
    end

    def self.start_bots
      `#{Config::PATH}/../../scripts/manage.sh start`
    end

    def self.stop_bots
      `#{Config::PATH}/../../scripts/manage.sh stop`
    end

    def self.update_ytdl
      `#{Config::PATH}/../../scripts/manage.sh uytdl`
    end

    def self.status_bots
      out = `#{Config::PATH}/../../scripts/manage.sh status`
      puts out
    end
  end
end
