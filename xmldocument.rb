require 'nokogiri'
require 'csv'
require 'byebug'

class CatalogFilter < Nokogiri::XML::SAX::Document

  def initialize
    @event_arr = []
    @data_arr = []
  end

  def start_element(name, attributes = [])    
    @data_arr << name     

    if name == 'Schedule'
      if attributes[3][0] == "scheduleStart"   
        @start_time = attributes[3][1].split("T")         
      end
    end

    if name == 'EventData' 
      if attributes[0][1] == "Primary"
        @event = { :Segment => '1', :Media => 'Primary', :Offset => ''} 
      end
    end
  end

   def characters(string) 
    if @data_arr.last == 'pmcp:Name'
        @channel_name = string
    end

    if !@event.nil?

      if @data_arr.last == 'SmpteTimeCode' && @data_arr[-2] == 'SmpteDateTime' && @data_arr[-3] == 'StartDateTime' 
        @event[:Hour] = string

      elsif @data_arr.last == 'SmpteTimeCode' && @data_arr[-2] == 'SmpteDuration' && @data_arr[-3] == 'Duration'
        @event[:Duration] = string

      elsif @data_arr.last == 'HouseNumber' && @data_arr[-2] == 'ContentId' && @data_arr[-3] == 'Content'
        @event[:Asset] = string

      elsif @data_arr.last == 'Name' && @data_arr[-2] == 'Content'
        @event[:Name] = string

      elsif @data_arr.last == 'ContentType' && @data_arr[-2] == 'ProgramContent' && @data_arr[-3] == 'ContentDetail'
        @event[:Type] = string
        
      elsif @data_arr.last == 'Details' && @data_arr[-2] == 'PrivateInformation'
        @event[:Type] = string
      end
    end
  end

  def end_element name     
    @data_arr.pop
     if !@event.nil?
      if name == 'Content'
        @event_arr << @event  
        @event = {}      
      elsif name == 'Schedule'
        to_csv
        puts "CSV is created"
      end
    end 
  end

  def to_csv  
    
    CSV.open('output.csv', 'wb') do |row|
      row << [@start_time[0], @start_time[1] ,'Channel Name', @channel_name]
      row << ['Hour', 'Duration', 'Offset', 'Segment ID', 'Asset IT', 'Type', 'Media Type', 'Title', 'Subtitle', 'Comments', 'Reconcile ID', 'Start time type', 'Audios_Expected', 'Subtitle_Expected', 'Audios_Rule', 'Subtitle_Rule', 'Show MetaData']        
      @event_arr.each do |co|
         row << [co[:Hour], co[:Duration],co[:Offset], co[:Segment], co[:Asset], co[:Type], co[:Media], co[:Name]]
      end
    end
  end
end

doc = Nokogiri::XML::SAX::Parser.new(CatalogFilter.new)
doc.parse(File.read('/Users/innoventes/Downloads/sample_playlist(1)(1).xml'))


