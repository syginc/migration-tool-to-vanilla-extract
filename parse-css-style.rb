#!/usr/bin/ruby

text = DATA.read

name_css_hash = {}
regex = %r|const (\w+) = styled.*?`(.*?)`|m

def process_css(css)
    css_variables = []
    list = css.split(/;/).map do |s|
        pair = s.split(/:/)
        key = pair[0].gsub(%r|-([a-z])|) { $1.upcase }
        value = pair[1].gsub(%r|^(\s*)(.*?)(\s*)$|, '\1"\2"\3') if pair[1]
        regex = %r|\"\$\{(.*)\}\"|
        if regex.match(value)
            var = value.gsub(regex, '\1')
            css_variables.append(var.strip)
            "#{key}:#{var}"
        else
            "#{key}:#{value}"
        end
    end
    if list[-1]
        list[-1].sub!(/:$/, "")
    end
    [list, css_variables]
end

def convert_media_query(css)
    words_regex = Regexp.union(["mediaUpToSmall", "mediaMiddleUp"])
    regex = %r|\$\{(#{words_regex})\} \{(.*?)\}|m
    css.gsub(regex) do
        word = $1
        contents = $2
        p contents
        new_word = "vanillaExtract" + word[0].upcase + word[1..-1]
        '"@media": {' + "\n" + "\s" * 8 + "[#{new_word}]: #{contents}}"
    end
end

text.scan(regex).each do |name, css|
    new_css = convert_media_query(css)
    list = process_css(new_css)[0]

    name = name.gsub(/^Styled/, '')
    new_name = name[0].downcase + name[1..-1]
    name_css_hash[new_name] = "export const #{new_name}Style = style({" + list.join(",") + "})"
end

name_css_hash.each do |_, value|
    puts("\n\n")
    puts("#{value}")
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

