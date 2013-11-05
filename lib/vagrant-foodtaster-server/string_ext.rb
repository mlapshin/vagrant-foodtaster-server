class String
  def strip_heredoc
    min_indent = scan(/^[ \t]*(?=\S)/).min
    indent = min_indent.nil? ? 0 : min_indent.size

    gsub(/^[ \t]{#{indent}}/, '')
  end
end

