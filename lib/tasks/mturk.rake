require 'rake'

namespace :mturk do
  desc 'Create the PDF Survey Hits'
  task :bailiwick => :environment do
    Dir.glob(File.join(Rails.root, 'public/assets/bailiwick/*.pdf')).each do |file|
      if file =~ /(\d+).pdf/
        page = $1
        subpages = %w(3 24 25 26 27 29 30 32).include?(page) ? [Subpage.only] : [Subpage.first_subpage, Subpage.second_subpage]
        subpages.each do |subpage|
          cookie = { :survey_type_id => SurveyType.bailiwick.id, :page => page, :subpage_id => subpage.id }
          if found = MtHit.find_by_local_id(cookie)
            puts "Hit #{found.id} already exists for #{cookie.inspect}"
          else
            hit = MtHit.make(:task_type => 'MtPdfSurvey',
                             :hit_title => 'Transcribe a PDF',
                             :hit_description => 'Carefully copy and paste text and images from a single page PDF into a web form.',
                             :hit_reward => 0.5,
                             :cookie => cookie)
            if hit.valid?
              puts "Hit created hit for #{subpage} page #{page}: #{hit.hit_url}"
            else
              puts "Failed to create hit: " + hit.errors.full_messages.join("\n")
            end
          end
        end
      end
    end
  end

  desc 'Synchronize Hit Answers'
  task :sync => :environment do
    MtHit.in_progress.by_date.each do |hit|
      puts "#{hit} answers: #{hit.answers.size}"
    end
  end

  desc 'Clear all Hits'
  task :expire_pdf_survey_hits => :environment do
    MtHit.in_progress.each do |hit|
      hit.expire!
      if ENV['ARCHIVE'] == 'true'
        hit.archive!
      end
      if ENV['DELETE'] == 'true'
        hit.destroy
      end
    end
  end
end
