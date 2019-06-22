require "mumble-ruby"
require_relative "../../helpers/conf.rb"

module Bot
  class WebConsole
    private

    @@cmd = Struct.new(:event, :target, :msg)

    public

    attr_accessor :web_console

    def initialize()
      @web_console = "Web_Console"
      @cli = Mumble::Client.new("maypi") do |conf|
        conf.username = "Web_Console"
        conf.password = Conf.gvalue("mumble:password")
      end
    end

    def connect()
      @cli.connect
      sleep 2
      while not @cli.connected?
        sleep(0.5)
        max_connecting_time -= 1
        if max_connecting_time < 1
          @cli.disconnect
          break
        end
      end
      @cli.on_connected do
        @cli.join_channel(Conf.gvalue("mumble:channel"))
        run()
      end
    end

    def disconnect()
      @cli.disconnect
    end

    # TODO run in new task
    def run()
      while true
        sleep 0.5
        execCmd()
      end
    end

    def execCmd()
      case @@cmd.event
      when "msg_user"
        @cli.text_user(@@cmd.target, @@cmd.msg)
      when "msg_channel"
        @cli.text_channel(@@cmd.target, @@cmd.msg)
      end
      @@cmd.attributes.each { |a| a = "" }
    end

    def getUser()
      arr = []
      i = 0
      for obj in @cli.users.values
        arr[i] = { :name => obj.name,
                  :id => obj.id }
        i = i + 1
      end
      return arr
    end

    def getChannels()
      arr = []
      i = 0
      for obj in @cli.channels.values
        arr[i] = { :name => obj.name }
        i = i + 1
      end
      return arr
    end
  end
end
