module Docsplit

  # Delegates to **pdfinfo** in order to extract information about a PDF file.
  class InfoExtractor

    # Regex matchers for different bits of information.
    MATCHERS = {
      :author     => /^Author:\s+([^\n]+)/,
      :date       => /^CreationDate:\s+([^\n]+)/,
      :creator    => /^Creator:\s+([^\n]+)/,
      :keywords   => /^Keywords:\s+([^\n]+)/,
      :producer   => /^Producer:\s+([^\n]+)/,
      :subject    => /^Subject:\s+([^\n]+)/,
      :title      => /^Title:\s+([^\n]+)/,
      :length     => /^Pages:\s+([^\n]+)/,
      :dimensions => /^Page size:\s+(\d+)\D+(\d+)/,
    }

    # Pull out a single datum from a pdf.
    def extract(key, pdfs, opts)
      pdf = [pdfs].flatten.first
      cmd = "pdfinfo #{ESCAPE[pdf]} 2>&1"
      result = `#{cmd}`.chomp
      raise ExtractionFailed, result if $? != 0
      match = result.match(MATCHERS[key])
      answer = match && match[1]
      answer = answer.to_i if answer && key == :length
      answer = [match[1].to_i, match[2].to_i] if match[1] && match[2] && key == :dimensions
      answer
    end

  end

end