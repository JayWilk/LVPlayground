function getElementsInDimension(theType, dimension)
    local elementsInDimension = { }
      for key, value in ipairs(getElementsByType(theType)) do
        if getElementDimension(value)==dimension then
        table.insert(elementsInDimension,value)
        end
      end
      return elementsInDimension
end

function getXMLNodes(parent, nodename)
   local xml = xmlLoadFile(xmlfile)
   if xml then
      local ntable={}
      local a = 0
      while xmlFindChild(xml,nodename,a) do
         table.insert(ntable,a+1)
         ntable[a+1]={}
         local attrs = xmlNodeGetAttributes ( xmlFindChild(xml,nodename,a) )
         for name,value in pairs ( attrs ) do
            table.insert(ntable[a+1],name)
            ntable[a+1][name]=value
         end
         
         ntable[a+1]["nodevalue"]=xmlNodeGetValue(xmlFindChild(xml,nodename,a))
 
         a=a+1
      end
      return ntable
   else
      return {}
   end
end
