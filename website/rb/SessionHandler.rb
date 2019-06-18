require "date"
require_relative "./UserHandler.rb"

module Bot
  module SessionHandler
    include UserHandler

    def self.loginProtection(session)
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

    def self.login(app, session, params)
      if self.loginProtection(session)
        usr = params[:username]
        pwd = params[:password]
        if (app.yml.login(usr, pwd))
          session[:login_counter] = 0
          session[:login] = true
          session[:usr] = usr
          session[:admin] = app.getCurUsr(session)[:usr]["isAdmin"]
          app.yml.setSession(session)
          app.yml.setBot(session)
          app.script.store_call("$.announce.success('Logged In!');")
          app.redirect "/index"
        else
          app.script.store_call(
            "$.announce.danger('User or password was not correct!');"
          )
          app.redirect "/login"
        end
      else
        app.script.store_call(
          "$.announce.danger('To many tries! Wait for #{session[:login_next_try]} minutes');"
        )
        app.redirect "/login"
      end
    end

    def self.logout(session)
      session[:login] = false
      session[:usr] = nil
      session[:admin] = nil
      session[:email] = nil
      session[:login_counter] = 0
    end
  end
end
