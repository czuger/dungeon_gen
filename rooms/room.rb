require_relative 'room_element'

class Room

  def initialize
    @elements = []
  end

  def set_cases( cases )
    @elements.each do |element|
      cases[ element.position.hash_key ] = element.element_type
    end
  end

end