#!/usr/bin/ruby

# Convert linaria css style to vanilla extract css style

def process_css(css)
    css_regex = %r%(.*?):(.*?);%m
    css.scan(css_regex).map do |key, value|
        kebab_key = key.gsub(%r|-([a-z])|) { $1.upcase }
        quoted_value = value.gsub(%r|^(\s*)(.*?)(\s*)$|, '\1"\2"\3') if value
        // Can refactor
        variable_regex = %r|\"\$\{(.*)\}\"|
        if variable_regex.match(quoted_value)
            "#{kebab_key}:#{quoted_value.gsub(variable_regex, '\1')},"
        else
            "#{kebab_key}:#{quoted_value},"
        end
    end
end

def convert_media_query(css)
    words_regex = Regexp.union(["mediaUpToSmall", "mediaMiddleUp"])
    css.gsub(%r|\$\{(#{words_regex})\} \{(.*?)\}|m) do
        word = $1
        contents = $2
        new_word = "vanillaExtract" + word[0].upcase + word[1..-1]
        <<TEXT
"@media": {
        [#{new_word}]: {
            #{contents.strip}
        },
    },
TEXT
    end
end

full_filepath = ARGV[0]
filename = full_filepath.split("/")[-1]
new_filename = filename.sub("tsx", "css.ts")
filepath = full_filepath.split("/")[0..-2].join("/")
new_fullpath = "#{filepath}/#{new_filename}"

text = ""
File.open(ARGV[0]) do |file|
    text = file.read
end

name_css_hash = {}
text.scan(%r|const (\w+) = styled.*?`(.*?)`|m).each do |name, css|
    list = process_css(css)

    name = name.gsub(/^Styled/, '')
    new_name = name[0].downcase + name[1..-1]
    name_css_hash[new_name] = "export const #{new_name}Style = style({" + list.join + "\n" + "\s" * 4 + "}," + "\n);"
end

File.open(new_fullpath, "w") do |io|
    io.write(%q(import {style} from "@vanilla-extract/css";))
    io.write("\n")

    // Can refacotr
    name_css_hash.each do |_, value|
        io.write("\n\n")
        io.write("#{convert_media_query(value)}")
    end
end
