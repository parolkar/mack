require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

module RenderActionHelper
  def validate_content(file_name)
    body = File.read(File.join(File.dirname(__FILE__), "contents", file_name))
    response.body.should == body
  end
end

describe "render(:action)" do
  
  describe "erb" do
    include RenderActionHelper
    
    it "should render with a default layout" do
      get bart_html_erb_with_layout_url
      validate_content("action_erb_default_layout.txt")
    end

    it "should render with a special layout if told to do so" do
      get bart_html_erb_with_special_layout_url
      validate_content("action_erb_special_layout.txt")
    end

    it "should render with no layout if told to do so" do
      get bart_html_erb_without_layout_url
      response.body.should == "Bart Simpson: HTML, ERB\n"
    end

  end # erb
  
  describe "haml" do
    include RenderActionHelper
    
    it "should render with a default layout" do
      get maggie_html_haml_with_layout_url
      validate_content("action_haml_default_layout.txt")
    end

    it "should render with a special layout if told to do so" do
      get maggie_html_haml_with_special_layout_url
      validate_content("action_haml_special_layout.txt")
    end

    it "should render with no layout if told to do so" do
      get maggie_html_haml_without_layout_url
      response.body.should == "<div id='name'>Maggie Simpson</div>\n<div id='type'>HTML, HAML</div>\n"
    end

  end # haml
  
  describe "markaby" do
    include RenderActionHelper
    
    it "should render with a default layout" do
      get marge_html_markaby_with_layout_url
      validate_content("action_markaby_default_layout.txt")
    end

    it "should render with a special layout if told to do so" do
      get marge_html_markaby_with_special_layout_url
      validate_content("action_markaby_special_layout.txt")
    end

    it "should render with no layout if told to do so" do
      get marge_html_markaby_without_layout_url
      response.body.should == "<div><h1>Marge Simpson</h1><h2>HTML, MARKABY</h2></div>"
    end

  end # markaby
  
end