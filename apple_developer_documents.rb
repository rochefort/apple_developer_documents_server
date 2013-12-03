#!/usr/bin/env ruby

require 'pismo'

class AppleDeveloperDocuments
  URL = 'https://developer.apple.com/jp/devcenter/ios/library/japanese.html'

  def self.crawl
    pismo = Pismo::Document.new(URL)
    doc = pismo.doc

    records = []
    doc.css('table#documentsTable tr').each do |tr|
      next if tr.children.first.name == 'th'

      record = {}
      title = tr.css('td.title')
      link_jp = title.css('div.jp a')
      record[:link_jp]  = link_jp.attr('href').value
      record[:title_jp] = link_jp.text
      link_en = title.css('div.en a')
      puts link_en
      record[:link_en]  = link_en.attr('href').value
      record[:title_en] = link_en.text

      topics = tr.css('td.topics').children
      record[:topic]     = topics.first.text.strip
      record[:sub_topic] = topics.children.text

      record[:framework] = tr.css('td.framework').text

      revisionDate = tr.css('td.docRevisionDate')
      record[:revision_date_jp] = revisionDate.css('div.jp').text
      record[:revision_date_en] = revisionDate.css('div.en').text

      records << record
    end
    records
  end
end
