require "mumble-ruby"
require_relative "../../helpers/conf.rb"

module Bot
  class WebConsole
    private

    @@isStarted = false

    public

    # attr_accessor :cli

    def initialize()
      @cli = Mumble::Client.new("maypi") do |conf|
        conf.username = "Web_Console"
        conf.password = Conf.gvalue("mumble:password")
      end
    end

    def started?
      return @@isStarted
    end

    def connect()
      @cli.connect
      max_connecting_time = 10
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
        @@isStarted = true
      end
    end

    def disconnect()
      @cli.disconnect if @cli.connected?
      @@isStarted = false
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

    def handleLaunch(post)
      if post[:launch] == "start"
        puts "start console"
        connect()
      else
        disconnect()
      end
    end

    def handleMsg(post)
      if @cli.connected?
        post[:event] = "to_channel"
        case post[:event]
        when "to_user"
          # @cli.text_user(usr, msg)
        when "to_channel"
          @cli.text_channel("Root", post[:msg])
        end
      end
    end
  end
end
