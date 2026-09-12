# Work plan — Stanford EdTech Hackathon, 2026-09-12

Sponsor: Epic for Kids (digital reading platform, ages ~12 and under).
Base: HabitCrafts habit engine, adapted. Inspiration: *The Diamond Age*.
Frame: Positive Intelligence, the Judge only. Theme: subversion.

---

## 1. The spine

In *The Diamond Age*, Nell is given the Young Lady's Illustrated Primer: a book
that knows her name, tells her a story she is inside of, sends her on real
missions, and teaches her to read — and in doing so makes her dangerous to the
world that produced her. The Primer's lessons are never exercises. They are
always story.

We build **the Primer**: a book that reads the child, sends them off the screen,
and advances a story only when they come back with something real.

The subversion is structural, not decorative: **the app's success condition is
its own obsolescence.** It gives longer missions, goes dark for longer stretches,
and eventually tells the child it isn't needed anymore. It optimizes for
*anti*-engagement. Every other app in the building will be pitching retention;
we pitch a graph that goes down on purpose.

The screen is the doorway, not the room.

## 2. The loop

One loop, three beats. Everything below serves it.

1. **Read** — the child reads (on Epic, or a physical book — both count).
2. **Quest** — finishing a chapter unlocks exactly one off-screen mission drawn
   from what they just read. Not a comprehension quiz. A thing to *do*:
   "Nell hid a key. Hide something in your house and draw a map to it."
3. **Return** — they come back, show what they did, celebrate, and the story
   they are inside of moves forward one page.

Then the app closes itself.

The Judge (§5) is not a fourth beat. It lives in the gaps — in the margin of the
page, and at the moment a child hesitates or comes back empty-handed.

## 3. What we keep from HabitCrafts, what we burn

Keep — the engine is already right, only the vocabulary changes:
- The habit recipe shape from the `habits` collection: `prompt` (anchor) →
  `behavior` (tiny action) → `celebration` (reinforcement) → `why` →
  `complete[]`. Written already in [lib/hack/study_plan.dart](lib/hack/study_plan.dart);
  becomes `lib/primer/quest.dart`. Rename, keep the field names so a HabitCrafts
  branch is still a copy-in.
- `celebration_suggestions` as a concept → rewritten for 8-year-olds.
- Streak logic → reframed as story chapters, see §5.
- Spaced scheduling (+1/+3/+7) → spacing of *recall* quests about earlier books.

Burn:
- The HabitCrafts palette and Poppins theme I built this morning. Wrong
  audience. Deleting it is the UI/UX redo starting.
- Firebase, FlutterFlow, auth, chat, groups. None of it for demo day.

## 4. UI/UX direction — full redo

Not Material. The app should not look like an app. It should look like a book
somebody's grandmother owned.

- **Surface**: warm cream paper, ink-black text, a single deckled/hand-drawn
  border motif, visible paper texture. No cards, no elevation, no blue.
- **Type**: a serif display face with real personality for the story voice
  (Lora / Crimson / EB Garamond), and one humanist sans only for the few UI
  affordances. The story text is large — 20pt+.
- **One thing per screen.** This is the single biggest departure from the exam
  UI. A 9-year-old gets one page, one quest, one button. Never a list of
  pending tasks; a backlog is a guilt machine for a child.
- **Illustration over iconography.** Ink-drawn marks, not Material icons.
- **Read-aloud is not optional.** A chunk of our users under 12 are weak
  readers, and the whole premise is reading. Every string is tappable to hear.
  Also: the Primer *speaks* in the book — it's canon, not an a11y bolt-on.
- **Tap targets ≥ 56dp**, high contrast, no timed interactions, no loss-framed
  copy ("don't break your streak!" is out; we are not doing dark patterns to
  children).

The Judge gets no screen of its own — grey pencil marginalia on the pages that
already exist, wipeable with a finger. One typeface weight, one colour, always
in the margin. If it ever becomes a modal we have lost the idea.

Screens (five):
1. **Cover** — the book greets the child by name. Asks one question. This is
   also where the Judge first speaks and gets named (§5).
2. **Tonight's Page** — the story beat, then the single quest. Primary screen.
3. **The Return** — proof capture, celebration, artifact earned, story advances.
   Also the "I couldn't do it" path, which is where the intercept lives.
4. **Field Guide** — the collection of earned artifacts. Progress, but as a
   keepsake rather than a scoreboard.
