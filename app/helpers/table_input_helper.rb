module TableInputHelper
  def table_input(object, field, row, column, size=15)
    text_field_tag "#{object}[#{field}][][#{column}]", nil, :size => size
  end
end