require File.dirname(__FILE__) + '/../test_helper'

class TableParamTest < ActiveSupport::TestCase
  def test_table_params
    params = []
    params.push 'survey[table1][][row1][][col1]=val1'
    params.push 'survey[table1][][row1][][col2]=val2'
    params.push 'survey[table1][][row2][][col1]=val3'
    params.push 'survey[table1][][row2][][col2]=val4'
    params.push 'survey[table2][][row1][][col1]=val5'
    params.push 'survey[table2][][row1][][col2]=val6'
    params.push 'survey[table2][][row2][][col1]=val7'
    params.push 'survey[table2][][row2][][col2]=val8'
    puts Rack::Utils.parse_nested_query(params.join('&')).inspect
  end
end

