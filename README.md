# HR Portal — AI-Assisted HR Platform

Internal, **HR-only** web portal for the HR department of a Singapore BCA A1 construction contractor (6-role structure: Head of HR, HR Manager, Executives for Payroll / Foreign Workers / Staff, and HR Assistant).

> **Private repository** — contains internal planning documents. No real personal data: the prototype runs entirely on synthetic data.

## Contents

| Path | What it is |
|---|---|
| `index.html` | **Project hub** — start here; links every document below |
| `hr-portal-blueprint.html` | Roles, tasks & AI-mode mapping (from `HR JOBS.docx`) |
| `HR Portal - Requirements Specification.docx` | SRS v0.2 |
| `hr-portal-architecture.html` | Technical architecture, data flows, AI–PII sandbox |
| `hr-portal-prototype.html` | **Clickable prototype** (synthetic data) — RBAC, compliance monitor, recruitment with agentic workflow designer & real CV text extraction, document generator, knowledge assistant, approvals |
| `hr-portal-gap-analysis.html` | Coverage vs. the full task inventory |
| `hr-portal-roadmap.html` | Phased build plan & effort estimates |
| `hr-portal-brief.html` | One-page management brief |
| `hr-portal-security-plan.html` | Security plan (solo-operator edition) |
| `hr-portal-backup-runbook.html` | Backup & recovery runbook |
| `HR JOBS.docx` | Source job-scope document |
| `test-cv.docx` | Synthetic CV for testing the prototype's parser |

## Key design decisions

- HR-only access via **Entra ID SSO + MFA** (M365 F3 includes Entra ID P1)
- **Human-in-the-loop** on every consequential action; deterministic code (never AI) for statutory/financial math
- **AI–PII sandbox**: models only ever receive de-identified, minimised data through one audited gateway
- Documents/CVs stored in **company M365 (SharePoint via Microsoft Graph)** per IT direction; app + database on a Singapore-region host (Azure recommended) because the database also holds personal data
- HRIQ (HRIS of record) integrated by **scheduled batch extraction** (existing Python-to-Excel scripts), not the costly live API

## Planned repo growth

```
/app        FastAPI backend + React frontend (Phase 0+)
/ingestion  HRIQ extraction & sync pipeline
/infra      Azure infrastructure-as-code
/docs       (these planning documents will move here)
```

Business owner (compliance): Ye Zaw Lin. Built with Claude.
