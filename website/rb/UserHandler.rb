require "digest"
require_relative "./FileHandler.rb"

module Bot
  module UserHandler
    include FileHandler

    class Config
      FILE = "/../login.yml"
      PATH = File.dirname(File.expand_path(__FILE__)) + FILE
    end

    # TODO could be lesser code with void-returns

    def addUser(post, session)
      conf = yml.loadFile(Config::PATH)
      if (curUsrAdmin?(session, conf))
        if (not inputsEmpty?(post, "add"))
          if (not userExists?(post[:usr], conf))
            if (post[:pwd] == post[:rptpwd])
              if (emailValidFormat?(post[:email]))
                admin = post[:admin] == "on"
                new = {
                  "usr" => post[:usr],
                  "email" => post[:email],
                  "pwd" => Digest::SHA512.hexdigest(post[:pwd]),
                  "isAdmin" => admin,
                }
                conf["login"] << new
                if FileHandler.tryWrite(Config::PATH, conf, script)
                  script.store_call(
                    "$.announce.success('User successfully added!')"
                  )
                end
              else
                script.store_call(
                  "$.announce.warning('Please enter a valid email!')"
                )
              end
            else
              script.store_call(
                "$.announce.warning('Passwords are not the same!')"
              )
            end
          else
            script.store_call(
              "$.announce.warning('User already exists!')"
            )
          end
        end
      else
        script.store_call(
          "$.announce.warning('Some inputs are empty!')"
        )
      end
    end

    def inputsEmpty?(post, event)
      case (event)
      when "add"
        if (post[:usr].empty? || post[:email].empty? ||
            post[:pwd].empty? || post[:rptpwd].empty?)
          return true
        end
      when "delete"
      end
      return false
    end

    def userExists?(usr, conf)
      conf["login"].each do |u|
        return true if usr == u["usr"]
      end
      return false
    end

    def curUsrAdmin?(session, conf = "")
      if (session[:admin] == true)
        conf = yml.loadFile(Config::PATH) if conf == ""
        conf["login"].each do |u|
          if (u["usr"] == session[:usr])
            return true if u["isAdmin"] == true
          else
            return false
          end
        end
      end
      return false
    end

    def getAllUsr(session)
      conf = yml.loadFile(Config::PATH)
      data = getCurUsr(session, conf)
      if (session[:admin] == true && data[:usr]["isAdmin"] == true)
        usr = []
        conf["login"].each do |u|
          usr << u
        end
      end
      return usr
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
              script.store_call(
                "$.announce.danger('New password is not the same!')"
              )
              return
            end
          else
            script.store_call(
              "$.announce.danger('Old password is not correct!')"
            )
            return
          end
        else
          script.store_call(
            "$.announce.danger('Fields for changing password are empty!')"
          )
          return
        end
        conf["login"][data[:pos]] = usr
        if FileHandler.tryWrite(Config::PATH, conf, script)
          session[:email] = post[:email]
          script.store_call(
            "$.announce.success('User settings changed successfully')"
          )
        end
      else
        script.store_call(
          "$.announce.danger" +
          "('Critical Error: User settings does not exist anymore!')"
        )
      end
    end

    def emailValidFormat?(email)
      return email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
    end

    def changeUsrByAdmin(post, session)
      conf = yml.loadFile(Config::PATH)
      if (curUsrAdmin?(session, conf))
        if (userExists?(post[:usr], conf))
          if (post[:pwd] == post[:rptpwd])
            if (emailValidFormat?(post[:email]) || post[:email].empty?)
              conf["login"].each do |u|
                if u["usr"] == post[:usr]
                  u["usr"] = post[:new] if not post[:new].empty?
                  u["email"] = post[:email] if not post[:email].empty?
                  u["pwd"] = Digest::SHA512.hexdigest(post[:pwd])
                  u["isAdmin"] = post[:admin] == "on"
                  break
                end
              end
              if FileHandler.tryWrite(Config::PATH, conf, script)
                script.store_call("$.announce.success('User changed!')")
              end
            else
              script.store_call(
                "$.announce.warning('Please enter a valid email!')"
              )
            end
          else
            script.store_call("$.announce.warning('Passwords are not equal!')")
          end
        else
          script.store_call("$.announce.danger('User does not exist!')")
        end
      end
    end

    def deleteUser(post, session)
      conf = yml.loadFile(Config::PATH)
      if (curUsrAdmin?(session, conf) && post[:usr] != session[:usr])
        if (userExists?(post[:usr], conf))
          conf["login"].each do |u|
            if u["usr"] == post[:usr]
              conf["login"].delete(u)
              break
            end
          end
          if FileHandler.tryWrite(Config::PATH, conf, script)
            script.store_call("$.announce.success('User deleted!')")
          end
        else
          script.store_call("$.announce.danger('User does not exist!')")
        end
      else
        script.store_call("$.announce.warning('You can not delete yourself!')")
      end
    end
  end
end
