export const articleCategories = [
    { id: null, name: 'Все', slug: 'all'},
    { id: 1, name: 'Обзоры', slug: 'reviews'},
    { id: 2, name: 'Подборки', slug: 'selections'},
]

export const newsCategories = [
    { id: null, name: 'Все', slug: 'all' },
    { id: 1, name: 'ПК', slug: 'pc' },
    { id: 2, name: 'Анонсы', slug: 'announcements' },
    { id: 3, name: 'Релизы', slug: 'releases' },
    { id: 4, name: 'Консоли', slug: 'consoles' },
    { id: 5, name: 'VR', slug: 'vr' },
    { id: 6, name: 'Патчи', slug: 'patches' },
    { id: 7, name: 'Индустрия', slug: 'industry' },
    { id: 8, name: 'Слухи', slug: 'rumors' },
]

export const getCategoryId = (slug, categories) => {
    if (slug === 'all' || !slug) return null
    const category = categories.find(cat => cat.slug === slug)
    return category?.id ?? null
}

export const getCategorySlug = (id) => {
    if (id) {
        const category = articleCategories.find(cat => cat.id === id)
        return category?.slug ?? 'all'
    }
    
    return 'all'
}
