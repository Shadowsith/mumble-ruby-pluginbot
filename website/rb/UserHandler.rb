require "yaml"

module Bot
  module IUserHandler
    class Config
      FILE = "/../login.yml"
      PATH = File.dirname(File.expand_path(__FILE__)) + FILE
    end

    def addUser(post, session)
      if (session[:isAdmin] == true)
        conf = YAML.load_file(Config::PATH)
      end
    end

    def getCurUsr(conf, session)
      data = {}
      pos = 0
      usr = ""
      conf["login"].each do |u|
        if (session[:usr] == u["usr"])
          usr = u
          break
        end
        pos += 1
      end
      data[:usr] = usr
      data[:pos] = pos
      return data
    end

    def changeUserSettings(post, session)
      conf = YAML.load_file(Config::PATH)
      data = getCurUsr(post, session)
      usr = data[:usr]
      usr["email"] = post[:email]

      conf["login"][data[:pos]] = usr
    end

    def registerUser(post, session)
      if (session[:isAdmin] == true)
      end

      conf = YAML.load_file(Config::PATH)
    end

    def deleteUser(post, session)
      if (session[:isAdmin] == true)
        conf = YAML.load_file(Config::PATH)
      end
    end
  end
end

class Test
  include Bot::IUserHandler
end

puts Test.new.changeUserSettings("")
