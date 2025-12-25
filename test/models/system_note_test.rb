require "test_helper"

class SystemNoteTest < ActiveSupport::TestCase
  test "should be valid with content" do
    note = SectorModel::SystemNote.new(
      system: systems(:one),
      author: 'test@example.com',
      content: 'Valid content'
    )
    assert note.valid?
  end

  test "should be invalid without content" do
    note = SectorModel::SystemNote.new(content: nil)
    assert_not note.valid?
    assert_includes note.errors[:content], "can't be blank"
  end

  test "should be invalid with too short content" do
    note = SectorModel::SystemNote.new(content: 'abc')
    assert_not note.valid?
  end
end
