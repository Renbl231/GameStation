import { ref, onMounted, onUnmounted } from 'vue'

const themes = ['light', 'dark']

export const useTheme = () => {
    const currentTheme = ref(localStorage.getItem('theme') || 'system')
    
    const applyTheme = (theme) => {
        if (theme === 'system') {
            const isDark = window.matchMedia('(prefers-color-scheme: dark)').matches
            const resolvedTheme = isDark ? 'dark' : 'light'
            document.documentElement.setAttribute('data-theme', resolvedTheme)
            currentTheme.value = resolvedTheme
            localStorage.setItem('theme', resolvedTheme)
        } else {
            document.documentElement.setAttribute('data-theme', theme)
            currentTheme.value = theme
            localStorage.setItem('theme', theme)
        }
    }

    const toggleTheme = () => {
        if (currentTheme.value === 'light') {
            applyTheme(themes[1])
        } else {
            applyTheme(themes[0])
        }
    }


    // если в будующем добавлю отдельно системную вид темы
    
    let mediaQuery = null

    const handleSystemThemeChange = (e) => {
        const isDark = e.matches
        if (localStorage.getItem('theme') === 'system') {
            const resolvedTheme = isDark ? 'dark' : 'light'
            document.documentElement.setAttribute('data-theme', resolvedTheme)
            currentTheme.value = resolvedTheme
        }
    }

    onMounted(() => {
        applyTheme(localStorage.getItem('theme') || 'system')
        
        mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
        mediaQuery.addEventListener('change', handleSystemThemeChange)
    })

    onUnmounted(() => {
        mediaQuery?.removeEventListener('change', handleSystemThemeChange)
    })

    return {
        currentTheme,
        toggleTheme,
        applyTheme,
    }
}