module ProcessHelper
	def extract_tags(s)
		return s.{ |tag| 
			tag.downcase
		}	
	end
end