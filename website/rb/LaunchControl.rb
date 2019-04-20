module Bot
  module LaunchControl
    def getControlPath
      File.dirname(File.expand_path(__FILE__))
    end

    def start_bots
      `#{getControlPath}/../../scripts/manage.sh start`
    end

    def stop_bots
      `#{getControlPath}/../../scripts/manage.sh stop`
    end

    def update_ytdl
      `#{getControlPath}/../../scripts/manage.sh uytdl`
    end

    def status_bots
      out = `#{getControlPath}/../../scripts/manage.sh status`
      puts out
    end
  end
end
