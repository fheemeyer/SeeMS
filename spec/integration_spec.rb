require File.join(File.dirname(__FILE__), 'integration_spec_helper')

describe 'Admin Interface', js: true do

  ['content', 'navigation'].each do |type|
    it "should create new #{type}-page" do
      Page.delete_all

      page.should have_no_selector("li.page")
      visit "/admin"
      find("#new-page").click

      within ".ui-dialog" do
        fill_in "page-title", with: "Testpage"
        fill_in "page-url", with: "test-page"
        click_button "Seite erstellen"
      end

      page.should have_content("Testpage")
    end
  end
end
