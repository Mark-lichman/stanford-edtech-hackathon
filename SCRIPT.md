# The script — three minutes on stage

Track E owns this file. The run is 1:52; the stage slot is 3:00. That is
**~365 spoken words**, not 450 — the gap is deliberate. The Dark plays in
silence and the silence is the argument.

Two people: one **presents**, one **drives**. Decided before the last ninety
minutes, not during. The driver holds each beat until the line for it lands —
the timecodes below are the floor, never a metronome.

Word counts are per beat. If a beat runs long in rehearsal, cut words, never
add time.

---

## Cold open — the problem, before the first tap  ·  ~35s  ·  88 words

> A nine-year-old who is behind in reading learns two things at once. That she
> is bad at this. And that the system she is in has already decided it. One of
> those is a voice in her head and the other is a reading level on a file, and
> by nine she cannot tell them apart.
>
> We wanted to hand her back her own story without pulling her out of the system
> she still has to live inside. Same shelf. Same books. She just stops reading
> them as somebody's assignment.

Beat. Then:

> In *The Diamond Age*, Nell is given a book that knows her name, tells her a
> story she is inside of, and teaches her to read — and in doing so makes her
> dangerous to the world that produced her.
>
> We built that book. It runs four minutes a night, and everything that matters
> happens after it closes.

Hold on the Cover through all of it. Do not tap until "after it closes."

Nell is the answer to the problem, never the opening image. If you find yourself
opening with *The Diamond Age*, you have started with our reference instead of
her situation.

## 0:12 Grumble — where Positive Intelligence gets named  ·  46 words

> At around nine, most children start hearing a running commentary on
> themselves. Positive Intelligence calls that voice the Judge. We took one idea
> from it and only to the depth of awareness: we draw him in the margin, in grey
> pencil, and she rubs him out and names him.

**Optional inline clause** — drop it in only if the judges look like the kind who
ask, or if you have been told there is no Q&A. +22 words, and it costs you the
Doors line below:

> No diagnosis, no score, no profile, nothing about her leaving the device, and
> she can skip all of it.

Named once either way. If it comes back, it comes back in Q&A.

## 0:28 Three doors  ·  18 words

> Three real books. One is something she already loves. She picks — we only
> decide what gets offered.

This is the line to cut if you used the optional clause above.

## 0:38 The way in — where Tiny Habits gets named  ·  44 words

> Eighty words, a hook, and a question she now needs answered. Then the quest:
> *after you close the book tonight.* That is an anchor and a tiny behaviour —
> BJ Fogg's recipe, from the Behavior Design Lab here. The book writes the other
> four thousand words.

The anchor is on screen as its own line when you say it — see the build note at
the bottom. The `prompt` / `behavior` / `celebration` / `why` fields in
[doorways.dart](lib/primer/content/doorways.dart) **are** the recipe. That is the
slide; there is no slide.

## 0:55 The handoff — say the mock out loud, first  ·  30 words

> Epic has no public API, so this reader is ours, standing in for theirs. The
> intent is a handoff: we write eighty words a night, and the real book writes
> the other four thousand.

Say it **before** the tap, not after, and in the same tone as everything else.
A limitation you announce is a design decision; the same limitation discovered
by a judge is a gap. There is no version of this where we let a room assume the
mock is Epic.

## 1:02 The Return  ·  28 words

> Twenty minutes reading, fifteen doing the quest, all of it off our screen.
> She comes back and reads one line out of the book, aloud, for ten seconds.

Then **stop talking** while the hold happens. If the mic is denied, the fallback
is on screen and it is not an apology — see the fallback line below.

## 1:18 Celebration — Fogg pays off, unnamed  ·  33 words

> She says it out loud, and that is the whole reinforcement. No points, no
> badges. And the noun goes on the page, never on the child — hand a nine-year-old
> an identity and you have handed the Judge something to take away.

**Optional — the page that isn't hers.** PLAN.md §11, and the last thing in the
pitch that is allowed to be cut without discussion. Short form, 12 words, use
this one by default:

> And one page in her guide isn't hers. Somebody got there first.

Long form, 27 words, only if both rehearsals came in under 1:52 with air to
spare — it makes Celebration the longest beat in the run:

> One page in her guide isn't hers — somebody got there first. Other children are
> out there, and none of them is a score she can lose to.

Either form, the driver holds on the guide while it lands and does not point at
the page. The moment it becomes a thing being demonstrated it reads as a
feature, and it is not a feature — it is a content swap we seeded.

The reason it is in the pitch at all: it tells a child who thinks she is the
slow one that other people are out there doing this too, without ever putting
someone in front of her to measure herself against. That is the argument. It
does not survive being explained on stage, so do not explain it — say the line
and move to the intercept.

