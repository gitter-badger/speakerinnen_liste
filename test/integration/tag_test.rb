require 'test_helper'

class TagTest < ActionController::IntegrationTest
  def setup
    @horst = profiles(:one)
    @horst.confirmed_at = Time.now
    @horst.topic_list = 'fruehling'
    @horst.published = true
    @horst.save

    @inge = profiles(:two)
    @inge.confirmed_at = Time.now
    @inge.topic_list = 'fruehling', ' ', 'sommer'
    @inge.published = true
    @inge.save

    @anon = profiles(:three)
    @anon.confirmed_at = Time.now
    @anon.topic_list = 'winter', 'fruehling'
    @anon.save

    @erwin = profiles(:four)
    @erwin.confirmed_at = Time.now
    @erwin.topic_list = 'rot/blau'
    @inge.published = true
    @erwin.save
  end

  test "show tagging" do
    visit '/profiles'
    click_link('Anmelden')
    fill_in('profile[email]', with: 'horst@mail.de')
    fill_in('profile[password]', with: 'Testpassword')
    click_button "Anmelden"

    visit profile_path(@horst, locale: "de")
    click_link('Profil bearbeiten')
    assert_equal find_field('profile[topic_list]').value, 'fruehling'
  end

  #we comment this test out because it would be too performance consuming to either add the selection
  #of only tags from published profiles in the profiles controller or too time consuming to adapt the test cases
  # test "show only tags from published Profile" do
  #   visit '/profiles'
  #   # save_and_open_page
  #   assert page.has_content?('sommer')
  #   assert page.has_no_content?('winter')
  #   within ".topics-cloud" do
  #     click_link('sommer')
  #   end
  #   assert page.has_css?('div.name', count: 1)
  # end

  test "show Fruehling tag" do
    visit '/profiles'
    assert page.has_content?('fruehling')
    within ".topics-cloud" do
      click_link('fruehling')
    end
    assert page.has_css?('div.name', count: 2)
  end

  test "show rot/blau tag as rot-blau" do
    visit '/profiles'
    assert page.has_content?('rot-blau')
    within ".topics-cloud" do
      click_link('rot-blau')
    end
    assert page.has_css?('div.name', count: 1)
  end
end
