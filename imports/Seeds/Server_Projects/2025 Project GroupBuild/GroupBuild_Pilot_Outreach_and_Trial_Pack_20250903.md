# GroupBuild — MVP Pilot Trial & Outreach Pack

**Purpose.** Win a fast, local proof of value for multi‑site actions using GroupBuild’s day‑of ops tools (shift coverage, live headcounts, broadcast with SMS fallback).  Free to the organization during the pilot and will continue free while they are trialing or requesting additional features.  

---

## 1) Why these initial targets
- **CUPE local in active action (Toronto area).** Daily/weekly pickets, multi‑site logistics, safety alerts.  
- **ACORN Canada (Toronto/Hamilton).** Frequent tenant actions, mixed connectivity, need for simple headcounts.  
- **350/Sunrise local hub.** Time‑boxed “days of action,” decentralized sites, legal/safety lanes.  

**Selection logic:** high urgency & frequency ⇒ proof in ≤4 weeks; decentralized ops ⇒ coordination pain; heterogeneous tech ⇒ offline‑tolerant QR + SMS differentiator; small enough to decide fast; non‑rip‑and‑replace (exports coexist with existing stacks).

---

## 2) Pilot objectives (customer sign‑off)
The organization selects 3–5 objectives below.  Success will be judged against the paired KPIs.

1. **Increase turnout reliability.**  
   *KPI:* Show‑up rate delta ≥ **+10–25%** (Checked‑in ÷ Committed vs baseline action).  

2. **Stabilize shift coverage across sites.**  
   *KPI:* Coverage ratio (staffed hours ÷ planned hours) ≥ **95%**; zero “dark” sites.  

3. **Speed up last‑minute change comms.**  
   *KPI:* **≥90%** of targeted volunteers receive alerts within **5 minutes**; **≥60%** acknowledgments within **10 minutes**.  

4. **Improve safety messaging discipline.**  
   *KPI:* At least **1** proactive safety broadcast per action and **100%** site leads acknowledge.  

5. **Capture reliable headcounts.**  
   *KPI:* **≥85%** of on‑site participants recorded (QR or manual), per site and per shift.  

6. **Cut organizer coordination time.**  
   *KPI:* **25–40%** reduction in organizer hours on day‑of coordination vs baseline (self‑reported).  

7. **Data portability & ownership.**  
   *KPI:* Clean CSV/JSON export delivered T+24h; **0** unresolved data‑ownership issues; retention ≤ **30 days** unless requested otherwise.

> **Baseline definition.** Use the most recent comparable action day (same org, similar scale) or a 4‑week average where available.  

---

## 3) Success metrics & methods (how we measure)

| Metric | Method | Target |
|---|---|---|
| Show‑up rate delta | Compare Checked‑in/Committed vs baseline action | +10–25% |
| Coverage ratio | Staffed hours vs planned per site/shift | ≥95% |
| Alert delivery & ack | Send test + day‑of alerts (All‑Hands & per‑site); track delivery/acks | ≥90% delivery in 5m; ≥60% acks in 10m |
| Headcount completeness | QR + manual backup; reconcile dupes | ≥85% recorded |
| Organizer hours | Short Effort Log (planning/day‑of/after‑action) | −25–40% vs baseline |
| Data ownership/portability | Export delivered (CSV/JSON) | On time; no issues |

Artifacts produced: dashboard screens (screenshots), CSV/JSON exports, Effort Log summary, 1‑page case study (with org approval).

---

## 4) Scope of the pilot (what’s in / out)

**In:**  
- Shift signup + handoff; per‑site per‑shift rosters.  
- On‑site headcounts: QR posters (offline cache) + manual fallback.  
- Broadcast lanes: All‑Hands, Safety/Legal, Per‑Site; SMS fallback.  
- CSV/JSON exports to coexist with Mobilize/VAN/Sheets.  
- Privacy: opt‑in, auto‑purge ≤30 days (org can request earlier deletion).  

**Out (for now):**  
- Long‑term CRM/list management; petitions/donations; advanced rideshare; native VAN write‑back.  (Light integrations possible post‑pilot via exports.)

---

## 5) What we need from the customer (inputs & roles)

