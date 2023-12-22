module Describe
  def Describe.included(mod)
    # it's a no-op if we're not testing
    class << mod
      define_method(:describe) { |label, &blk| }
    end
    return unless $test

    # otherwise inline test
    require "minitest/spec"
    require "rspec/expectations/minitest_integration"
    require "minitest/autorun"

    mod.const_set "Spec", Class.new(Minitest::Spec)
    class << mod
      define_method(:describe) do |label, &blk|
        const_get("Spec").class_eval do
          it(&blk)
        end
      end
    end
  end
end