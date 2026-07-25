export const buildArticlesUrl = (pageNum, totalPages, category) => {
    const safePage = Math.max(1, Math.min(totalPages, pageNum))
    const segments = [`p${safePage}`]
    
    if (category && category !== 'all') {
        segments.push(category)
    }
    
    return `/articles/${segments.join('/')}`
}

export const buildNewsUrl = (pageNum, totalPages, category, sort) => {
    const safePage = Math.max(1, Math.min(totalPages, pageNum))
    const segments = [`p${safePage}`]
    
    if (category && category !== 'all') {
        segments.push(category)
    }

    if(sort && sort !== 'new') {
        segments.push(sort)
    }
    
    return `/news/${segments.join('/')}`
}