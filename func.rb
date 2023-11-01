#!/usr/bin/ruby

def convert_vanilla_extract_css_style(css)
    css_regex = %r%(.*?):(.*?);%m
    css.gsub(css_regex).map do
        key = $1
        value = $2
        kebab_key = key.gsub(%r|-([a-z])|) { $1.upcase }
        quoted_value = value.gsub(%r|^(\s*)(.*?)(\s*)$|, '\1"\2"\3') if value
        "#{kebab_key}:#{quoted_value},"
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
    words_regex = Regexp.union(["mediaUpToSmall", "mediaMiddleUp"])
    css.gsub(%r|\$\{(#{words_regex})\} \{(.*)\}|m) do
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

