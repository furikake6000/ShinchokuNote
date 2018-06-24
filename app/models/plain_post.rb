class PlainPost < Post
  acts_as_paranoid

  def sort_condition_date
    created_at
  end
end
