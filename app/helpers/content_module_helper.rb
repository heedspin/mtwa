module ContentModuleHelper
  def content_module(key)
    cm = ContentModule.find_by_key(key.to_s)
    raise "Please create content module for #{key}" if cm.nil?
    if cm.has_content?
      # Secure emails.
      cm.content = cm.content.to_s.gsub /<a[^href]+href="mailto:([^"]+)"[^>]*>([^<]+)<\/a>/m do |link|
      mail_to $1, $2, :encode => "javascript" #, :host => request.host
    end
  end
  # Add an edit link.
  if current_user and (permitted_to? :edit, cm)
    path = edit_content_module_path(:id => cm.id, :return_to => request.request_uri)
    editlink = <<-HTML
    <a href="#{path}">Edit</a>
      HTML
      if cm.has_content
        if cm.content =~ /^<p>(.+)<\/p>$/m
          cm.content = '<p>' + $1 + ' ' + editlink + '</p>'
        else
          cm.content << '<p>' + editlink + '</p>'
        end
      else
        cm.title ||= ''
        cm.title << ' ' + editlink
      end
    end
    cm
  end
end
