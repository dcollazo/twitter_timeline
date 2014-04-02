require 'spec_helper'

describe 'Initial test' do
  subject { page }
  
  describe "Index page" do
    before { visit '/' }
    it { should have_title('Public Timeline')}
    it { should have_content('Recent Public Tweets') }
  end
end