
# emulating ActiveSupport's camelize and constantize
class String
    def camelize()
      self.dup.split(/_/).map{ |word| word.capitalize }.join('')
    end

    def constantize()
    	self.split("::").inject(Module) {|acc, val| acc.const_get(val)}
  	end
end