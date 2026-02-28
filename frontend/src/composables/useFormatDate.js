export function useFormatDate() {
    const formatDate = (timestamp) => {
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

    return {
        formatDate
    };
}
