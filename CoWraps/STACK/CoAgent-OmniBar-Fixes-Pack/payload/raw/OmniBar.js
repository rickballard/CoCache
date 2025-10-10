
(function(){
  const bar = document.createElement('div');
  bar.id = 'coagent-omnibar';
  bar.innerHTML = `
    <span class="title" id="omnibar-guardrails-link">Guardrails</span>
    <span class="seg"><span class="dot" id="om-backend-dot"></span>Backend:<span id="om-backend">down</span></span>
    <span class="seg"><span class="dot" id="om-slam-dot"></span>SLAM:<span id="om-slam">0.80</span></span>
    <span class="seg"><span class="dot" id="om-bpoe-dot"></span>BPOE:<span id="om-bpoe">idle</span></span>
    <span class="seg"><span class="dot" id="om-issueops-dot"></span>IssueOps:<span id="om-issueops">ready</span></span>
    <span class="seg"><span class="dot" id="om-risk-dot"></span>Risk:<span id="om-risk">green</span></span>
    <span class="grow"></span>
  `;
  document.addEventListener('DOMContentLoaded', ()=> document.body.appendChild(bar));

  // Lightweight modal for Guardrails (reuse if earlier one exists)
  function ensureModal(){
    if (document.getElementById('coagent-guardrails-modal')) return;
    const modal = document.createElement('div');
    modal.id = 'coagent-guardrails-modal';
    modal.style.cssText = 'position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(0,0,0,.4);z-index:2147483650;';
    modal.innerHTML = `
      <div class="panel" style="width:min(700px,92vw);background:var(--panel-bg,#161a23);color:var(--panel-fg,#e6e9ef);border:1px solid var(--border,#2a2f3a);border-radius:12px;padding:14px;box-shadow:0 10px 40px rgba(0,0,0,.35);">
        <h3 style="margin:0 0 8px 0;font-size:13px;">Guardrails & Human Gate</h3>
        <p style="margin:6px 0;line-height:1.35;font-size:12.5px;">As AI agency increases, CoAgent requires explicit HumanGate authorizations for actions that could affect source code, repos, data, or external systems. High-risk operations are never auto-executed; they queue for review and may require repeated confirmation. You can pause self-evolve at any time and all risky edits are labeled and auditable.</p>
        <div class="actions" style="display:flex;justify-content:flex-end;gap:8px;margin-top:10px;">
          <button id="guardrails-ok" style="padding:6px 10px;border-radius:8px;border:1px solid var(--border,#2a2f3a);background:var(--panel-bg,#161a23);color:inherit;">OK</button>
        </div>
      </div>`;
    document.addEventListener('DOMContentLoaded', ()=> document.body.appendChild(modal));
    modal.addEventListener('click', (e)=> { if (e.target.id==='guardrails-ok' || e.target===modal) modal.style.display='none'; });
  }
  document.addEventListener('click', (e)=>{
    if (e.target && e.target.id === 'omnibar-guardrails-link') {
      ensureModal();
      const m = document.getElementById('coagent-guardrails-modal');
      if (m) m.style.display = 'flex';
    }
  });

  function setText(id, val){ const el = document.getElementById(id); if (el) el.textContent = String(val); }
  function setDot(id, level){ const el = document.getElementById(id); if (!el) return; el.classList.remove('ok','warn','bad'); el.classList.add(level); }

  // Backend ping
  async function ping(){ try { await fetch('http://127.0.0.1:7681/', {mode:'no-cors'}); setText('om-backend','up'); setDot('om-backend-dot','ok'); } catch(e){ setText('om-backend','down'); setDot('om-backend-dot','warn'); } }
  setInterval(ping, 5000); ping();

  // SLAM: degrade on backend-down or edited DO blocks
  function slam(){
    let s = 0.85;
    if (document.getElementById('om-backend').textContent !== 'up') s -= 0.15;
    if (document.querySelector('.coagent-do-wrap.edited')) s -= 0.25;
    s = Math.max(0.05, Math.min(0.99, s));
    setText('om-slam', s.toFixed(2));
    setDot('om-slam-dot', s>=0.75 ? 'ok' : (s>=0.45 ? 'warn':'bad'));
  }
  setInterval(slam, 1500); slam();

  // Default placeholders
  setText('om-bpoe','idle'); setDot('om-bpoe-dot','ok');
  setText('om-issueops','ready'); setDot('om-issueops-dot','ok');
  setText('om-risk','green'); setDot('om-risk-dot','ok');

  // Bridge API
  window.CoAgentOmni = {
    setBackend(up){ setText('om-backend', up?'up':'down'); setDot('om-backend-dot', up?'ok':'warn'); },
    setBPOE(state){ setText('om-bpoe', state); setDot('om-bpoe-dot', state==='blocked'?'warn':'ok'); },
    setIssueOps(state){ setText('om-issueops', state); setDot('om-issueops-dot', state==='error'?'bad':(state==='pending'?'warn':'ok')); },
    setRisk(level){ setText('om-risk', level); setDot('om-risk-dot', level==='red'?'bad':(level==='amber'?'warn':'ok')); },
    tick(){ slam(); }
  };
})();
