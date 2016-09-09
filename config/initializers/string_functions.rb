class String
  def getArrScobes
    str = self
  	ids = []
  	id = ''
  	str.chars do |ch|
  		if ch != '[' and ch != ']'
  			id += ch
  		elsif ch == ']'
  			ids[ids.length] = id
  			id = ''
  		end
  	end
  	return ids
  end
end