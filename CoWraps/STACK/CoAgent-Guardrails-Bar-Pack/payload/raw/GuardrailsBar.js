
(function(){
  // Create status bar
  const bar = document.createElement('div');
  bar.id = 'coagent-statusbar';
  bar.innerHTML = `
    <span class="title" id="coagent-guardrails-link">Guardrails</span>
    <span class="metric"><span class="dot ok" id="sb-backend-dot"></span>Backend:<span id="sb-backend">down</span></span>
    <span class="metric"><span class="dot ok" id="sb-slam-dot"></span>SLAM:<span id="sb-slam">0.80</span></span>
    <span class="metric"><span class="dot ok" id="sb-agency-dot"></span>Agency:<span id="sb-agency">low</span></span>
    <span class="metric"><span class="dot ok" id="sb-hgate-dot"></span>HumanGate:<span id="sb-hgate">idle</span></span>
    <span class="metric"><span class="dot ok" id="sb-risk-dot"></span>Risk:<span id="sb-risk">green</span></span>
  `;
  document.addEventListener('DOMContentLoaded', () => {
    document.body.appendChild(bar);
    // add bottom padding so content doesn't hide under bar
    document.body.style.paddingBottom = '30px';
  });

  // Guardrails modal (click only; no hover)
  const modal = document.createElement('div');
  modal.id = 'coagent-guardrails-modal';
  modal.innerHTML = `
    <div class="panel">
      <h3>Guardrails & Human Gate</h3>
      <p>As AI agency increases, CoAgent requires explicit HumanGate authorizations for actions that could affect source code, repos, data, or external systems. High-risk operations are <b>never</b> auto-executed; they queue for review and may require repeated confirmation. You can pause self-evolve at any time and all risky edits are labeled and auditable.</p>
      <p><b>Heads-up:</b> If you hand-edit a DO block or bypass prompts, Guardrails will flag the session as <em>manual override</em> and increase required checks.</p>
      <div class="actions">
        <button class="primary" id="coagent-hgate-ok">OK</button>
        <button id="coagent-hgate-cancel">Close</button>
      </div>
    </div>
  `;
  document.addEventListener('DOMContentLoaded', () => document.body.appendChild(modal));

  function showModal(){ modal.style.display = 'flex'; }
  function hideModal(){ modal.style.display = 'none'; }
  document.addEventListener('click', (e)=>{
    if (e.target && (e.target.id === 'coagent-guardrails-link')) showModal();
    if (e.target && (e.target.id === 'coagent-hgate-ok' || e.target.id === 'coagent-hgate-cancel' || e.target === modal)) hideModal();
  });

  // Simple metrics with local persistence
  function setText(id, text){ const el = document.getElementById(id); if (el) el.textContent = String(text); }
  function setDot(id, level){ const el = document.getElementById(id); if (!el) return;
    el.classList.remove('ok','warn','bad'); el.classList.add(level);
  }

  // Backend check (127.0.0.1:7681)
  async function pingBackend(){
    try { await fetch('http://127.0.0.1:7681/', {mode:'no-cors'}); setText('sb-backend','up'); setDot('sb-backend-dot','ok'); }
    catch(e){ setText('sb-backend','down'); setDot('sb-backend-dot','warn'); }
  }
  setInterval(pingBackend, 5000); pingBackend();

  // SLAM: Safety Level & Agency Meter (placeholder heuristic)
  function computeSLAM(){
    // Start green; degrade if backend down or edited DO blocks exist
    let score = 0.85;
    const backendUp = document.getElementById('sb-backend').textContent === 'up';
    if (!backendUp) score -= 0.15;
    const edited = document.querySelector('.coagent-do-wrap.edited');
    if (edited) score -= 0.25;
    score = Math.max(0.05, Math.min(0.99, score));
    setText('sb-slam', score.toFixed(2));
    setDot('sb-slam-dot', score >= 0.75 ? 'ok' : (score >= 0.45 ? 'warn' : 'bad'));
  }
  setInterval(computeSLAM, 1500); computeSLAM();

  // Agency/HumanGate/Risk placeholders
  setText('sb-agency','low');
  setText('sb-hgate','idle');
  setText('sb-risk','green');

  // Expose a tiny API for the app
  window.CoAgentStatus = {
    setBackend(up){ setText('sb-backend', up ? 'up':'down'); setDot('sb-backend-dot', up?'ok':'warn'); },
    setAgency(level){ setText('sb-agency', level); setDot('sb-agency-dot', level==='high'?'warn':'ok'); },
    setHumanGate(state){ setText('sb-hgate', state); setDot('sb-hgate-dot', state==='required'?'warn':'ok'); },
    setRisk(level){ setText('sb-risk', level); setDot('sb-risk-dot', level==='red'?'bad':(level==='amber'?'warn':'ok')); },
    tick(){ computeSLAM(); }
  };
})();
