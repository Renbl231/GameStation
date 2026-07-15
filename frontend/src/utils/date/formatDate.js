export function formatDate() {
    const formatDate1 = (timestamp) => {
        if (!timestamp) return '';
        
        const now = new Date();
        const date = new Date(timestamp);
        const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const newsDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());

        if (newsDate.getTime() === today.getTime()) {
            return `Сегодня в ${date.toLocaleTimeString('ru-RU', {
                hour: '2-digit',
                minute: '2-digit'
            })}`;
        }

        const yesterday = new Date(today);
        yesterday.setDate(yesterday.getDate() - 1);
        if (newsDate.getTime() === yesterday.getTime()) {
            return `Вчера в ${date.toLocaleTimeString('ru-RU', {
                hour: '2-digit',
                minute: '2-digit'
            })}`;
        }

        return date.toLocaleDateString('ru-RU', {
            day: 'numeric',
            month: 'long'
        });
    };


    const formatDateRuFull = (dateString) => {
        const date = new Date(dateString);

        return new Intl.DateTimeFormat('ru-RU', {
            day: 'numeric',
            month: 'long',
        }).format(date) 
        + ' ' 
        + date.getFullYear(); 
    };

    const formatDateRu = (dateString) => {
        const date = new Date(dateString)

        return new Intl.DateTimeFormat('ru-RU', {
            day: 'numeric',
            month: 'long',
        }).format(date)
    }

    const simpleDate = (iso) => {
        const date = new Date(iso)

        const day = String(date.getUTCDate()).padStart(2, '0')
        const month = String(date.getUTCMonth() + 1).padStart(2, '0')
        const year = date.getUTCFullYear()

        const formatted = `${day}.${month}.${year}`

        return formatted
    }

    return {
        formatDateRuFull,
        formatDateRu,
        simpleDate,

        
        formatDate1,
    };
}
