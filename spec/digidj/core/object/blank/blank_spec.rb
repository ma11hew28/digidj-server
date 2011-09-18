# Source:
# https://github.com/rails/rails/blob/master/activesupport/test/core_ext/blank_test.rb

describe Object do
  BLANK = [ nil, false, '', '  ', " \n\t \r ", ' ', [], {} ]
  NOT   = [ Object.new, true, 0, 1, 'a', [nil], { nil => 0 } ]

  describe "#blank" do
    BLANK.each { |v| it("#{v.inspect} should be blank") { v.should be_blank } }
    NOT.each   { |v| it("#{v.inspect} should not be blank") { v.should_not be_blank } }
  end

  describe "#present" do
    BLANK.each { |v| it("#{v.inspect} should not be present") { v.should_not be_present } }
    NOT.each   { |v| it("#{v.inspect} should be present") { v.should be_present } }
  end

  describe "#presence" do
    BLANK.each { |v| it ("#{v.inspect}.presence should return nil") { v.presence.should be_nil } }
    NOT.each   { |v| it ("#{v.inspect}.presence should return self") { v.presence.should eq(v) } }
  end
end
