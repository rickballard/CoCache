
(function(){
  try {
    const key = 'coagent.theme';
    const saved = localStorage.getItem(key);
    const html = document.documentElement;
    if (saved === 'light' || saved === 'dark') html.setAttribute('data-theme', saved);
    else html.removeAttribute('data-theme');
    window.CoAgentTheme = {
      set(theme){ 
        if (theme === 'light' || theme === 'dark') { localStorage.setItem(key, theme); html.setAttribute('data-theme', theme); }
        else { localStorage.removeItem(key); html.removeAttribute('data-theme'); }
      },
      get(){ return html.getAttribute('data-theme') || 'auto'; }
    };
  } catch (e) {}
})();
