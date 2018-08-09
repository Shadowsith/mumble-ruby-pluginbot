class TextToSpeech < Plugin

    def init(init)
        super
        logger("INFO: INIT plugin #{self.class.name}.")
        @@bot[:bot] = self
        return @@bot
    end 

    def name
        self.class.name
    end 

    #TODO
    def help(h)
        h << "<hr><span style='color:red;'>Plugin #{self.class.name}</span><br>"
        h << "<b>#{Conf.gvalue("main:control:string")}say</b> - test command.<br>"
        h   
    end 

    #TODO
    def handle_chat(msg, message) 
        super
        if message == "say"
            actor = msg.actor
            name = msg.username
            messageto(actor, name)
        end 
    end 
end
