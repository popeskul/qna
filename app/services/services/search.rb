module Services
  # Services Search
  class Search
    TYPES = %w[Question Answer User Comment]

    def self.search_by(query, type = nil)
      if query.empty?
        return []
      end

      TYPES.include?(type) ? Object.const_get(type).search(query) : ThinkingSphinx.search(query)
    end
  end
end
