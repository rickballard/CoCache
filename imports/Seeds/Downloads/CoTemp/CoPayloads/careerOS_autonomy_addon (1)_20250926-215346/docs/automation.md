# Automation & Transparency

careerOS uses **transparent schedulers** so that evolution is deliberate, not hidden.

## What runs on a schedule
- `.github/workflows/bimonthly-checkin.yml`: opens a check-in issue on the 1st and 15th (14:00 UTC).
- `.github/workflows/email-nudge.yml`: _optional_ monthly email on the 1st (15:00 UTC), only if secrets are configured.

## Configure email (optional)
Set repo secrets (Settings → Secrets and variables → Actions):
- **TO_EMAIL**: your email address
- For Mailgun: **MAILGUN_DOMAIN**, **MAILGUN_API_KEY**
- For AWS SES: **SES_REGION**, **AWS_ACCESS_KEY_ID**, **AWS_SECRET_ACCESS_KEY**, **FROM_EMAIL**

## Why issues (and not “interrupting ChatGPT”)?
GitHub can’t message ChatGPT directly. Instead, we:
- Open Issues/Discussions as prompts you control.
- Optionally email you a link to the repo when it’s time to reflect.

## Local reminders (optional)
Use `tools/Schedule-LocalPrompt.ps1` with Windows Task Scheduler to pop a local reminder and open the repo URLs.
