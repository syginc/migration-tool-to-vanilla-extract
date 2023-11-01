#!/usr/bin/ruby

text = DATA.read

def convert_vanilla_extract_css_style(css)
    css_variables = []
    css_regex = %r%(.*?):(.*?);%m
    list = css.scan(css_regex).map do |key, value|
        kebab_key = key.gsub(%r|-([a-z])|) { $1.upcase }
        quoted_value = value.gsub(%r|^(\s*)(.*?)(\s*)$|, '\1"\2"\3') if value
        variable_regex = %r|\"\$\{(.*)\}\"|
        if variable_regex.match(quoted_value)
            var = quoted_value.gsub(variable_regex, '\1')
            css_variables.append(var.strip)
            "#{kebab_key}:#{var},"
        else
            "#{kebab_key}:#{quoted_value},"
        end
    end
    [list, css_variables]
end

def convert_media_query(css)
    words_regex = Regexp.union(["mediaUpToSmall", "mediaMiddleUp"])
    regex = %r|\$\{(#{words_regex})\} \{(.*?)\}|m
    css.gsub(regex) do
        word = $1
        contents = $2
        new_word = "vanillaExtract" + word[0].upcase + word[1..-1]
        <<TEXT
"@media": {
        [#{new_word.strip}]: {
            #{contents.strip}
        },
    },
TEXT
    end
end

name_css_hash = {}

text.scan(%r|const (\w+) = styled.*?`(.*?)`|m).each do |name, css|
    # new_css = convert_media_query(css)
    list = convert_vanilla_extract_css_style(css)[0]

    name = name.gsub(/^Styled/, '')
    new_name = name[0].downcase + name[1..-1]
    name_css_hash[new_name] = "export const #{new_name}Style = style({" + list.join + "\n" + "\s" * 4 + "}," + "\n);"
end

name_css_hash.each do |_, value|
    puts("\n\n")
    puts("#{convert_media_query(value)}")
end
__END__

const GlobalMenuDiv = styled.div`
    overflow-y: scroll;
    height: 100%;

    ${mediaUpToSmall} {
        width: 100%;
    }

    ${mediaMiddleUp} {
        height: 100%;
        width: 416px;
        margin-left: auto;
    }

    background-color: ${menuBackgroundColorNormal};
`;

const GlobalMenuHeadingH2 = styled.h2`
    background-color: ${menuBackgroundColorInverted};
    color: ${menuTextColorInverted};

    font-size: ${menuHeadingFontSize};
    font-weight: ${strongFontWeight};

    padding: 16px 20px;

    ${mediaMiddleUp} {
        padding: 20px;
    }
`;

const MenuListUl = styled.ul``;

const MenuListLi = styled.li`
    background-color: ${menuBackgroundColorInverted};
    color: ${menuTextColorInverted};
    font-weight: ${strongFontWeight};

    border-bottom: 2px solid white;
`;

const MenuItemA = styled.a`
    padding: 12px 20px;
    ${mediaMiddleUp} {
        padding: 20px;
    }

    display: flex;
    align-items: center;
    text-decoration: none;
    cursor: pointer;
`;