**Before pilot (T‑5 to T‑2 days):**  
- **Pilot Owner** (name, phone, email).  
- **Site list** (names/addresses), planned time windows, expected turnout per site.  
- **Site leads** (one per site) with mobile numbers.  
- **Baseline** metrics (last similar action): committed headcount, actual headcount, organizer hours estimate.  
- **Messaging consent** for a small number of SMS tests to staff/volunteers (or test numbers).  
- **Printing** authority for posters (we provide PDFs).  

**During pilot (day‑of):**  
- Site leads place posters; perform **2–3 headcount sweeps** per shift (QR or manual).  
- Pilot Owner sends/approves broadcasts (we can press send under their instruction).  
- Quick incident notes if safety/legal messages are used.  

**After pilot (T+24–48h):**  
- 15‑minute retrospective call.  
- Approve or edit the 1‑page case study.  

---

## 6) Human effort estimates (to help decision‑makers)

**Organizer effort (Pilot Owner):**  
- Initial setup/config: **45–90 min** (we do most of it live).  
- Poster print & placement coordination: **15–30 min**.  
- Day‑of console/broadcast oversight: **10–20 min per action day**.  
- After‑action export & review: **10–20 min**.  

**Site lead effort (per site):**  
- 5‑minute orientation + poster placement.  
- **2–3 minutes** per headcount sweep, **2–4 sweeps** per shift.  
- **<1 minute** to acknowledge broadcasts.  

**Volunteer effort:**  
- **10–30 seconds** to scan QR and (optionally) confirm contact.  Manual check‑in available.  

> **Net effect (typical 3‑site × 2‑shift action):** +**60–90 min** structured effort replaced by −**2–4 hours** less ad‑hoc coordination and fewer missed shifts.  Your mileage will vary; we document both.  

---

## 7) Timeline (reference runbook)

- **T‑5 to T‑2 days:** ingest site list, create shifts, generate posters, dry‑run SMS + offline cache, share staging link.  
- **T‑1 day:** pilot readiness check (10 min), finalize messaging, print posters.  
- **Day‑of:** test ping at T‑60m; first sweep at T‑15m; live dashboard + low‑coverage alerts.  
- **T+24–48h:** deliver exports; 15‑min retro; share case‑study draft.  

---

## 8) Training presentation (launch module)

**Format:** 10‑slide, 12–15 minutes.  Live or recorded.  (Slides included in separate file: “GroupBuild_Training_Deck.md”.)  

**Slide outline:**  
1. Why we’re here (2‑minute promise).  
2. Today’s pain (missed shifts, unknown headcounts, slow alerts).  
3. What GroupBuild covers (3 features).  
4. Roles (Pilot Owner, Site Leads, Volunteers).  
5. The poster + QR flow (30‑second demo screenshots).  
6. Broadcast lanes and when to use each.  
7. Offline behavior + SMS fallback.  
8. Privacy, retention, exports.  
9. Day‑of checklist (who does what, when).  
10. After‑action + success metrics.  

**Script:** Keep it to 12–15 minutes.  Questions go in a 10‑minute buffer.  

---

## 9) Terms & trust

- **Free during pilot**, and remains **free while trialing or requesting additional features** within the pilot scope.  We’ll agree any paid work *only* after you’re satisfied with pilot outcomes.  
- **You own your data.** We export on request; default retention ≤30 days.  
- **Case study** only with your written approval.  
- **No lock‑in.** GroupBuild coexists with your current stack.

---

## 10) Signature block (customer sign‑off)

By signing, the organization confirms the selected objectives/KPIs, provides the inputs listed in §5, and acknowledges the pilot terms in §9.

- Organization: ______________________________  
- Pilot Owner (name/title): ___________________  Phone: __________  Email: __________  
- Selected objectives (check 3–5): 1 ☐ 2 ☐ 3 ☐ 4 ☐ 5 ☐ 6 ☐ 7 ☐  
- Target action date(s): ______________________  
- Signature: _________________________________  Date: ____________

---

## 11) Attachments (in this pack)

- **GroupBuild_Training_Deck.md** (launch deck).  
- **GroupBuild_Pilot_Signoff_Sheet.md** (one‑page sign‑off, printable).  
- **GroupBuild_Effort_Log_Template.csv** (to capture organizer hours).  

**Contact:** Rick — <phone> — <email/calendly> — Oakville, ON
