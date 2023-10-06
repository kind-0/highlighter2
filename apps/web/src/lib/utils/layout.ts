import type { PageLayoutOptions } from "$stores/page_layout"

export function assertPageLayoutOptions(w:number, h:number): PageLayoutOptions {
    let layout: PageLayoutOptions = undefined
    if((w > 380 && w < 450) && (h > 840)) {
        layout = `mobile_addtopspace`
    }
    return layout
}