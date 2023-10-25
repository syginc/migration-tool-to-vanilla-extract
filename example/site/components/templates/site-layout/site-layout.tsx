import {styled} from "linaria/react";
import {ReactNode, useCallback, useState} from "react";

import {zIndexGlobalHeader} from "../../../styles/site-variables";
import {GlobalFooter} from "../../organisms/global-footer/global-footer";
import {GlobalHeader} from "../../organisms/global-header/global-header";
import {GlobalMenuMobile} from "../../organisms/global-menu-mobile/global-menu-mobile";
import {
    siteLayoutContainerDivStyle,
    siteLayoutFooterStyle,
    siteLayoutHeaderStyle,
    siteLayoutMainStyle,
    siteLayoutMobileDivStyle,
} from "./site-layout.css";
import {SiteMain} from "./site-main";

const SiteLayoutContainerDiv = styled.div`
    display: flex;
    flex-direction: column;
    min-height: 100vh;
`;

const SiteLayoutHeader = styled.header`
    position: sticky;
    top: 0;
    z-index: ${zIndexGlobalHeader};
`;

const SiteLayoutMain = styled.main`
    position: relative;
`;

const SiteLayoutMobileDiv = styled.div`
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    display: none;
    &[data-open] {
        display: block;
    }
`;

const SiteLayoutFooter = styled.footer`
    margin-top: auto;
`;

interface SiteLayoutProps {
    children: ReactNode;
}

export const SiteLayout: React.VFC<SiteLayoutProps> = ({children}) => {
export const SiteLayout: React.FC<SiteLayoutProps> = ({children}) => {
    const [isMenuOpen, setIsMenuOpen] = useState(false);
    const toggleMenuOpen = useCallback(() => {
        setIsMenuOpen((b) => !b);
    }, []);

    return (
        <SiteLayoutContainerDiv>
            <SiteLayoutHeader>
        <div className={siteLayoutContainerDivStyle}>
            <div className={siteLayoutHeaderStyle}>
                <GlobalHeader isMenuOpen={isMenuOpen} toggleMenuOpen={toggleMenuOpen} />
            </SiteLayoutHeader>
            <SiteLayoutMain>
                <SiteLayoutMobileDiv data-open={isMenuOpen ? true : undefined}>
            </div>
            <main className={siteLayoutMainStyle}>
                <div className={siteLayoutMobileDivStyle} data-open={isMenuOpen ? true : undefined}>
                    <GlobalMenuMobile />
                </SiteLayoutMobileDiv>
                </div>

                <SiteMain>{children}</SiteMain>
            </SiteLayoutMain>
            <SiteLayoutFooter>
            </main>
            <footer className={siteLayoutFooterStyle}>
                <GlobalFooter />
            </SiteLayoutFooter>
        </SiteLayoutContainerDiv>
            </footer>
        </div>
    );
};
