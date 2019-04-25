module Bot
  class EClass
  end

  # requires jquery
  class EScript
    private

    @@tag = "<script>%s</script>"
    @@jquery_rdy = "$(document).ready(function() {%s});"
    @@func = []
    @@calls = []
    @@classes = []

    def pre_build()
      script = ""
      @@classes.each { |cl| script += "#{cl} " }
      @@func.each { |f| script += "#{f} " }
      return script
    end

    def build()
      script = pre_build()
      @@calls.each { |c| script += "#{c} " }
      return script
    end

    def build_rdy()
      script = ""
      @@calls.each { |c| script += "#{c}" }
      rdy = @@jquery_rdy % script
      rdy += " #{pre_build()}"
      return rdy
    end

    public

    def store_class(cl)
      @@classes.push(cl)
    end

    def store_func(func)
      @@func.push(func)
    end

    def store_call(statement)
      @@calls.push(statement)
    end

    def clear_all()
      @@classes.clear()
      @@func.clear()
      @@calls.clear()
      return ""
    end

    def clear_classes()
      @@classes.clear()
      return ""
    end

    def clear_funcs()
      @@func.clear()
      return ""
    end

    def clear_calls()
      @@calls.clear()
      return ""
    end

    def min()
    end

    def self::call(script)
      @@tag % script
    end

    def self::call_rdy(script)
      @@tag % @@jquery_rdy % script
    end

    def call(script)
      @@tag % script
    end

    def call()
      @@tag % self.build()
    end

    def call_rdy(script)
      @@tag % script
    end

    def call_rdy()
      @@tag % build_rdy()
    end
  end
end