5. **The Dark** — the deliberate lockout. Ink on black, one line of text, a
   countdown, no way in. This screen is the pitch.

## 5. The Judge — Positive Intelligence, awareness only

From Positive Intelligence we take exactly one thing: the **Judge**, the master
saboteur — the voice that says *you're not smart enough, you're a slow reader,
that's baby stuff, you'll mess it up*. We deliberately leave the nine accomplice
saboteurs out. A 9-year-old has not yet built a Hyper-Achiever or a Pleaser;
those are adaptations that harden over years. What they *do* already have is the
beginning of that voice, usually installed by a classroom.

So the goal is not intercepting a saboteur. The goal is **awareness**: the child
learns that the voice exists, that it is a voice and not the truth, and that it
is not them. That is the entire intervention, and at this age it is enough.

This is also where PI and the *Diamond Age* theme turn out to be the same idea.
The Judge is the internalized voice of the system that decided what Nell was
allowed to become. Learning to hear it and answer back *is* the subversion.

How it shows up, in order of importance:

- **The Judge is a character, not a concept.** It appears in the story as a thin
  grey figure. Children this age externalize far better than they introspect —
  a nameable character outside them is developmentally the right handle, and
  it's the same move as naming the Worry Monster.
- **The child names it.** One onboarding beat: the Judge speaks, and the child
  types a name for it. The app uses *their* name for it everywhere after that.
  Naming the villain is a transfer of power, and it's canon for the genre.
- **It writes in the margins.** The Judge never gets a panel, a modal, or a
  lesson screen. It writes in grey pencil in the margin of the page, and the
  child can **scribble over it or erase it** with a finger. Book-native,
  physically satisfying, and defacing the authority's notes is the theme in one
  gesture.
- **The intercept is one tap, at the real moment of friction.** When a child
  hesitates on a quest, or taps "I couldn't do it," the app does not console
  them. It asks: *what did it just say to you?* Three or four options in the
  child's own register, plus a blank. Picking one is the whole exercise —
  noticing is the skill. Then one line back, chosen or spoken aloud.
- **PQ reps become the book's ritual.** Chamine's ten-second sensory exercises
  map cleanly onto opening a book: *press your fingertips together and feel the
  ridges for ten seconds before you turn to your page.* Framed as the Primer's
  ritual, never as an exercise — same rule as §1, the lesson is always story.

Hard limits on this section, because it is psychological content aimed at
children:
- No diagnosis, no scoring, no "your PQ is 62," no profile of the child's
  saboteurs. We never tell a child something is wrong with them.
- The frame is always *everyone hears that voice sometimes; it isn't you.*
- Self-judgment only. We do not scope judging-others or judging-circumstances;
  the reading-confidence voice is the one that matters here.
- The child can always skip it. A quest never blocks on doing Judge work.

## 6. Reinforcement, age-appropriate

The HabitCrafts `celebration` field is exactly right and stays required. What
changes is the design around it:

- **Immediate celebration script**, said out loud, within a second of finishing
  — "Say 'I did that' out loud", "Throw both fists up". Fogg's mechanic; works
  better on kids than adults.
- **Artifacts, not points.** Each completed quest yields one hand-drawn item for
  the Field Guide — a pressed leaf, a map fragment, a key. Collectible, finite,
  ownable. No currency, no XP, no leaderboard, no comparison to other kids.
- **Streaks as chapters.** Internally it's the same consecutive-day count; to
  the child it reads "You have reached Chapter 4." Progress without a number to
  lose.
- **No notifications for the first version.** An app whose thesis is "get off
  the screen" does not buzz.
- **The celebration is the Judge's direct counter.** The Judge's claim is always
  a claim about who the child *is* ("you're a slow reader"). So the celebration
  script answers in the same grammar — "that is who I am now" — and the Field
  Guide is the evidence pile. Reinforcement and §5 are one system, not two
  features that happen to ship together.

## 7. Demo-day scope

Real:
- One child profile, seeded. Three books seeded with a hand-authored quest bank.
- The full loop: page → quest → proof → celebration → artifact → next page.
- Field Guide with two artifacts already earned, so it looks lived-in.
- The Dark, triggerable on demand for the pitch.
- Read-aloud on the story and quest copy.
- The Judge: named in onboarding, two or three scripted marginalia, and the
  one-tap intercept on the "I couldn't do it" path. Hand-authored lines, not
  generated.

