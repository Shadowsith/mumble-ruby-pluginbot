require "digest"

module Bot
  module UserHandler
    class Config
      FILE = "/../login.yml"
      PATH = File.dirname(File.expand_path(__FILE__)) + FILE
    end

    def addUser(post, session)
      if (session[:admin] == true)
        conf = yml.loadFile(Config::PATH)
      end
    end

    def getAllUsr(session)
      if (session[:admin] == true)
        conf = yml.loadFile(Config::PATH)
      end
    end

    def getCurUsr(session, conf = "")
      conf = yml.loadFile(Config::PATH) if conf == ""
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
      if File.exists?(Config::PATH)
        puts post
        conf = yml.loadFile(Config::PATH)
        data = getCurUsr(session, conf)
        usr = data[:usr]
        if post[:email] != ""
          usr["email"] = post[:email]
        end
        if post[:changePw] == "on"
          if post[:oldpw] != "" && post[:newpw] != "" && post[:newpwrpt] != ""
            if Digest::SHA512.hexdigest(post[:oldpw]) == usr["pwd"]
              if post[:newpw] == post[:newpwrpt]
                usr["pwd"] = Digest::SHA512.hexdigest(post[:newpw])
              else
                script.store_call("$.announce.danger('New password is not the same!')")
                return
              end
            else
              script.store_call("$.announce.danger('Old password is not correct!')")
              return
            end
          else
            script.store_call("$.announce.danger('Fields for changing password are empty!')")
            return
          end
        end
        conf["login"][data[:pos]] = usr
        File.open(Config::PATH, "w") { |f| f.write conf.to_yaml }
        session[:email] = post[:email]
        script.store_call("$.announce.success('User settings changed successfully')")
      else
        script.store_call("$.announce.danger('Critical Error: User settings does not exist anymore!')")
      end
    end

    def registerUser(post, session)
      if (session[:admin] == true)
      end

      conf = yml.loadFile(Config::PATH)
    end

    def deleteUser(post, session)
      if (session[:admin] == true)
        conf = yml.loadFile(Config::PATH)
      end
    end
  end
end
