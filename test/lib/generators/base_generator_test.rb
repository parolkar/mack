require File.dirname(__FILE__) + '/../../test_helper.rb'

class BaseGeneratorTest < Test::Unit::TestCase
  
  class SimpleGenerator < Mack::Generator::Base
    require_param :name
    require_param :id
    
    def generate
      simple_gen_dir = File.join(MACK_ROOT, "test", "simple_gen")
      directory(simple_gen_dir)
      template_dir = File.join(File.dirname(__FILE__), "templates")
      template(File.join(template_dir, "hello_world.rb.template"), File.join(simple_gen_dir, "hello_world.rb"))
      template(File.join(template_dir, "goodbye_world.rb.template"), File.join(simple_gen_dir, "goodbye_world.rb"), :force => true)
    end
    
  end
  
  class BadGenerator < Mack::Generator::Base
  end
  
  def setup
    if File.exists?(simple_gen_dir)
      FileUtils.rm_r(simple_gen_dir)
    end
  end
  
  def teardown
    if File.exists?(simple_gen_dir)
      FileUtils.rm_r(simple_gen_dir)
    end
  end
  
  def test_require_param
    assert_raise(Mack::Errors::RequiredGeneratorParameterMissing) { SimpleGenerator.new }
    assert_raise(Mack::Errors::RequiredGeneratorParameterMissing) { SimpleGenerator.new("name" => :foo) }
    assert_raise(Mack::Errors::RequiredGeneratorParameterMissing) { SimpleGenerator.new("id" => 1) }
    sg = SimpleGenerator.new("name" => :foo, "id" => 1)
    assert_not_nil sg
    assert_equal 1, sg.param(:id)
    assert_equal :foo, sg.param(:name)
  end
  
  def test_run
    bg = BadGenerator.new
    assert_raise(MethodNotImplemented) { bg.run }
    assert_raise(MethodNotImplemented) { bg.generate }
  end
  
  def test_directory
    assert !File.exists?(simple_gen_dir)
    sg = SimpleGenerator.new("name" => :foo, "id" => 1)
    sg.run
    assert File.exists?(simple_gen_dir)
    # run it again to prove we don't get any errors if the folder already exists
    sg.run
    assert File.exists?(simple_gen_dir)
  end
  
  def test_template
    assert !File.exists?(File.join(simple_gen_dir, "hello_world.rb"))
    sg = SimpleGenerator.new("name" => "Mark", "id" => 1)
    sg.run
    assert File.exists?(File.join(simple_gen_dir, "hello_world.rb"))
    File.open(File.join(simple_gen_dir, "hello_world.rb"), "r") do |f|
      assert_equal "Hello Mark\n", f.read
    end
  end
  
  def test_template_force
    assert !File.exists?(File.join(simple_gen_dir, "goodbye_world.rb"))
    sg = SimpleGenerator.new("name" => "Mark", "id" => 1)
    sg.run
    assert File.exists?(File.join(simple_gen_dir, "goodbye_world.rb"))
    File.open(File.join(simple_gen_dir, "goodbye_world.rb"), "r") do |f|
      assert_equal "Goodbye cruel world! Love, Mark\n", f.read
    end
    
    File.open(File.join(simple_gen_dir, "goodbye_world.rb"), "w") do |f|
      f.puts "I've been edited."
    end
    
    File.open(File.join(simple_gen_dir, "goodbye_world.rb"), "r") do |f|
      assert_equal "I've been edited.\n", f.read
    end
    
    sg.run
    
    File.open(File.join(simple_gen_dir, "goodbye_world.rb"), "r") do |f|
      assert_equal "Goodbye cruel world! Love, Mark\n", f.read
    end
  end
  
  private
  def simple_gen_dir
    File.join(MACK_ROOT, "test", "simple_gen")
  end
  
end