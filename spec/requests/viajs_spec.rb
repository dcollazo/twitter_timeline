require 'spec_helper'

describe 'Initial test' do
  subject { page }
  
  describe "Index page" do
    before { visit '/via_js' }
    it { should have_content('Recent Public Tweets') }
  end
end