export const gameParams = {
    'Геймплей': 'gameplay',
    'Графика': 'graphics',
    'Сюжет': 'story',
    'Музыка': 'music',
    'Атмосфера': 'atmosphere',
    'Стабильность': 'stability',
    'Реиграбельность': 'replayability'
}

export const defaultRatings = () => ([
    { name: 'Геймплей', score: 5, hidden: false, isRequired: true },
    { name: 'Графика', score: 5, hidden: false, isRequired: true },
    { name: 'Сюжет', score: 5, hidden: false, isRequired: true },
    { name: 'Музыка', score: 5, hidden: false, isRequired: true },
    { name: 'Атмосфера', score: 5, hidden: false, isRequired: true },
    { name: 'Стабильность', score: 5, hidden: false, isRequired: false },
    { name: 'Реиграбельность', score: 5, hidden: false, isRequired: false }
])