#!/usr/bin/ruby

# Remove linaria style css

File.open(ARGV[0]) do |file|
    text = file.read

    puts text
      .gsub(%r|const (\w+) = styled.(.*?)`.*?`;|m, '')
      .gsub(%r|\n{3,}|) { "\n\n" }
end
