(function () {
  'use strict'

  const getStoredTheme = () => localStorage.getItem('theme')
  const setStoredTheme = theme => localStorage.setItem('theme', theme)

  const getPreferredTheme = () => {
    const storedTheme = getStoredTheme()
    if (storedTheme) {
      return storedTheme
    }

    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  }

  const setTheme = theme => {
    document.documentElement.setAttribute('data-bs-theme', theme)
  }

  setTheme(getPreferredTheme())

  const updateIcon = (theme) => {
    const activeThemeIcon = document.querySelector('.theme-icon-active')
    if (activeThemeIcon) {
      if (theme === 'dark') {
        activeThemeIcon.classList.remove('bi-sun-fill')
        activeThemeIcon.classList.add('bi-moon-stars-fill')
      } else {
        activeThemeIcon.classList.remove('bi-moon-stars-fill')
        activeThemeIcon.classList.add('bi-sun-fill')
      }
    }
  }

  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    if (!getStoredTheme()) {
      const newTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
      setTheme(newTheme)
      updateIcon(newTheme)
    }
  })

  window.addEventListener('DOMContentLoaded', () => {
    const theme = getPreferredTheme()
    updateIcon(theme)

    const toggle = document.querySelector('#theme-toggle')
    if (toggle) {
      toggle.addEventListener('click', () => {
        const currentTheme = document.documentElement.getAttribute('data-bs-theme')
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark'
        
        setStoredTheme(newTheme)
        setTheme(newTheme)
        updateIcon(newTheme)
      })
    }
  })
})()
