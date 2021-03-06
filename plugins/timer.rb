class Timer < Plugin

  def init(init)
    super
    logger("INFO: INIT plugin #{self.class.name}.")
    @nextalarm = 0
    @alarmlist = {}
    @@bot[:bot] = self
    return @@bot
  end

  def ticks(time)
    @alarmlist.each do | alarm, user |
      if ( alarm <= time.to_i )
        begin
          if ( (alarm + 10) >= time.to_i )
            @@bot[:cli].text_user(user, "Wake up!")
          else
            @@bot[:cli].text_user(user, "You are late!") if (time.to_i % 30) == 0
          end
        rescue
          logger("DEBUG: Alarm deleted, user not found on server (#{$!})")
          @alarmlist.delete(alarm)
        end
      end
    end
  end

  def name
    self.class.name
  end

  def help(h)
    h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
    h << "<b>#{Conf.gvalue("main:control:string")}alarms</b> - #{I18n.t("plugin_timer.help.alarms")}.<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}alarm_set <i>(HH:)MM</i></b> - #{I18n.t("plugin_timer.help.alarm_set")}<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}alarm_del <i>timecode</i></b> -#{I18n.t("plugin_timer.help.alarm_del")}<br>"
    h << "<b>#{Conf.gvalue("main:control:string")}alarm_quit</b> - #{I18n.t("plugin_timer.help.alarm.quit")}<br>"
    h
  end

  def handle_chat(msg, message)
    super
    if message == "alarms"
      @alarmlist.each do | time, user |
        privatemessage(I18n.t("plugin_timer.alarms" , :user => user, :time => Time.at(time).strftime("%H:%M:%S %e.%m.%Y"), :timecode => time))
      end
    end

    if message[0..8] == 'alarm_set'
      seekto = case message.count ":"
      when 0 then         # Minutes
        if message.match(/^alarm_set [0-9]{1,3}$/)
          result = message.match(/^alarm_set ([0-9]{1,3})$/)[1].to_i
        else
          return 0
        end
      when 1 then         # Hours:Minutes
        if message.match(/^alarm_set ([0-5]?[0-9]:[0-5]?[0-9])/)
          time = message.match(/^alarm_set ([0-5]?[0-9]:[0-5]?[0-9])/)[1].split(/:/)
          result = time[0].to_i * 60 + time[1].to_i
        end
      end
      result = (Time.now + result * 60).to_i
      while @alarmlist[result]!=nil
        result += 1
      end
      @alarmlist[result] = msg.actor
      privatemessage(I18n.t("plugin_timer.alarm_set", :result => result , :time => Time.at(result).strftime("%H:%M:%S %e.%m.%Y") ))
    end

    if message[0..8] == "alarm_del"
      if message.match(/^alarm_del [0-9]{1,10}$/)
        result = message.match(/^alarm_del ([0-9]{1,10})$/)[1].to_i
        if @alarmlist[result] == msg.actor
          @alarmlist.delete(result)
          privatemessage(I18n.t("plugin_timer.alarm_del.deleted"))
        else
          privatemessage(I18n.t("plugin_timer.alarm_del.error"))
        end
      end
    end

    if message == "alarm_quit"
      @alarmlist.each do | alarm, user |
        @alarmlist.delete(alarm) if ( user == msg.actor ) and ( alarm <= Time.now.to_i)
      end
    end
  end
end
