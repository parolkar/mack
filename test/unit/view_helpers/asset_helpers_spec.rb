require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "Asset Hosts" do
  include Mack::ViewHelpers::LinkHelpers
  
  describe "Stylesheet" do
    before(:all) do
      Mack::AssetHelpers.instance.reset!
    end
    
    it "should use default host if asset host is not defined" do
      stylesheet('foo').should == %{<link href="/stylesheets/foo.css" media="screen" rel="stylesheet" type="text/css" />\n}
    end
    
    it "should use app domain if specifed and even if asset host is defined" do
      temp_app_config("asset_hosts" => "http://assets.foo.com", 
                      "mack::distributed_site_domain" => "http://localhost:3001") do
        data = stylesheet('foo')
        data.should match(/localhost:3001/)
        data.should_not match(/assets.foo.com/)
      end
    end
    
    it "should use host defined in app config" do
      temp_app_config("asset_hosts" => "http://assets.foo.com") do
        stylesheet('foo').should == %{<link href="http://assets.foo.com/stylesheets/foo.css" media="screen" rel="stylesheet" type="text/css" />\n}
      end
    end
    
    it "should distribute host" do
      temp_app_config("asset_hosts" => "http://asset%d.foo.com") do
        stylesheet('foo').should match(/asset(0|1|2|3|4).foo.com/)
      end
    end
    
    it "should use max distribution defined in app config" do
      temp_app_config("asset_hosts" => "http://asset%d.foo.com", "asset_hosts_max_distribution" => "2") do
        stylesheet('foo').should match(/asset(0|1|2).foo.com/)
        stylesheet('foo').should_not match(/asset(3|4).foo.com/)
      end
    end
    
    it "should override app_config setting if asset host is set by calling setter in AssetHelpers" do
      temp_app_config("asset_hosts" => 'http://www.foo.com') do
        Mack::AssetHelpers.instance.asset_hosts="http://asset%d.foo.com"
        stylesheet('foo').should match(/asset(0|1|2|3|4).foo.com/)
      end
    end
    
    it "should take a proc for the asset host generator" do
      Mack::AssetHelpers.instance.asset_hosts = Proc.new { |source| 'asset.foo.com' }
      stylesheet('foo').should match(/asset.foo.com/)
    end
  end
  
  describe "Javascript" do
    before(:all) do
      Mack::AssetHelpers.instance.reset!
    end
    
    it "should use default host if asset host is not defined" do
      javascript('foo').should_not match(/http/)
    end
    
    it "should use app domain if specifed and even if asset host is defined" do
      temp_app_config("asset_hosts" => "http://assets.foo.com", 
                      "mack::distributed_site_domain" => "http://localhost:3001") do
        data = javascript('foo')
        data.should match(/localhost:3001/)
        data.should_not match(/assets.foo.com/)
      end
    end
    
    it "should use host defined in app config" do
      temp_app_config("asset_hosts" => "http://assets.foo.com") do
        javascript('foo').should match(/assets.foo.com/)
      end
    end
    
    it "should distribute host" do
      temp_app_config("asset_hosts" => "http://asset%d.foo.com") do
        javascript('foo').should match(/asset(0|1|2|3|4).foo.com/)
      end
    end
    
    it "should use max distribution defined in app config" do
      temp_app_config("asset_hosts" => "http://asset%d.foo.com", "asset_hosts_max_distribution" => "2") do
        javascript('foo').should match(/asset(0|1|2).foo.com/)
        javascript('foo').should_not match(/asset(3|4).foo.com/)
      end
    end
    
    it "should override app_config setting if asset host is set by calling setter in AssetHelpers" do
      temp_app_config("asset_hosts" => 'http://www.foo.com') do
        Mack::AssetHelpers.instance.asset_hosts="http://asset%d.foo.com"
        javascript('foo').should match(/asset(0|1|2|3|4).foo.com/)
      end
    end
    
    it "should take a proc for the asset host generator" do
      Mack::AssetHelpers.instance.asset_hosts = Proc.new { |source| 'asset.foo.com' }
      javascript('foo').should match(/asset.foo.com/)
    end
  end
  
end