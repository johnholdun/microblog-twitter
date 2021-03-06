class Status
  ACCEPTED_TAGS = %w(p em i strong b a).freeze

  attr_reader :published_at, :url

  def initialize(entry, short_url_length: 23)
    @entry = entry
    @published_at = entry.published
    @url = entry.url
    @short_url_length = short_url_length
  end

  def summary
    tweetable? ?  full_summary : "#{truncated_summary}… #{url}"
  end

  def attributes
    %i(summary published_at).each_with_object({}) { |k, h| h[k] = send(k) }
  end

  def truncated_summary
    # "Truncated summary… https://short_url"
    target_length = 140 - short_url_length - 1 - 1
    tokens = full_summary.split(/\s+/)
    tokens.inject('') do |string, token|
      target = "#{string} #{token}".strip
      target.size <= target_length ? target : string
    end
  end

  private

  attr_reader :entry, :short_url_length

  def tweetable?
    urls.size <= 1 && (parsed_summary.size + urls.size * (short_url_length + 1)) <= 140
  end

  def full_summary
    @full_summary ||= "#{parsed_summary} #{urls.join(' ')}".strip
  end

  def parsed_summary
    @parsed_summary ||=
      %i(
        summary_with_stars
        summary_without_links
        summary_without_some_tags
        summary_into_markdown
        summary_without_escapes
      ).inject(entry.summary) do |string, method_name|
        send(method_name, string)
      end
  end

  def summary_with_stars(text)
    text.gsub(/<\/?(em|i|strong|b)( [^>]+)?>/, '*')
  end

  def summary_without_links(text)
    text.gsub(/<\/a>/, '').gsub(/<a [^>]+>/, '')
  end

  def summary_without_some_tags(text)
    text.gsub(/<\/?([^>]+)>/) do |tag|
      el = tag.scan(/^<\/?(.+?)(?: |>)/).flatten.first
      tag if ACCEPTED_TAGS.include?(el)
    end
  end

  def summary_into_markdown(text)
    ReverseMarkdown.convert(text).strip
  end

  def summary_without_escapes(text)
    text.gsub(/\\\*/, '*')
  end

  def urls
    @urls ||= entry.summary.scan(/(?:href|src)=(['"])(.+?)\1/).flatten.select { |v| v =~ /^http/ }
  end
end