Staged / faked, and we say so out loud:
- No Epic integration. Assume no public API; book + chapter data is seeded, and
  the pitch is "this reads Epic's completion events" as the obvious next step.
- No auth, no parent app, no backend. In-memory state only.
- Quest generation is a hand-authored bank keyed to book+chapter. **Not** an LLM
  today — generating quests for children live on stage is the one place a bad
  output kills the demo. Claude-generated quests with a human review queue is the
  roadmap slide, not the build.

## 8. Build order

Assumes roughly a full working day left, one or two people. Cut from the bottom.

- **0:00–0:30** Lock the decisions in §10. Name the thing.
- **0:30–1:45** One content block, all the writing at once: rename the engine
  into `lib/primer/quest.dart`, the quest bank for three books, the Judge's
  marginalia lines, the celebration scripts. This is the demo's soul; do not
  rush it and do not split it across the day.
- **1:45–3:00** Visual system: paper theme, type scale, border motif, margin
  treatment. Build it as a real theme file, not per-screen styling.
- **3:00–3:30** Cover + the Judge naming beat.
- **3:30–4:45** Tonight's Page, including marginalia render and finger-wipe.
- **4:45–5:45** The Return — proof capture, celebration, artifact award.
- **5:45–6:15** The intercept on the "I couldn't do it" path.
- **6:15–7:00** Field Guide.
- **7:00–7:30** The Dark.
- **7:30–8:00** Read-aloud pass (`flutter_tts`) over all copy.
- **8:00–9:00** Seed a believable state, then rehearse the three-minute run
  twice. Rehearsal is not optional and is the first thing people cut.

Adding §5 pushed this past a single day — it is now about nine hours of work,
so something below will get cut and it is better to choose now than at hour
seven. Cut in this order: read-aloud, then Field Guide polish, then the
finger-wipe gesture (ship static marginalia), then the Cover naming beat
(pre-name the Judge in the seed data).

Never cut: **The Dark**, the **intercept**, and the two rehearsals. Those three
are the argument.

## 9. Risks

- **Anti-sponsor read.** "Put down the screen" can land as "stop using Epic."
  Frame it as Epic-complementary throughout: we are the layer that turns Epic
  reading minutes into off-screen action and sends the child *back* for the next
  chapter. We increase the value of a reading minute; we do not compete for it.
- **Self-reported proof is gameable.** A kid can tap "done" and lie. State this
  as a deliberate choice — surveilling a child contradicts the premise that the
  Primer belongs to *them*, not to their parents — rather than letting a judge
  discover it. Voice proof (§9) is the strong middle ground.
- **Content safety.** Quests send children into the physical world. Every quest
  in the bank must be doable indoors, alone, with no tools, no strangers, and no
  going outside. Review the whole bank against that before demo.
- **Psychological content aimed at children.** §5 is the part a judge could
  fairly push on. Be ready to say, unprompted, what we deliberately did *not*
  build: no diagnosis, no PQ score, no saboteur profile, no data on the child's
  emotional state leaving the device, and the child can skip every bit of it.
  "We took one concept and only to the depth of awareness" is a stronger answer
  than being caught having shipped a clinical instrument for nine-year-olds.
- **Scope.** Five screens, a content bank, and the Judge layer in a day is over
  budget by design — see the cut list in §8. The Field Guide is the one that
  will balloon.

## 10. Decisions needed before the 0:30 mark

1. **Proof mechanic.** Self-report tap (zero friction) / photo of the thing they
   made / **10 seconds of the child reading aloud** / parent co-sign. Read-aloud
   is my pick: it demos beautifully, it is a real reading-fluency signal Epic
   would want, and it is the Miranda thread from the novel — a voice on the other
   end. Parent co-sign is the one I would avoid; it hands the Primer to the
   adults and kills the subversion.
2. **Hours actually left, and team size.** The §7 timeline assumes ~8 and 1–2
   people; it changes shape at 4 hours or at 5 people.
3. **Name.** "Primer" is legible to anyone who has read the book and meaningless
   to everyone else. Kid-facing alternatives welcome. The Judge needs a default
   name too, for the seed data and for the case where we cut the naming beat.
4. **How far the Judge goes in the demo.** Marginalia only (cheap, atmospheric,
   reads as flavour) or marginalia plus the intercept (the actual intervention,
   ~30 extra minutes, and the thing that makes §5 a feature rather than a
   mood). I would build the intercept and cut Field Guide polish for it.
