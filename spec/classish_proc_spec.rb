require 'spec_helper'

describe SonJay::ClassishProc do
  subject{
    described_class.new{ :the_result }
  }

  it "is callable" do
    expect( subject.call ).to eq( :the_result )
  end

  it "is \"new\"able" do
    expect( subject.new ).to eq( :the_result )
  end

end
