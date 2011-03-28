require 'rake'

namespace :mturk do
  desc 'Create the PDF Survey Hits'
  task :create_pdf_survey_hits => :environment do
    hit = MtHit.make(:task_type => 'MtPdfSurvey',
                     :hit_title => 'PDF Survey Test',
                     :hit_description => 'Testing A PDF Survey',
                     :cookie => { :page => 1 })
    if hit.valid?
      puts "Hit created ( #{hit.hit_url} )."
    else
      puts "Failed to create hit: " + hit.errors.full_messages.join("\n")
    end
  end

  desc 'Clear all Hits'
  task :expire_pdf_survey_hits => :environment do
    MtHit.in_progress.each(&:expire!)
  end
end