require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    @okaka = users(:okaka)
    @noritama = users(:noritama)
    @okaka_project1 = notes(:okaka_project_1)
    @okaka_project2 = notes(:okaka_project_2)
    @noritama_project1 = notes(:noritama_project_1)
  end

  test 'valid project' do
    assert @okaka_project1.valid?
  end

  test 'invalid project no_name' do
    @okaka_project1.name = ''
    assert_not @okaka_project1.valid?
  end
end
