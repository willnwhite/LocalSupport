require 'rails_helper'

describe "organisations/index.html.erb", :type => :view, :js => true do

  let(:org1) do
    stub_model Organisation,:name => 'test', :address => "12 pinner rd", :postcode => "HA1 4HP",:telephone => "1234", :website => 'http://a.com', :description => 'I am test organisation hahahahahhahaha', :lat => 1, :lng => -1
  end

  let(:org2) do
    stub_model Organisation,:name => 'test2', :address => "12 oxford rd", :postcode => "HA1 4HX", :telephone => "4534", :website => 'http://b.com', :description => 'I am ', :lat => 1, :lng => -1
  end

  let(:organisations) do
    [org1,org2]
  end

  let(:results) do
    [org1,org2]
  end

  before(:each) do
    assign(:organisations, organisations)
    assign(:results, results)
    assign(:query_term,'search')
    allow(organisations).to receive(:current_page).and_return(1)
    allow(organisations).to receive(:total_pages).and_return(1)
    allow(organisations).to receive(:limit_value).and_return(1)
    assign(:category_options, [['Animal Welfare','1'],['Education','2']])
    assign(:markers, 'my-markers')
    render
  end

  it "renders a search form" do
    expect(rendered).to have_selector "form input[name='q']"
    expect(rendered).to have_selector "form input[type='submit']"
    expect(rendered).to have_selector "form input[value='search']"
    expect(rendered).to have_selector "form input[placeholder='optional search name/description']"
    expect(rendered).to have_selector "form select[name='category[id]']"
    expect(rendered).to have_selector "form select[name='category[id]'] option[value='']" do |all_select|
      expect(all_select).to contain("All")
    end
    expect(rendered).to have_selector "form select[name='category[id]'] option[value='1']"
    expect(rendered).to have_selector "form select[name='category[id]'] option[value='2']"
  end

  it "render organisation names with hyperlinks" do
    organisations.each do |org|
      expect(rendered).to have_link org.name, :href => organisation_path(org.id)
      expect(rendered).to have_content org.description.truncate(128,:omission=>' ...')
    end
  end

  it "does not render addresses and telephone numbers" do
    expect(rendered).not_to have_content org1.address
    expect(rendered).not_to have_content org1.telephone
    expect(rendered).not_to have_content org2.address
    expect(rendered).not_to have_content org2.telephone
  end

  it "does not renders edit and destroy links" do
    expect(rendered).not_to have_link 'Edit'
    expect(rendered).not_to have_link 'Destroy'
    expect(rendered).not_to have_content org2.address
    expect(rendered).not_to have_content org2.telephone
  end

  it 'displays the json for the map script' do
    assign(:footer_page_links, [])
    render template: "organisations/index", layout: "layouts/two_columns"
    expect(rendered).to include 'my-markers'
  end

  it "displays the javascript for a google map" do
    assign(:footer_page_links, [])
    allow(Page).to receive(:all).and_return []
    render template: "organisations/index", layout: "layouts/application"
    expect(rendered).to include 'map.js'
  end

end
