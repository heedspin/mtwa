require 'rake'

namespace :mturk do
  desc 'Create the PDF Survey Hits'
  task :bailiwick => :environment do
    Dir.glob(File.join(Rails.root, 'public/assets/bailiwick/*.pdf')).each do |file|
      key = :bailiwick
      if file =~ /(\d+).pdf/
        page = $1
        hit = MtHit.make(:task_type => 'MtPdfSurvey',
                         :hit_title => 'PDF Survey Test',
                         :hit_description => 'Testing A PDF Survey',
                         :cookie => { :key => key, :page => page  })
        if hit.valid?
          puts "Hit created hit for #{key} #{page} ( #{hit.hit_url} )."
        else
          puts "Failed to create hit: " + hit.errors.full_messages.join("\n")
        end
      end
    end
  end

  desc 'Clear all Hits'
  task :expire_pdf_survey_hits => :environment do
    MtHit.in_progress.each(&:expire!)
  end
end
