require File.join(File.dirname(__FILE__), 'integration_spec_helper')

describe 'Admin Interface', js: true do
  before :each do
    Page.delete_all
    @app = Application.new(title: "foo", owner: "foobert")
    @app.save!

    visit "/admin"
  end

  ['content', 'navigation'].each do |type|
    it "should create new #{type}-page" do

      page.should have_no_selector("li.page")
      find("#new-page").click

      within ".ui-dialog" do
        fill_in "page-title", with: "Testpage"
        fill_in "page-url", with: "test-page"
        click_button "Seite erstellen"
      end

      wait_for_ajax

      page.should have_content("Testpage")
    end
  end

  it "should update application" do
    page.should have_content(@app.title)
    page.should have_content(@app.owner)

    fill_in "application-title", with: "Fooapp"
    fill_in "application-owner", with: "Testbert"

    click_button "Änderungen speichern"

    wait_for_ajax

    expect(@app.reload.title).to eq("Fooapp")
    expect(@app.reload.owner).to eq("Testbert")

    page.should have_content("Aktualisiert")
  end
end
