module TableInputHelper
  def table_input(object, field, row, column)
    text_field_tag "#{object}[#{field}][][#{row}][][#{column}]", nil, :size => 15
  end
end