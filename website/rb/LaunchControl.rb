module Bot
  module LaunchControl
    def start_bots
      system("../../scripts/manage.sh start")
    end

    def stop_bots
      system("../../scripts/manage.sh stop")
    end

    def update_ytdl
      system("../../scripts/manage.sh uytdl")
    end

    def status_bots
      out = `../../scripts/manage.sh status`
    end
  end
end
