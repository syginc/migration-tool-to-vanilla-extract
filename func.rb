#!/usr/bin/ruby

def scan_vanilla_css(text)
  regex = %r%export const \w+ = style\(\{.*?\}\)%m
  text.scan(regex)
end

def convert_style_name(text)
    regex = %r|const (\w+) = styled.*?`(.*?)`|m
    text.gsub(regex).each do
        name = $1
        css = $2
        "export const #{make_style_name(name)} = style({" + css + "})"
    end
end

def convert_vanilla_extract_css_style(css)
    css_regex = %r%(.*?):(.*?);%m
    css.gsub(css_regex).each do
        key = $1
        value = $2
        kebab_key = key.gsub(%r|-([a-z])|) { $1.upcase }
        quoted_value = value.gsub(%r|^(\s*)(.*?)(\s*)$|, '\1"\2"\3') if value
        # Can refactor
        variable_regex = %r|\"\$\{(.*)\}\"|
        if variable_regex.match(quoted_value)
            "#{kebab_key}:#{quoted_value.gsub(variable_regex, '\1')},"
        else
            "#{kebab_key}:#{quoted_value},"
        end
    end
end

def convert_media_query(css)
    def space(num)
        "\s" * num
    end
    words_regex = Regexp.union(["mediaUpToSmall", "mediaMiddleUp"])
    css.gsub(%r|\$\{(#{words_regex})\} \{(.*?)\n\s+\}|m).each do
        word = $1
        contents = $2
        new_word = "vanillaExtract" + word[0].upcase + word[1..-1]
        new_contents = contents.lines.map{|s| space(4) + s}.join
        %Q%"@media": {\n#{space(8)}[#{new_word}]: {#{new_contents}\n#{space(8)}},\n#{space(4)}},%
    end
end

def make_style_name(name)
    name = name.gsub(/^Styled/, '')
    name[0].downcase + name[1..-1] + "Style"
end
