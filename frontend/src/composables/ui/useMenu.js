import { ref, onMounted, onUnmounted } from 'vue'    

export const useMenu = () => {
    const isBgMenuOpen = ref(false);
    const isProfMenuOpen = ref(false);

    const toggleBgMenu = () => {
        isBgMenuOpen.value = !isBgMenuOpen.value;
        if (isBgMenuOpen.value) isProfMenuOpen.value = false;
    }

    const toggleProfMenu = () => {
        isProfMenuOpen.value = !isProfMenuOpen.value;
        if (isProfMenuOpen.value) isBgMenuOpen.value = false;
    }

    const closeAllMenus = (event) => {
        if (event.button === 2) return;
  
        const target = event.target;
        const isMenuElement = target.closest('.theme-switcher-mobile, .mobile-menu, .btn-menu, .profile-menu');
        
        if (!isMenuElement) {
            isBgMenuOpen.value = false;
            isProfMenuOpen.value = false;
        }
    }

    const handleResize = () => {
        if (window.innerWidth > 1160) {
            isBgMenuOpen.value = false
        }
    }

    onMounted(() => {
        document.addEventListener('mousedown', closeAllMenus);
        window.addEventListener('resize', handleResize)
        handleResize()
    })

    onUnmounted(() => {
        document.removeEventListener('mousedown', closeAllMenus)
        window.removeEventListener('resize', handleResize)
    })

    return {
        isBgMenuOpen,
        isProfMenuOpen,
        toggleBgMenu,
        toggleProfMenu
    }
}



