
(function(){
  const bar = document.createElement('div');
  bar.id = 'coagent-omnibar';
  bar.innerHTML = `
    <span class="title kpi" data-kpi="guardrails">Guardrails</span>
    <span class="gi">
      <span class="gi-bar"><span class="gi-thumb" id="om-gi-thumb" style="left:72px;"></span></span>
    </span>
    <span class="seg kpi" data-kpi="backend"><span class="dot" id="om-backend-dot"></span>Backend:<span id="om-backend">down</span></span>
    <span class="seg kpi" data-kpi="slam"><span class="dot" id="om-slam-dot"></span>SLAM:<span id="om-slam">80%</span></span>
    <span class="seg kpi" data-kpi="bpoe"><span class="dot" id="om-bpoe-dot"></span>BPOE:<span id="om-bpoe">idle</span></span>
    <span class="seg kpi" data-kpi="issueops"><span class="dot" id="om-issueops-dot"></span>IssueOps:<span id="om-issueops">ready</span></span>
    <span class="seg kpi" data-kpi="risk"><span class="dot" id="om-risk-dot"></span>Risk:<span id="om-risk">green</span></span>
    <span class="grow"></span>
  `;
  document.addEventListener('DOMContentLoaded', ()=> document.body.appendChild(bar));

  // ---- Modal (reused for all KPIs) ----
  function ensureModal(){
    if (document.getElementById('coagent-kpi-modal')) return;
    const m = document.createElement('div');
    m.id = 'coagent-kpi-modal';
    m.style.cssText = 'position:fixed;inset:0;display:none;align-items:center;justify-content:center;background:rgba(0,0,0,.4);z-index:2147483647;';
    m.innerHTML = `
      <div class="panel" style="width:min(720px,92vw);background:var(--panel-bg,#161a23);color:var(--panel-fg,#e6e9ef);border:1px solid var(--border,#2a2f3a);border-radius:12px;padding:14px;box-shadow:0 10px 40px rgba(0,0,0,.35);">
        <h3 id="kpi-title" style="margin:0 0 8px 0;font-size:13px;"></h3>
        <div id="kpi-body" style="font-size:12.5px;line-height:1.35;"></div>
        <div class="actions" style="display:flex;justify-content:flex-end;gap:8px;margin-top:12px;">
          <button id="kpi-close" style="padding:6px 10px;border-radius:8px;border:1px solid var(--border,#2a2f3a);background:var(--panel-bg,#161a23);color:inherit;">Close</button>
        </div>
      </div>`;
    document.addEventListener('DOMContentLoaded', ()=> document.body.appendChild(m));
    m.addEventListener('click', (e)=> { if (e.target.id==='kpi-close' || e.target===m) m.style.display='none'; });
  }
  function showKpi(title, html){
    ensureModal();
    const m = document.getElementById('coagent-kpi-modal');
    document.getElementById('kpi-title').textContent = title;
    document.getElementById('kpi-body').innerHTML = html;
    m.style.display = 'flex';
  }
  const kpiCopy = {
    guardrails: `<p>The Guardrails index summarizes Backend, BPOE, IssueOps, and Risk. Any red turns the slider towards red; all green keeps it at the green end. <b>High is good.</b></p>`,
    backend: `<p>Backend reflects the CoAgent local service. If down, SLAM and Guardrails degrade and the UI may use an offline fallback.</p>`,
    slam: `<p>SLAM (Safety & Load & Agency Metric) is a composite where <b>higher is better</b>. It drops if backend is down, there are manual overrides, or pending risky changes.</p>`,
    bpoe: `<p>BPOE status shows the current execution pipeline health (build/pack/ops). Blocked = human action required. It feeds into Guardrails and SLAM.</p>`,
    issueops: `<p>IssueOps indicates automations (triage, weekly reports, self-evolve digests). Pending/error states increase risk.</p>`,
    risk: `<p>Risk reflects the highest severity observed. Manual edits to DO blocks or failed checks will raise this.</p>`
  };
  document.addEventListener('click', (e)=>{
    const seg = e.target.closest('.kpi');
    if (!seg) return;
    const k = seg.dataset.kpi;
    showKpi(k.charAt(0).toUpperCase()+k.slice(1), kpiCopy[k] || '');
  });

  // ---- Helpers ----
  function setText(id, val){ const el = document.getElementById(id); if (el) el.textContent = String(val); }
  function setDot(id, level){ const el = document.getElementById(id); if (!el) return; el.classList.remove('ok','warn','bad'); el.classList.add(level); }
  function setThumb(pct){ const t = document.getElementById('om-gi-thumb'); if (t) t.style.left = Math.max(0, Math.min(82, Math.round(pct*82))) + 'px'; }

  // ---- Backend ping ----
  async function pingBackend(){
    try { await fetch('http://127.0.0.1:7681/', {mode:'no-cors'}); setText('om-backend','up'); setDot('om-backend-dot','ok'); }
    catch(e){ setText('om-backend','down'); setDot('om-backend-dot','warn'); }
  }
  setInterval(pingBackend, 5000); pingBackend();

  // ---- SLAM (higher=better) ----
  function slam(){
    let s = 0.90;
    if (document.getElementById('om-backend').textContent !== 'up') s -= 0.20;
    if (document.querySelector('.coagent-do-wrap.edited')) s -= 0.25;
    s = Math.max(0.05, Math.min(0.99, s));
    setText('om-slam', Math.round(s*100) + '%');
    setDot('om-slam-dot', s>=0.75 ? 'ok' : (s>=0.45 ? 'warn' : 'bad'));
    return s;
  }

  // ---- Aggregate Guardrails Index (GI) ----
  function gi(){
    const backendUp = document.getElementById('om-backend').textContent === 'up';
    const bpoe = (document.getElementById('om-bpoe')||{}).textContent || 'idle';
    const issue = (document.getElementById('om-issueops')||{}).textContent || 'ready';
    const risk = (document.getElementById('om-risk')||{}).textContent || 'green';

    const w = { backend:0.25, bpoe:0.20, issue:0.15, risk:0.40 };
    const score =
      (backendUp ? 1.0 : 0.5) * w.backend +
      ({idle:1, ok:1, pending:0.7, blocked:0.3}[bpoe] || 0.8) * w.bpoe +
      ({ready:1, pending:0.7, error:0.2}[issue] || 0.8) * w.issue +
      ({green:1, amber:0.6, red:0.2}[risk] || 0.8) * w.risk;
    setThumb(score); // 0..1
    const level = score>=0.75 ? 'ok' : (score>=0.45 ? 'warn' : 'bad');
    const anyRed = risk==='red' || issue==='error' || bpoe==='blocked';
    // reflect "any red = red" on risk dot
    setDot('om-risk-dot', anyRed ? 'bad' : level);
    return score;
  }

  function tick(){ slam(); gi(); }
  setInterval(tick, 1500); tick();

  // Public bridge
  window.CoAgentOmni = {
    setBackend(up){ setText('om-backend', up?'up':'down'); setDot('om-backend-dot', up?'ok':'warn'); },
    setBPOE(state){ setText('om-bpoe', state); },
    setIssueOps(state){ setText('om-issueops', state); },
    setRisk(level){ setText('om-risk', level); },
    tick
  };
})();
