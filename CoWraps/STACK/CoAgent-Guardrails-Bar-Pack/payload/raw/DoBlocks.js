
// DO block compactor
(function(){
  const ICON = '🛠️';
  function prepare(el){
    if (el.dataset.coagentProcessed) return;
    el.dataset.coagentProcessed = '1';

    const wrap = document.createElement('div');
    wrap.className = 'coagent-do-wrap';

    const icon = document.createElement('span');
    icon.className = 'coagent-do-icon';
    icon.textContent = ICON;

    // Find code element (pre>code or the element itself)
    let code;
    if (el.matches('pre, code')) { code = el; }
    else { code = el.querySelector('pre, code') || el; }
    const codeBox = document.createElement('div');
    codeBox.className = 'coagent-do-code';
    // Move code into box
    codeBox.appendChild(code);

    // Insert into DOM
    el.parentNode.insertBefore(wrap, el);
    wrap.appendChild(icon);
    wrap.appendChild(codeBox);
    el.remove();

    let autoClose;
    function open(){
      wrap.classList.add('open');
      clearTimeout(autoClose);
      // Auto-collapse unless user clicks inside code within 1s
      const guard = setTimeout(()=>{
        const onInteract = ()=>{
          clearTimeout(autoClose);
          wrap.removeEventListener('click', onInteract, true);
          codeBox.removeEventListener('click', onInteract, true);
        };
        wrap.addEventListener('click', onInteract, true);
        codeBox.addEventListener('click', onInteract, true);
        autoClose = setTimeout(()=>wrap.classList.remove('open'), 8000);
      }, 1000);
      // If edited, mark liability
      codeBox.addEventListener('keydown', ()=>{
        wrap.classList.add('edited');
        if (window.CoAgentStatus) { window.CoAgentStatus.setRisk('red'); window.CoAgentStatus.setHumanGate('required'); window.CoAgentStatus.tick(); }
      }, {once:true, capture:true});
      // make editable temporarily
      codeBox.setAttribute('contenteditable','true');
    }
    function close(){ wrap.classList.remove('open'); }

    icon.addEventListener('click', ()=> wrap.classList.contains('open') ? close() : open());
  }

  function scan(){
    document.querySelectorAll('[data-coagent-do], .do-block, .do, pre code[data-do]').forEach(prepare);
  }

  const mo = new MutationObserver(()=>scan());
  document.addEventListener('DOMContentLoaded', ()=>{
    scan();
    mo.observe(document.body, {childList:true, subtree:true});
  });
})();
