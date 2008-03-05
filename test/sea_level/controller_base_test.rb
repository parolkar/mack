require File.dirname(__FILE__) + '/../test_helper.rb'

class ControllerBaseTest < Test::Unit::TestCase
  
  def test_automatic_render_of_action
    get "/foo"
    assert_match "tst_home_page: foo: yummy", response.body
  end
  
  def test_render_text
    get "/hello_from_render_text"
    assert_match "hello", response.body
  end
  
  def test_render_action
    get "/foo_from_render_action"
    assert_match "tst_home_page: foo: rock!!", response.body
  end
  
  def test_blow_from_bad_render_action
    assert_raise(Errno::ENOENT) { get "/blow_from_bad_render_action" }
  end
  
  def test_blow_up_from_double_render
    assert_raise(Mack::Errors::DoubleRender) { get "/blow_up_from_double_render" }
  end
  
  def test_no_action_in_cont_served_from_disk
    get "/tst_another/no_action_in_cont_served_from_disk"
    assert_match "hello from: no_action_in_cont_served_from_disk", response.body
  end
  
  def test_no_action_in_cont_served_from_public
    get "/tst_another/no_action_in_cont_served_from_public"
    assert_response :success
    assert_match "hello from: no_action_in_cont_served_from_public", response.body
    # because it's being served from the public directory we shouldn't wrap a layout around it.
    # assert !response.body.match("<title>Application Layout</title>") 
  end
  
  def test_basic_redirect_to
    get "/tst_home_page/world_hello"
    assert_response :redirect
    assert_response 302
    assert_redirected_to("/hello/world")
    assert_match "Hello World", response.body
  end
  
  def test_external_redirect_to
    get "/tst_home_page/yahoo"
    assert_response :redirect
    assert_response 301
    assert_redirected_to("http://www.yahoo.com")
    # assert_match "<title>Yahoo!</title>", response.body
  end
  
  def test_server_side_redirect_to
    get "/tst_home_page/server_side_world_hello"
    assert_response :success
    assert_match "Hello World", response.body
  end
  
end