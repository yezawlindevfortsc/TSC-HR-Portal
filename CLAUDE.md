# TSC HR Portal — Project Context for Claude

Read this first. It is the session-to-session handoff for a solo-build project:
**Ye Zaw Lin (HR, non-developer) builds this entire platform with Claude only.**
He is the named business owner for compliance matters. Explain technical steps
in operator terms; produce runbooks, not just code.

## What this is

An **HR-only** web portal for Tiong Seng Contractors (Singapore BCA A1
contractor). 6-role HR department: Head of HR, HR Manager, Executives for
Payroll / Foreign Workers / Staff, HR Assistant. Heavy compliance context:
MOM, Employment Act, EFMA, CPF, BCA quotas, DRC, FCF, PDPA, WICA/FWMI.
Source of truth for HR duties: `HR JOBS.docx`. Full planning set is in the
repo's HTML documents — start at `index.html` (the hub).

## Non-negotiable design principles

1. HR-only access (Entra ID SSO + MFA; company is on M365 F3 which includes
   Entra ID P1). Never an employee self-service system.
2. Human-in-the-loop on every consequential action; maker-checker + DOA routing.
3. Statutory/financial math is deterministic code — **never an LLM**.
4. AI–PII sandbox: models get minimal, de-identified data through one audited
   gateway; model output is data, never instructions (CV content must never
   become a prompt instruction — prompt-injection hardening in place).
5. PDPA-by-design: SG data residency, retention clock, audit trail.
6. Workflow guardrails are enforced, not optional (e.g. no offer without an
   FCF Gate + human approval on the path — lint blocks publish).
7. Secrets NEVER in chat, code, or git. API keys go into in-app settings
   panels (browser localStorage) for now; Key Vault in the real backend.
8. External security review + pen test required before real personal data
   enters production. Compliance sign-off: Ye Zaw Lin.

## Current state (July 2026)

- **Live demo**: https://tsc-hr-portal.vercel.app (auto-deploys from `main`).
  Deployment is curated via `vercel.json` + `deploy/build-public.sh` —
  internal docs (HR JOBS.docx, SRS, security plan, backup runbook) are
  EXCLUDED from the public site. Keep it that way.
- **`hr-portal-prototype.html`** is the working prototype (synthetic data,
  everything client-side, per-browser localStorage persistence):
  - 6 modules: Dashboard, Compliance Monitor, Recruitment, Documents,
    Knowledge Assistant, Approvals (DOA-tiered). RBAC via role switcher.
  - **Recruitment** is deepest: agentic **Workflow Designer** (drag-drop
    nodes, guardrail lint, publish → the pipeline board is GENERATED from
    the published graph; candidates are workflow instances that advance
    through it), CV upload with **LLM reader** (switchable OpenAI /
    Anthropic / Azure OpenAI; PDFs sent to multimodal models; heuristic
    fallback), **SharePoint filing** via Microsoft Graph delegated auth
    (MSAL popup; filename convention `YYYYMMDD_Role_Name_Experience.ext`),
    Statistics dashboard, hirer list, FCF offer blocking.
- **Docs in repo**: requirements spec (SRS v0.2 .docx), architecture spec
  (incl. AI–PII sandbox, CV pipeline, external actors), gap analysis,
  roadmap (~50–65 eng-wks, 4 phases), management brief (S$ ranges),
  security plan + backup runbook (solo-operator editions).

## Key decisions already made (do not relitigate)

- **HRIQ** (HRIS of record) has a costly API → integrate by **scheduled
  batch extraction** (user's existing Python-to-Excel scripts), not live API.
- **Documents/CVs live in company M365** (SharePoint via Graph; prefer a
  SharePoint document library + `Sites.Selected` app-only permission for the
  backend; current prototype uses delegated `Files.ReadWrite.All`).
- IT says app hosting can be "anywhere", but the **database holds PII** so
  it needs a proper SG-region host — **Azure recommended** (user can get
  access; subscription currently on hold). Vercel is for the static
  demo tier only — the real backend (FastAPI + PostgreSQL + jobs) won't run there.
- Stack for the real build: **Python/FastAPI + PostgreSQL + React**,
  managed services only (solo operator).

## Pending / waiting on

- OpenAI API key (user adding billing) → entered in the 🧠 AI reader panel
  in the live app, never in chat.
- From IT: SharePoint folder URL + Entra app registration (client ID,
  tenant ID; SPA redirect URIs incl. the Vercel URL) → 📁 SharePoint panel.
- Azure subscription decision (unblocks Phase 0: real backend, DB, staging).
- Before real candidate CVs go through the AI reader: PDPA sign-off by the
  user (cross-border processing; Azure OpenAI SG is the residency path).

## Working conventions

- Commit after each verified change; imperative messages; end with
  `Co-Authored-By: Claude <relevant model> <noreply@anthropic.com>`.
- Verify in a browser before declaring done (there is a `.claude/launch.json`
  static server config, port 8642).
- `git push` auto-deploys the public site — check what lands publicly.
- The prototype file is large and single-file by design; keep class names
  stable (JS generates HTML against them).

## Next milestones (roadmap order)

1. Phase 0 foundation once Azure lands: repo scaffold `/app` (FastAPI+React),
   `/ingestion` (HRIQ extraction), `/infra`; Entra SSO; staging deploy.
2. Live SharePoint + AI reader config once IT/OpenAI values arrive.
3. External security review booking before any real PII.
