import Parser from 'rss-parser';

export async function load({ params, fetch }) {
    const { url } = params;

    const parser = new Parser();
    const feed = await parser.parseURL(url);

    return feed;
    // const loadUrl = url;
    // console.log({loadUrl});
    // const response = await fetch(loadUrl);
    // let contentType = response.headers.get('content-type').split(';')[0];
    // const text = await response.text();

    // if (loadUrl.startsWith('https://overcast.fm/+')) {
    //     contentType = 'embed/overcast';
    // } else if (loadUrl.startsWith('https://youtube.com/watch')) {
    //     contentType = 'embed/youtube';
    // }

    // return {
    //     text,
    //     contentType,
    // };
}
