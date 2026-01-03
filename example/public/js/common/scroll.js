const appHeader = document.querySelector('app-header');

window.addEventListener('scroll', () => {
    if (window.scrollY > 0) {
        appHeader.classList.add('scrolled');
    } else {
        appHeader.classList.remove('scrolled');
    }
});