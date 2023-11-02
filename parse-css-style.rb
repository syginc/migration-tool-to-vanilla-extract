#!/usr/bin/ruby
require_relative('func.rb')

text = DATA.read

name_css_hash = {}
regex = %r|const (\w+) = styled.*?`(.*?)`|m

puts convert_media_query(convert_vanilla_extract_css_style(convert_style_name(text)))

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

const GlobalHeaderRightDiv = styled.div`
    margin-left: auto;

    ${mediaMiddleUp} {
        gap: 0 20px;
    }

    display: flex;
    gap: 0;
    height: 100%;
`;
