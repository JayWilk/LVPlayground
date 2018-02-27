function getElementsInDimension(theType, dimension)
    local elementsInDimension = { }
      for key, value in ipairs(getElementsByType(theType)) do
        if getElementDimension(value)==dimension then
        table.insert(elementsInDimension,value)
        end
      end
      return elementsInDimension
end
