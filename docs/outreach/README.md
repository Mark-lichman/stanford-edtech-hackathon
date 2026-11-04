# Design-partner outreach

How Lantern finds its first design partners: who we approach, what we ask, how we
decide a stream is working, and how the prospect list is built. Decisions behind this
are in [../decisions.md](../decisions.md).

## Who it is for

Every prospect is judged against one child: **seven, in grade two, reading 12 to 18 months
behind, never identified by her school**, already sure she is bad at reading, and expert
at avoiding any task where she can be seen failing (jokes, snack breaks, "is this right?").
A good partner already sits in a room with her and a trusted adult.

## What "design partner" means here

Not money. A partner gives us one or more of:

- a supervised session with one child, parent or tutor present, notes only, no recording;
- a practitioner's read of a hand-built chapter ("where would your student stop?");
- existing activities that could become quests a child can do alone, indoors, with no tools;
- an introduction to families.

## The four experiments

Each stream has a fixed ask, a sample size and a gate. A stream that misses its gate
gets its ask rewritten once, then is dropped. Templates are in the team's outreach
template doc. The section numbers below refer to it.

**E1: Literacy nonprofits (20 organisations).** Small K-3 tutoring, reading-buddy,
therapy-dog reading and dyslexia-support nonprofits.
- Ask: a 25-minute call, then one observed session with one child.
- Template: section 5, filled in (Lantern, early-stage exploration, three people, no product to sell).
- Framing A/B, 10 organisations each:
  - **A** opens on the child who has decided she's bad at reading.
  - **B** opens on the child who is behind in decoding.

  The persona predicts A. This tells us which problem the sector recognises.
- Gate: 4 replies and 2 calls within 14 days of the last send.

**E2: Small activity-kit companies (10).** Book-plus-activity and early-literacy kit makers.
- Ask: could five existing activities work as solo, indoor, no-tools quests for a seven-year-old?
- Template: section 2.
- Gate: 2 replies.

**E3: Practitioners (15).** Orton-Gillingham, Barton and Wilson tutors, educational
therapists and small structured-literacy centres.
- Ask: read a one-page chapter and say where your student would stop.
- Template: section 3.
- Gate: 3 calls, and at least one introduction to a family.

**E4: Parent communities (5).** Decoding Dyslexia chapter leads and similar parent groups.
- Ask: share a call for parents willing to talk to us.
- Template: section 4.
- Gate: one group shares it.

## Logging

Use the outreach sheet's status columns: Outreach status, Owner, Last contact date and
Next step. Each prospect row carries its experiment (E1 to E4) and, for E1, its framing
arm (A or B). At each gate date, add a dated entry to `../decisions.md`: what was sent,
reply counts, and keep / rewrite / drop.

## How the prospect list is built

[`tool/find_partners.py`](../../tool/find_partners.py) runs web searches through the
Nimble API, one query set per experiment.
- It drops anything already on the sheet, plus large organisations a three-person team won't land.
- It extracts each new domain's page and scores it with keyword counts weighted toward the
  persona: grades K-2, struggling or reluctant readers, confidence and low-pressure language,
  one-on-one, structured literacy, Bay Area.
- Scores only rank the list. Every row added to the sheet was read by a person first.
- Output stays in git-ignored `.cache/`. **No prospect list or contact information is ever
  committed.** Reviewed prospects go straight into the team's private outreach sheet.

    pip install nimble_python
    NIMBLE_API_KEY=... python tool/find_partners.py
    python tool/find_partners.py --test    # self-check, no API calls

## Runs

- **2026-11-04**: first run, 21 queries across E1 to E4. Prospects added to the outreach sheet.
