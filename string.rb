class String
  def shift_class
    split('_').collect!(&:capitalize).join
  end
end