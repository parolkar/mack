require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::FormHelpers do
  include Mack::ViewHelpers
  
  class Dilbert
    attr_accessor :created_at
  end
  
  class DilbertController
    include Mack::Controller
    
    
    def first
      @dilbert = Dilbert.new
      @dilbert.created_at = Time.parse("2008-8-16 15:35")
      render(:inline, "<%= :dilbert.date_time_select :created_at %>")
    end
    
    def second
      @time_found = params[:dilbert][:created_at]
      render(:text, @time_found.to_s)
    end
    
    def third
      @time_found = params[:updated_at]
      render(:text, @time_found.to_s)
    end
  end
  
  Mack::Routes.build do |r|
    r.with_options(:controller => :dilbert) do |map|
      map.dilbert_first "/dilbert/first", :action => :first
      map.dilbert_second "/dilbert/second", :action => :second, :method => :post
      map.dilbert_third "/dilbert/third", :action => :third, :method => :post
    end
  end
  
  before(:all) do
    @expected_time = Time.parse("2008-8-15 16:35")
    @expected_date = Time.parse("2008-8-24")
  end
  
  describe "date_time_select" do
    
    it "should generate 5 select tags by default" do
      @dilbert = Dilbert.new
      @dilbert.created_at = Time.parse("2008-8-16 19:35")
      date_time_select(:dilbert, :created_at).should == fixture("default_date_time_select.html")
    end
    
    it "should generate a label" do
      @dilbert = Dilbert.new
      @dilbert.created_at = Time.parse("2008-8-16 19:35")
      date_time_select(:dilbert, :created_at, :label => true).should == %{<label for="dilbert_created_at">Created at</label>} + fixture("default_date_time_select.html")
      
      date_time_select(:dilbert, :created_at, :label => "Created").should == %{<label for="dilbert_created_at">Created</label>} + fixture("default_date_time_select.html")
    end
    
    it "should generate seconds if told" do
      @dilbert = Dilbert.new
      @dilbert.created_at = Time.parse("2008-8-16 19:35:16")
      date_time_select(:dilbert, :created_at, :seconds => true).should == fixture("date_time_select_with_seconds.html")
    end
    
    it "should not show months if told" do
      @dilbert = Dilbert.new
      @dilbert.created_at = Time.parse("2008-8-16 19:35")
      date_time_select(:dilbert, :created_at, :months => false).should == fixture("date_time_select_without_months.html")
    end
    
    it "should use the override options if told" do
      @dilbert = Dilbert.new
      @dilbert.created_at = Time.parse("2008-8-16 19:35")
      years = []
      1999.upto(2010) {|y| years << [y, y]}
      date_time_select(:dilbert, :created_at, :months => false, :days => false, :hours => false, :minutes => false, :year_options => years).should == fixture("date_time_select_with_year_options.html")
    end
    
    it "should use the override values if told" do
      @dilbert = Dilbert.new
      @dilbert.created_at = Time.parse("2008-8-16 19:35")
      years = []
      # 1999.upto(2010) {|y| years << [y, y]}
      date_time_select(:dilbert, :created_at, :months => false, :days => false, :hours => false, :minutes => false, :year_values => 1999..2010).should == fixture("date_time_select_with_year_options.html")
    end
    
  end
  
  describe "date_select" do
    
    it "should generate just month/day/year" do
      @dilbert = Dilbert.new
      @dilbert.created_at = Time.parse("2008-8-16 19:35")
      date_select(:dilbert, :created_at).should == date_time_select(:dilbert, :created_at, :months => true, :days => true, :hours => false, :minutes => false)
    end
    
  end
  
  describe "params" do
    
    it "should be able to reconstitute a time from the date_time_select" do
      post dilbert_second_url, :dilbert => {"created_at(year)" => "2008", "created_at(month)" => "8", "created_at(day)" => "15",
                                            "created_at(hour)" => "16", "created_at(minute)" => "35"}
      response.should be_successful
      time_found = assigns(:time_found)
      time_found.to_s.should == @expected_time.to_s
      
      post dilbert_third_url, "updated_at(year)" => "2008", "updated_at(month)" => "8", "updated_at(day)" => "15",
                               "updated_at(hour)" => "16", "updated_at(minute)" => "35"
      response.should be_successful
      time_found = assigns(:time_found)
      time_found.to_s.should == @expected_time.to_s
      
      post dilbert_third_url, "updated_at(year)" => "2008", "updated_at(month)" => "8", "updated_at(day)" => "24"
      response.should be_successful
      time_found = assigns(:time_found)
      time_found.to_s.should == @expected_date.to_s
      
      post dilbert_third_url, "updated_at(year)" => "2008", "updated_at(month)" => "8"
      response.should be_successful
      time_found = assigns(:time_found)
      time_found.to_s.should == Time.parse("2008-8-1").to_s
      
      post dilbert_third_url, "updated_at(year)" => "2008"
      response.should be_successful
      time_found = assigns(:time_found)
      time_found.to_s.should == Time.parse("2008-1-1").to_s
      
      post dilbert_third_url, "updated_at(month)" => "8"
      response.should be_successful
      time_found = assigns(:time_found)
      time_found.to_s.should == Time.parse("2008-8-1").to_s
    end
    
  end
  
end