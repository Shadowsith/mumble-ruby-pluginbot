require "date"
require_relative "./UserHandler.rb"

module Bot
  module SessionHandler
    include UserHandler

    def loginProtection()
      if session[:login_counter] == nil
        session[:login_counter] = 0
      else
        session[:login_counter] += 1
      end
      if session[:timestamp] == nil
        session[:timestamp] = Time.now
      else
        if (Time.now - session[:timestamp]) / 60 > 5
          session[:login_counter] = 0
          session[:timestamp] = Time.now
        end
      end
      if session[:login_counter] >= 5
        session[:login_next_try] =
          5 - ((Time.now - session[:timestamp]) / 60).to_i
        return false
      end
      return true
    end

    def usrAdmin?()
    end

    def login(params)
      if loginProtection
        usr = params[:username]
        pwd = params[:password]
        if (yml.login(usr, pwd))
          session[:login_counter] = 0
          session[:login] = true
          session[:usr] = usr
          session[:admin] = getCurUsr(session)[:usr]["isAdmin"]
          yml.setSession(session)
          yml.setBot(session)
          script.store_call("$.announce.success('Logged In!');")
          redirect "/index"
        else
          script.store_call(
            "$.announce.danger('User or password was not correct!');"
          )
          redirect "/login"
        end
      else
        script.store_call(
          "$.announce.danger('To many tries! Wait for #{session[:login_next_try]} minutes');"
        )
        redirect "/login"
      end
    end

    def logout(session)
      session[:login] = false
      session[:usr] = nil
      session[:admin] = nil
      session[:email] = nil
      session[:login_counter] = 0
      script.store_call("$.announce.info('Logged Out!')")
    end
  end
end
