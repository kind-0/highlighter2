import { NDKHighlight } from "@nostr-dev-kit/ndk";
import { tagToNip19 } from "../../../utils/index.js";

export default function linkToArticle(highlight: NDKHighlight) {
    const tag = highlight.getArticleTag();

    if (!tag) return '#';

    const val = tagToNip19(tag);

    if (!val) return '#';

    if (val.startsWith('http')) {
        return `/load?url=${encodeURIComponent(val)}`;
    } else if (val.startsWith('n')) {
        return `/a/${val}`;
    } else {
        return '#';
    }
}