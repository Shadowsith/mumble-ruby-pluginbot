module Bot
  module LaunchControl
    class Config
      PATH = File.dirname(File.expand_path(__FILE__))
    end

    def start_bots
      `#{Config::PATH}/../../scripts/manage.sh start`
    end

    def stop_bots
      `#{Config::PATH}/../../scripts/manage.sh stop`
    end

    def update_ytdl
      `#{Config::PATH}/../../scripts/manage.sh uytdl`
    end

    def status_bots
      out = `#{Config::PATH}/../../scripts/manage.sh status`
      puts out
    end
  end
end
