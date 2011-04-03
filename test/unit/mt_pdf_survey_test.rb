require File.dirname(__FILE__) + '/../test_helper'

class MtPdfSurveyTest < ActiveSupport::TestCase
  def test_table_parsing
    params = []
    params.push 'survey[table1][][1]=val1'
    params.push 'survey[table1][][2]=val2'
    params.push 'survey[table1][][1]=val3'
    params.push 'survey[table1][][2]=val4'
    params.push 'survey[table2][][1]=val5'
    params.push 'survey[table2][][2]=val6'
    params.push 'survey[table2][][1]=val7'
    params.push 'survey[table2][][2]=val8'
    params = Rack::Utils.parse_nested_query(params.join('&'))
    # puts params.inspect
    # {"survey"=>{"table1"=>[{"1"=>"val1", "2"=>"val3"}, {"1"=>"val2", "2"=>"val4"}], "table2"=>[{"1"=>"val5", "2"=>"val6"}, {"1"=>"val7", "2"=>"val8"}]}}
    
    assert survey = MtPdfSurvey.new(params['survey'])
    assert survey.save
    assert survey.table1_data
    puts survey.table1.inspect
    assert row1 = survey.table1[0]
    assert_equal 'val1', row1[0]
    assert_equal 'val2', row1[1]
    assert row2 = survey.table1[1]
    assert_equal 'val3', row2[0]
    assert_equal 'val4', row2[1]

    assert row1 = survey.table2[0]
    assert_equal 'val5', row1[0]
    assert_equal 'val6', row1[1]
    assert row2 = survey.table2[1]
    assert_equal 'val7', row2[0]
    assert_equal 'val8', row2[1]
  end
end

