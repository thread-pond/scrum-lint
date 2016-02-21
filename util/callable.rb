# module to constrain interfaces of classes to just `call`
module Callable
  class CallableError < StandardError; end

  def call
    raise NotImplementedError
  end

  # `ClassMethods` defines a class level method `call` that delegates to
  # an instance. It also causes an error to be raised if a public instance
  # method is defined with a name other than `call`
  module ClassMethods
    def call(*args)
      new.(*args)
    end

    def method_added(method_name)
      return if method_name == :call || !public_method_defined?(method_name)

      raise CallableError, "invalid method name #{method_name}, " \
                          'only public method allowed is "call"'
    end
  end

  def self.included(base)
    base.public_send(:extend, ClassMethods)
  end
end
