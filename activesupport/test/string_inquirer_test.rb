require 'abstract_unit'

class StringInquirerTest < ActiveSupport::TestCase
  def setup
    @permissive_inquirer = ActiveSupport::StringInquirer.new('production')
    @picky_inquirers = [
      ActiveSupport::StringInquirer.new('production', %w(development test production)),
      ActiveSupport::StringInquirer.new('production', %w(development test)),
    ]
    @all_inquirers = [@permissive_inquirer] + @picky_inquirers
  end

  def test_match
    @all_inquirers.each do |inquirer|
      assert inquirer.production?
    end
  end

  def test_miss
    @all_inquirers.each do |inquirer|
      assert_not inquirer.development?
    end
  end

  def test_missing_question_mark
    @all_inquirers.each do |inquirer|
      assert_raise(NoMethodError) { inquirer.production }
    end
  end

  def test_respond_to
    assert_respond_to @permissive_inquirer, :development?
    assert_respond_to @permissive_inquirer, :something_else?
    @picky_inquirers.each do |inquirer|
      assert_respond_to inquirer, :development?
      assert_not_respond_to inquirer, :something_else?
    end
  end

  def test_unexpected_method_name
    assert_not @permissive_inquirer.something_else?
    @picky_inquirers.each do |inquirer|
      assert_raise(NoMethodError) { inquirer.something_else? }
    end
  end
end
