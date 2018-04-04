require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @okaka_project1 = notes(:okaka_project_1)
    @okaka_project2 = notes(:okaka_project_2)
    @noritama_project1 = notes(:noritama_project_1)
  end

  test 'invalid note uniqueness' do
    @okaka_project1.save
    # Same user cant have same name note
    @okaka_project2.name = @okaka_project1.name
    assert_not @okaka_project2.valid?
    # Other user can have same name note
    @noritama_project1.name = @okaka_project1.name
    assert @noritama_project1.valid?
  end

  test 'invalid note no_type' do
    # Type "" means plain note, but it isn't allowed.
    @okaka_project1.type = ''
    assert_not @okaka_project1.valid?
  end

  test 'invalid note wrong_type' do
    # Setting wrong type raises ArgumentError.
    assert_raises(ArgumentError) do
      @okaka_project1.type = 'Undefined'
    end
  end
end