## 1:28 The intercept  ·  26 words

> Night four. She could not do it. The book does not console her — it asks what
> it just said to her, and one option is about the night, not about her.

## 1:40 The Dark  ·  0 words

Say nothing. Let it sit. The countdown is the pitch.

## Close — back to the problem  ·  ~20s  ·  52 words

> Every other app here optimises for retention. This one optimises for its own
> obsolescence — longer missions, longer dark, until it tells her it is not
> needed.
>
> She is still on the same shelf, reading the same books, inside the same
> system. It is just her story now.
>
> That is Lantern. Thank you.

---

## The fallback lines — rehearse these as hard as the script

Mic denied, or the room is too loud:

> She can always say *I'd rather not talk tonight*, and the artifact still
> comes. A book that punishes a child for not performing is the wrong book.

Asked whether the Epic handoff is real:

> The books are real and the catalogue is real — those are live Epic titles.
> The reader is ours, because there is no public API to open theirs with.

Both are said in the same tone as the rest. A fallback announced as a failure
becomes one.

## What we never say

The three from PLAN.md, unchanged: ten seconds is **proof of work**, not a
fluency measurement — no score, no number, shown to nobody. Not **"less screen
time"** but displacement. Never **"2 sigma."**

Three more that only exist because the frameworks are now named out loud:

- Never **"saboteur"** on stage. It is clinical vocabulary, it invites the
  diagnosis question, and the child-facing word is Grumble.
- Never **"we teach her Sage"**, or reframing, or affirmations. We stopped at
  noticing on purpose and the stopping is the strong part.
- Never **"habit-forming"** about our own app. Fogg's recipe is pointed at
  reading a book, not at opening Lantern. Say "the habit is the book."

And one from the page that isn't hers:

- Never **"social"**, **"community"**, **"feed"**, or **"other kids"** about it.
  Those words promise a system we did not build and invite the moderation
  question before we have said the seeded part. It is a page somebody left
  behind — that is the whole vocabulary.
- Never a **name**, an **age**, or a **school** attached to that page, on stage
  or on screen. The one we seeded has none, and saying one out loud invents it.

And one from the new open:

- Never frame the system as the villain. Not school, not reading levels, not
  Epic — Epic is in the room. The tension is that she has no authorship inside
  it, and we give her authorship without asking her to leave.

## Q&A — the three questions this pitch invites

**"Is this Positive Intelligence for kids? Are you assessing children?"**

> No. We took one concept — the self-critical voice — and only to the depth of
> awareness. What we deliberately did not build: no diagnosis, no PQ score, no
> saboteur profile, no emotional-state data leaving the device, nothing shown to
> a parent, and she can skip every bit of it. He also appears *less* over eight
> weeks, not more. A permanent resident would be a permanent fact about herself.

**"Isn't Tiny Habits just a behaviour loop with a book on top?"**

> The recipe is Fogg's and we use it straight: anchor, tiny behaviour,
> celebration she says out loud. Two departures. The behaviour is off our
> screen, so the reinforcement never points back at the app. And the
> celebration's noun lands on the artifact, not on the child.

**"So is the Epic integration real?"**

> The titles and the catalogue are. The reader is a mock, because Epic has no
> public API — the integration we are showing the intent of is a handoff, and
> the handoff is the product. We write eighty words; their library writes the
> rest.

**"Whose page is that? Is there a social layer — who moderates it?"**

> There are two or three artifacts in that pool and we drew them. Nothing a
> child wrote reaches another child: no accounts, no names, no chat, no
> profiles, no free text. The stories touch; the children don't. Anything that
> needed a moderation answer is out of scope by design, not by deadline.

Answer it in that order — seeded first, then the rule. Leading with the rule
sounds like a policy we wrote after somebody got hurt.

All four are short on purpose. The long version is the one that sounds
defensive.

---

## What this script needs built

- **Track B, `way_in.dart`** — render the anchor (`prompt`, "After you close the
  book tonight") as its own line above the quest, plain, no label. The line at
  0:38 names it out loud, so it has to be visibly a separate thing on the page.
  Labelling the three parts is the wrong answer — that is a diagram, and PLAN.md
  §4 says this looks like a book.
- **Track B, `celebration.dart`** — render `Run.leftBehind` under her own
  artifact, quieter and no name on it. `BookPage` plus a `MarginNote` off the
  existing barrel does it, so this waits on nobody's new widget. Her artifact
  has to read first and larger or the 1:18 line lands on the wrong page.
- **Track D** — a mock reader page for *Hilda and the Troll*, not a
  `url_launcher` tap. Epic has no public API. The door still opens; it opens
  ours, and we say so at 0:55.
