module Callable

  class CallableError < StandardError; end

  def call
    fail NotImplementedError
  end

  module ClassMethods

    def call(*args)
      new.(*args)
    end

    def method_added(method_name)
      return if method_name == :call || !public_method_defined?(method_name)

      fail CallableError, "invalid method name #{method_name}, " \
                          'only public method allowed is "call"'
    end

  end

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

end
