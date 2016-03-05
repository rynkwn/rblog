module Rubyutils
  
  # Try to return the value of an expression.
  # @param expr A proc to evaluate.
  # @param arg The argument to pass to proc.
  # @param exception The expected exception.
  # @return If expr raises an exception, return nil. Else return the value of
  # the expression.
  def Rubyutils.try_return(expr, arg, exception)
    begin
      return expr.call(arg)
    rescue Exception => exception
      return nil
    end
  end
end