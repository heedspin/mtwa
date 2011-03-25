module NewsItemHelper
  def prefixed_content(news_item, content_type)
    content = if content_type == :summary
      txt = news_item.summary.present? ? news_item.summary : news_item.body
      if news_item.body.present? and (txt =~ /^<p>(.+)<\/p>$/m)
        link_text = "<a href=\"#{news_item_url(news_item)}\">&raquo; Read More</a>"
        "<p>#{$1}<br />#{link_text}</p>"
      else
        txt
      end
    else
      news_item.body.present? ? news_item.body : news_item.summary
    end
    prefix = []
    prefix.push news_item.location if news_item.location.present?
    # prefix.push "(#{news_item.publish_date.to_s(:news_item)})" if news_item.publish_date.present?
    content = if prefix.size > 0
      content.sub('<p>', "<p> <strong>#{prefix.join(' ')}</strong> &ndash; ")
    else
      content
    end
    if (content_type == :summary) and news_item.attachment? and news_item.summary.blank?
      attachment_link = link_to news_item.attachment_title, news_item.attachment.url
      if content =~ /^<p>(.+)<\/p>$/m
        content = '<p>' + $1 + ' ' + attachment_link + '</p>'
      else
        content << '<p>' + attachment_link + '</p>'
      end
    end
    content
  end
end