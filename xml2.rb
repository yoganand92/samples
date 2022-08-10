require 'nokogiri'
require 'byebug'
class CatalogFilter < Nokogiri::XML::SAX::Document
    def start_document
    end

    def start_element(name, attrs = [])
        
        if (name == "Customers")
            @data = {}
        elsif (name == "Company_name")
            @key = :Company_name
            @data[key] = ' '
        elsif (name == "Contact_name")
            @key = :Contact_name
            @data[key] = ' '
        elsif (name == "Phone_number")
            @key = :Phone_number
            @data[key] = ' '
        end

    def characters(string)
        @data[@key] += str if (@key && @in_name)
        end
    end

    def end_element(name, attrs = [])
        if (name == "Customers")
            @data = nil
        elsif (name == "Company_name")
            @key = nil
        elsif (name == "Contact_name")
            @key = nil
        elsif (name == "Phone_number")
            @key = nil
    end

    def end_document
    end

end

parser = Nokogiri::XML::SAX::Parser.new(CatalogFilter.new)

parser.parse(File.open('/Users/innoventes/Downloads/sample_CustomersOrders.xml'))
end
