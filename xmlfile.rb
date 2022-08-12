require 'nokogiri'
require 'csv'
require 'byebug'



class CatalogFilter < Nokogiri::XML::SAX::Document

    def initialize
      
      @customer_arr = []
      @data_arr = []
      @full_address = ''
   
      puts "Checking for tags"
    end

    def start_element(name, attributes = [])
      
      
      @data_arr << name
      
      if name == 'Customer' 
              @customer = { :Company => ''  } 
                                                                        
      end

    end

    def characters(string)
      
    
      if @data_arr.last == 'CompanyName'
        @customer[:Company] = string

      elsif @data_arr.last == 'ContactName'
        @customer[:Contact] = string
  
      elsif @data_arr.last == 'ContactTitle'
        @customer[:Title] = string

      elsif @data_arr.last == 'Phone'
        @customer[:Phone] = string

      elsif @data_arr.last =='Address'
        @customer[:FullAddress] = string

      elsif @data_arr.last == 'City'
        @customer[:FullAddress] += " #{string}"

      elsif @data_arr.last == 'Region'
        @customer[:FullAddress] += " #{string}"

      elsif @data_arr.last == 'PostalCode'
        @customer[:FullAddress] += " #{string}"

      elsif @data_arr.last == 'Country'
        @customer[:FullAddress] += " #{string}"
      end
      

    end


    def end_element name
      
      @data_arr.pop

      if name == 'Customer'
        @customer_arr << @customer   
      
      
      elsif name == 'Root'
        
        to_csv

        puts "CSV is created"
      end

    end

    
    def to_csv  
      CSV.open('output.csv', 'wb') do |row|
        row << ['CompanyName', 'ContactName', 'ContactTitle', 'Phone', 'FullAddress']
        @customer_arr.each do |co|
        row << [co[:Company], co[:Contact],co[:Title], co[:Phone], co[:FullAddress]]
        end
      
       end
      
    end
end

doc = Nokogiri::XML::SAX::Parser.new(CatalogFilter.new)
doc.parse(File.read('/Users/innoventes/Downloads/sample_CustomersOrders.xml'))


