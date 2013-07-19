require 'rbconfig'

module DVR
  module Diff
    def self.diff
      @diff = if (RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ &&
                  system("diff.exe", __FILE__, __FILE__)) then
                "diff.exe -u"
              #elsif Minitest::Test.maglev? then
                #"diff -u"
              elsif system("gdiff", __FILE__, __FILE__)
                "gdiff -u" # solaris and kin suck
              elsif system("diff", __FILE__, __FILE__)
                "diff -u"
              else
                nil
              end unless defined? @diff

      @diff
    end

    ##
    # Returns a diff between +exp+ and +act+. If there is no known
    # diff command or if it doesn't make sense to diff the output
    # (single line, short output), then it simply returns a basic
    # comparison between the two.

    def diff exp, act
      require "tempfile"

      expect = mu_pp_for_diff exp
      butwas = mu_pp_for_diff act
      result = nil

      need_to_diff = true
        #Minitest::Assertions.diff &&
        #(expect.include?("\n")    ||
         #butwas.include?("\n")    ||
         #expect.size > 30         ||
         #butwas.size > 30         ||
         #expect == butwas)

      return "Expected: #{mu_pp exp}\n  Actual: #{mu_pp act}" unless
        need_to_diff

      Tempfile.open("expect") do |a|
        a.puts expect
        a.flush

        Tempfile.open("butwas") do |b|
          b.puts butwas
          b.flush

          result = `#{DVR::Diff.diff} #{a.path} #{b.path}`
          result.sub!(/^\-\-\- .+/, "--- expected")
          result.sub!(/^\+\+\+ .+/, "+++ actual")

          if result.empty? then
            klass = exp.class
            result = [
                      "No visible difference in the #{klass}#inspect output.\n",
                      "You should look at the implementation of #== on ",
                      "#{klass} or its members.\n",
                      expect,
                     ].join
          end
        end
      end

      result
    end

    ##
    # This returns a human-readable version of +obj+. By default
    # #inspect is called. You can override this to use #pretty_print
    # if you want.

    def mu_pp obj
      if obj.respond_to?(:each)
        JSON.pretty_generate(obj)
      else
        s = obj.inspect
        s = s.encode Encoding.default_external if defined? Encoding
        s
      end
    end

    ##
    # This returns a diff-able human-readable version of +obj+. This
    # differs from the regular mu_pp because it expands escaped
    # newlines and makes hex-values generic (like object_ids). This
    # uses mu_pp to do the first pass and then cleans it up.

    def mu_pp_for_diff obj
      mu_pp(obj).gsub(/\\n/, "\n").gsub(/:0x[a-fA-F0-9]{4,}/m, ':0xXXXXXX')
    end

  end
end
