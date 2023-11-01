#!/usr/bin/ruby
require_relative('func.rb')

text = DATA.read

name_css_hash = {}

text.scan(%r|const (\w+) = styled.*?`(.*?)`|m).each do |name, css|
    list = convert_vanilla_extract_css_style(css)

    name = name.gsub(/^Styled/, '')
    new_name = name[0].downcase + name[1..-1]
    name_css_hash[new_name] = "export const #{new_name}Style = style({" + list.join + "\n" + "\s" * 4 + "}," + "\n);"
end

name_css_hash.each do |_, value|
    puts("\n\n")
    puts("#{convert_media_query(value)}")
end
__END__

const CoverContainerDiv = styled.div`
    display: grid;
    grid-template-columns: 100%;
    grid-template-rows: 190px;

    ${mediaUpToSmall} {
        margin: 0 calc(50% - 50vw);
    }

    ${mediaMiddleUp} {
        margin: 0 min(calc(50% - 50vw), -${articleBodyPaddingWidthDesktop}px);
        grid-template-rows: 320px;
    }
`;

const NormalMainColumnDiv = styled(MainColumnDiv)`
    ${mediaUpToSmall} {
        padding: 0 ${mainColumnPaddingWidthMobile}px;
    }

    ${mediaMiddleUp} {
        width: ${mainColumnWidthDesktop}px;
        padding: 0 ${mainColumnPaddingWidthDesktop}px;
    }
`;

const ArticleMainColumnDiv = styled(MainColumnDiv)`
    ${mediaUpToSmall} {
        padding: 0 ${articleBodyPaddingWidthMobile}px;
    }

    ${mediaMiddleUp} {
        width: ${720 + articleBodyPaddingWidthDesktop * 2}px;
        padding: 0 ${articleBodyPaddingWidthDesktop}px;
    }
`;
