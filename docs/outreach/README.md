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
- Ask (first message): a 20-minute conversation with a group lead about what families try.
  We don't ask volunteer-run groups to forward anything to their members. If a lead offers
  to share a call for parents, we accept.
- Template: section 4, rewritten for the group lead.
- Gate: one conversation with a lead.

## The message sequence

Three messages per prospect, then stop. The mission and the ask carry the message, not
the follow-ups. Each follow-up gives the reader something new or makes the ask smaller,
and the last one lets them off the hook.

- **M1, day 0.** 75 to 125 words, plain text, one personal line about their program,
  one ask (20 minutes in the next two weeks), an offer to send them our summary, and
  "reply 'no thanks' and I won't write again". Subject: plain and specific, e.g.
  "question about [organisation]'s reading tutoring".
  - One link line above the opt-out. E1 nonprofits get lanternbook.org/pilot/, the page
    for schools and nonprofits. Practitioners and parent groups get lanternbook.org.
  - The signature reads "Lantern · lanternbook.org".
  - **Links are typed by hand in Gmail.** The Gmail connector rewrites every URL it saves
    or sends into a `google.com/url?q=…` redirect, which reads as phishing. That happens
    with both explicit links and plain domain text. Drafts carry ⟦PILOT LINK⟧ and
    ⟦SITE LINK⟧ placeholders, and the sender types the real address in the Gmail compose
    window before sending. Follow-ups drafted the same way.
- **M2, 4 to 5 business days later,** as a reply in the same thread:

  > Hi [team], a short follow-up to my note last week. One thing we keep hearing: children
  > this age often avoid reading aloud because being seen to struggle hurts more than not
  > knowing. That's why [program] matters to us. If a call is hard to fit in, two lines by
  > email would help just as much: where do children most often stop? Thanks, Mark

- **M3, 5 to 6 business days after M2,** in the same thread:

  > Hi [team], I'll assume now isn't the right time, and that's completely fine. I'll still
  > send you our short summary when it's ready, unless you'd rather I didn't. If talking is
  > ever useful, just reply. Best, Mark

- No fake urgency, no "bumping this up", no open tracking, no guilt in the last message.
- Send on Tuesday or Thursday mornings in the recipient's time zone. Skip holidays and
  Thanksgiving week.
- Replace the M2 finding with something we've actually heard once calls start.
- **Before wave 2:** add a mailing address to the signature (CAN-SPAM; a P.O. box is fine).

### Why these numbers

Sources were gathered on 2026-11-04. Figures from vendors that sell sending tools are marked,
since they gain when people send more.

- **Waves of 12.** That is about four calls if a quarter reply, which the team can actually take.
  It also tests the copy on a third of the list before spending the rest. This is a capacity
  judgement, not a benchmark.
- **Three messages.** In one agency's analysis of 1,857 replies, 62% came from the first email,
  21% from the second, 13% from the third and 5% from anything later
  ([BusySeed](https://v7.busyseed.com/research/where-cold-email-replies-actually-come-from)).
  Returns roughly halve with each step, so a fourth message mostly adds annoyance.
- **Spacing.** Vendors suggest 3 to 7 business days with widening gaps (Instantly, vendor).
  We use the slow end of that range as a grace period for busy people.
- **Personal lines.** In a Cochrane review of response-rate trials, personalised requests had
  1.24 times the odds of a response
  ([Cochrane](https://cochranelibrary.com/cdsr/doi/10.1002/14651858.MR000008.pub5/information/en)).
- **Gate.** Generic research-recruitment email gets 2 to 3% replies and B2B cold email
  3 to 7% (vendor figures). Carefully targeted, mission-aligned asks can reach 15 to 30%
  ([Lean B2B](https://leanb2bbook.com/blog/b2b-customer-interviews-with-cold-emails/)).
  Our gate is **15% replies** (2 of 12). **Under 10% means rewrite M1** before the next wave.

## Wave 1 (sent from Mark's Gmail, reviewed before sending)

- 12 prospects: E1 has 8 (4 in arm A, 4 in arm B), E3 has 2 and E4 has 2. E2 waits until
  its list reaches 10.
- Bay Area organisations go first, since an observed session needs to be in person.
- Schedule (M1, then M2, then M3):
  - Batch 1: Thu Nov 5, Thu Nov 12, Thu Nov 19.
  - Batch 2: Tue Nov 10, Tue Nov 17, Tue Dec 1.
  - Batch 3: Thu Nov 12, Thu Nov 19, Thu Dec 3.
- **Score wave 1 on Thu Dec 10.** Record replies, calls and the A versus B result in
  `../decisions.md`, then decide whether wave 2 sends as is or rewritten.

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

- **2026-11-04**: first run. 21 queries returned 180 results across 127 new domains; most
  were news stories, listicles or out-of-range organisations.
  - 39 prospects were read by hand and added to the sheet's "Design Partners (Nov 2026)" tab:
    - E1: 17 nonprofits (9 in arm A, 8 in arm B) and 4 research partners;
    - E2: 4 kit makers;
    - E3: 8 practitioners;
    - E4: 6 parent groups.
  - **E2 is under-filled** (target 10). Re-run with narrower kit queries before sending.
  - E1 has 5 Bay Area organisations. Lead with those, since the observed session needs to be in person.
