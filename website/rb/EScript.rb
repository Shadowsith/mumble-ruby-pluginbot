module Bot
  class EClass
    private

    @@script = "class %s { constructor() { %s } %s }"

    @@name = ""
    @@attrs = []
    @@static_methods = []
    @@methods = []

    public

    def initialize(name, attr = nil)
      @@name = name
      attr.each { |a| @@attrs.push(a) } if attr != nil
    end

    def store_attr(attr)
      @@attrs.push(attr)
    end

    def store_method(method)
      @@methods.push(method)
    end

    def store_static_method(method)
      @@static_methods.push(method)
    end

    def clear_all()
      @@attrs.clear()
      @@methods.clear()
      @@static_methods.clear()
    end

    def clear_attrs()
      @@attrs.clear()
    end

    def clear_methods()
      @@methods.clear()
    end

    def clear_static_methods()
      @@static_methods.clear()
    end

    def parse()
      attrs = ""
      methods = ""
      @@attrs.each { |a| attrs += "this.#{a}; " }
      @@methods.each { |m| methods += "#{m} " }
      @@static_methods.each do |m|
        m.to_s.strip!
        if m[0..5] != "static"
          methods += "static #{m} "
        else
          methods += "#{m} "
        end
      end

      return @@script % [@@name, attrs, methods]
    end
  end

  # requires jquery
  class EScript
    private

    @@tag = "<script>%s</script>"

    @@func = []
    @@calls = []
    # here store EClass objects
    @@classes = []

    # if using jquery
    @@jquery_rdy = "$(document).ready(function() {%s});"

    # if using requirejs
    @@requirejs = []

    def pre_build()
      script = ""
      @@classes.each { |cl| script += "#{cl} " }
      @@func.each do |f|
        f.to_s.strip!
        if f[0..7] != "function"
          script += "function #{f} "
        else
          script += "#{f} "
        end
      end
      return script
    end

    def build()
      script = pre_build()
      @@calls.each { |c| script += "#{c}; " }
      return script
    end

    def build_rdy()
      script = ""
      @@calls.each { |c| script += "#{c}; " }
      rdy = @@jquery_rdy % script
      rdy += " #{pre_build()}"
      return rdy
    end

    public

    def store_class(cl)
      @@classes.push(cl.parse()) if cl.is_a?(EClass)
    end

    def store_func(func)
      @@func.push(func)
    end

    def store_call(statement)
      @@calls.push(statement)
    end

    def store_requirejs(requirement)
      @@requirejs.push(requirement)
    end

    def clear_all()
      @@classes.clear() if @@classes.length > 0
      @@func.clear() if @@func.length > 0
      @@calls.clear() if @@calls.length > 0
      @@requirejs.clear() if @@requirejs.length > 0
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

    def clear_requirejs()
      @@requirejs.clear()
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
