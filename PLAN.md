# Lantern — work plan, Stanford EdTech Hackathon, 2026-09-12

Sponsor: Epic for Kids (digital reading platform, ages ~12 and under).
Base: HabitCrafts habit engine, adapted. Inspiration: *The Diamond Age*.
Frame: the self-critical voice, awareness only. Theme: subversion.

**Decided (§10):** name is **Lantern**; the Judge's default name is **Grumble**
(the child renames it on the Cover). Proof of work is **ten seconds of the child
reading aloud**. The Judge ships as **marginalia plus the intercept**. We have a
**full day and three or more people**, so nothing in §8 gets cut — including
read-aloud.

Concept user journey (the pitch document, shareable):
https://claude.ai/code/artifact/f1fd0a26-a0f7-4f50-a141-15d64ccbe839
Source is [pitch.html](pitch.html) — republish that file to the same URL.

---

## Three things not to say on stage

- **Don't call ten seconds a fluency measurement.** It's proof of work. We
  produce no score and show no number to anyone.
- **Don't say "less screen time."** Say displacement: four screen minutes that
  buy twenty minutes of reading and fifteen off the screen entirely.
- **Never say "2 sigma."** It didn't replicate, and we aren't a tutor anyway.


## 1. The spine

In *The Diamond Age*, Nell is given the Young Lady's Illustrated Primer: a book
that knows her name, tells her a story she is inside of, sends her on real
missions, and teaches her to read — and in doing so makes her dangerous to the
world that produced her. The Primer's lessons are never exercises. They are
always story.

We build **the Primer**: a book that reads the child, sends them off the screen,
and advances a story only when they come back with something real.

The subversion is structural, not decorative: **the app's success condition is
time off the screen.** Every night closes itself, it gives longer missions and
goes dark for longer stretches, and the story only grows while she's away. It
has no fixed length and no finish date: she keeps building her story for as long
as she wants, because that is good for her, not because we need her back. It
optimizes for *anti*-engagement. Every other app in the building will be pitching retention;
we pitch a graph that goes down on purpose.

The screen is the doorway, not the room.

## 2. The loop

One loop, four beats. Everything below serves it.

1. **Choose** — three doors, and **each door is a real book**. One is home
   ground (something she already loves), the others are one and two steps out.
   She picks; we only decide what gets offered.
2. **The way in** — Lantern writes roughly **eighty words**: a setup, a hook,
   and a question she now needs answered. Then it hands her the book and the
   quest, and closes itself.
3. **Read and do** — off our screen entirely. ~20 minutes reading the actual
   chapter, then ~15 minutes doing the quest, which is cut from that chapter so
   it only makes sense once she's read it. No quiz needed to prove she did.
4. **Return** — ten seconds reading a line **out of that book**, aloud. She has
   to hunt for the line, which is the part that builds a reader. Then the
   celebration, the artifact, and the story moves forward one page.

Then the app closes itself again.

**The division of labour is the product.** Lantern writes ~80 words a night;
the book writes the other ~4,000. We have no library and never will.

The Judge (§5) is not a fifth beat. It lives in the gaps — in the margin of the
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

Screens (six):
1. **Cover** — the book greets the child by name, asks what she already likes,
   and this is where Grumble first writes and gets named (§5).
2. **Three doors** — tonight's three real books. She picks. One screen, three
   options, nothing else on it.
3. **The way in** — Lantern's eighty words, then the quest, then it closes.
   Hands off to Epic for the actual chapter.
4. **The Return** — read a line aloud from the book, celebration, artifact,
   story advances. Also the "I couldn't do it" path, where the intercept lives.
5. **Field Guide** — earned artifacts, shown **in use** and never as a grid with
   empty slots. A keepsake, not a scoreboard, and no counter anywhere.
6. **The Dark** — the deliberate lockout. Ink on black, one line of text, a
   countdown, no way in. This screen is the pitch.

## 5. Grumble — the voice that says she can't

Around nine, most kids start hearing a running commentary on themselves, and for
a kid who's behind in reading it says something specific and cruel. We are not
trying to fix that. We make it **visible**.

- **A character, not a lesson.** He writes in grey pencil in the *margin* of the
  page, and she rubs him out with a finger. If he ever becomes a pop-up, we've
  lost the idea.
- **She names him.** One beat on the cover; the app uses her name for him after
  that. Steer the naming toward creatures — offer a shortlist with "or make one
  up" — so nobody ends up erasing a figure named after their dad.
- **Drawn, never voiced.** No audio, no speech bubbles, no first person.
- **The intercept is one tap, at real friction.** She taps "I couldn't do it";
  the book doesn't console her, it asks *what did it just say to you?* Two
  options, and at least one about the situation ("today was too full") rather
  than about her. She taps one, the book says "You heard it. That's the hard
  part," and lets it go.
- **Noticing is the whole skill.** No reframing, no affirmations, no score, no
  profile, nothing stored, nothing shown to an adult, and always skippable.
- **He retires.** Grumble appears *less* over time, not more. Design
  his fade-out from day one — a permanent resident is a permanent fact about
  herself.

Hard line: no diagnosis, no measurement, and we never claim a mental-health or
SEL benefit. It's a character in a story.

## 6. Reinforcement

- **The celebration is hers, said out loud.** "Say it: *I did that.*" The app
  confirms in under a second; the feeling comes from her own voice.
- **The noun goes on the object, never on the child.** Not "you're a reader now"
  — *"You read this in the dark, when it was hard. It belongs in the book now."*
  Hand a kid an identity and you've handed Grumble something to take away on a
  bad night.
- **No superlatives.** No "Amazing!", no "Incredible!". Specific and true, or
  nothing.
- **Artifacts, not points.** No XP, no coins, no badges, no leaderboard. Epic
  already issues 25 million badges a year; we lose that fight by entering it.
- **No collection grid.** No empty slots, no counter, no "3 of 12." The moment
  there's a set to complete, the set becomes the goal. Artifacts appear only in
  use, changing what her character can do.
- **Unannounced.** Never a "finish this and you'll earn X" screen. It arrives as
  something the story hands her, and on some nights not at all.
- **One ability a week, eight in total** — granted by a companion in dialogue,
  never a level-up banner, and only real if it changes what tomorrow's three
  doors can ask of her.
- **Chapters, not streaks.** Same arithmetic underneath, nothing to lose. No
  dates, no "last read" timestamps, and let some chapters span two sessions so
  the number can't be converted into attendance.

## 7. Demo-day scope

Real:
- One child profile, seeded. **Three real book titles**, and **one of them
  authored end to end** — the doorway page, the quest, the line she reads back,
  the artifact. The other two are real doors with nothing behind them yet, and
  we don't tap them on stage.
- The full loop: three doors → the way in → read the book → do the quest →
  read a line aloud → celebration → artifact → next page. Audio is checked
  on-device and discarded: nothing stored, nothing sent, no transcript.
- **The handoff to Epic.** On stage we tap a door and it opens the real book:
  https://www.getepic.com/book/62843717/hilda-and-the-troll — or a mocked
  reader if the link is unreliable on venue wifi. Either way we say plainly
  which one it is.
- Field Guide with two artifacts already earned, so it looks lived-in.
- The Dark, triggerable on demand for the pitch.
- Read-aloud on the story and quest copy.
- The Judge: named in onboarding, two or three scripted marginalia, and the
  one-tap intercept on the "I couldn't do it" path. Hand-authored lines, not
  generated.

### The book, and why this one

**Hilda and the Troll**, Luke Pearson —
https://www.getepic.com/book/62843717/hilda-and-the-troll

Two numbers decided it, and neither is taste.

**Fifteen to thirty minutes**, per Epic's own listing. It is the only book we
found that matches §2's "~20 minutes reading the actual chapter" *whole*.
Everything else we looked at ran two to four hours, which means slicing a
chapter out and hoping the quest still makes sense without the rest. Here she
finishes a book on a school night, which is a better thing to say on stage than
anything we could have written.

**GN530L, AR 3.3.** The other candidates ran 720L to 1090L. Our child reads a
year and a half below grade and has to read a line *out loud*; 530L is the
difference between the Return beat working and it being the moment the demo
dies.

Then the rest of it lines up. The whole six-book series is on Epic, so reach
widening is a real walk through real books — Midnight Giant, Bird Parade, Black
Hound, Stone Forest, Mountain King. Hilda is a girl, which our Maya is. And the
real-world project is the character's own practice: she looks at something for
longer than anybody would, draws it, names it. **That is the Field Guide
screen.** The keepsake in §4 isn't a feature we bolted on; it's what the
protagonist already does, and night one's artifact is page one of it.

One deliberate divergence: Hilda goes outside and we do not send children
outside. The quest keeps the looking and drops the going. A shelf nobody has
ever looked behind is as unexplored as a wilderness when you're nine.

Ruled out, with reasons, so nobody re-proposes them: **Magic Tree House** and
**Hamster Princess** — Epic's own pages send people to Amazon for Magic Tree
House, and no `getepic.com/book` id was findable for Hamster Princess. A door
that opens nothing kills the pitch in ten seconds. **Captain Underpants** and
**Dog Man** are both really on Epic and Dog Man stays in the repo as the
verified fallback, with its quest authored. **The Franklin books** were a
nonfiction activity bank at 970–1090L: too hard, and §1 says the lessons are
never exercises.

Staged / faked, and we say so out loud:
- No Epic integration. Assume no public API; book + chapter data is seeded, and
  the pitch is "this reads Epic's completion events" as the obvious next step.
- No auth, no parent app, no backend. In-memory state only.
- Quest generation is a hand-authored bank keyed to book+chapter. **Not** an LLM
  today — generating quests for children live on stage is the one place a bad
  output kills the demo. Claude-generated quests with a human review queue is the
  roadmap slide, not the build.

## 8. Who owns what

Three people, three tracks. The tracks are drawn so **nobody waits on anybody**
— each seam is a file one person owns and the others only read.

### Amlan — the book source (Epic)

**Owns:** `lib/primer/epic.dart`. Nothing else. No UI, no content.

Start here, because it will save you an hour: **Epic has no public API, SDK, or
developer program.** I checked. The only partner surfaces are content/publisher
deals and the Educator Ambassador programme. Also, searching "Epic API" mostly
returns **Epic Systems** (hospital software) and **Epic Games** — different
companies, ignore both.

So the real job is to find out what we *can* legitimately do, in this order:

1. **Deep links — settled, and smaller than we thought.** There is no public
   Epic API, so the demo does not tap out to Epic at all: the reader is ours and
   we say so before the tap ([SCRIPT.md](SCRIPT.md), 0:55). That retires the
   three questions that used to live here — app installed, app missing, signed
   out — and takes venue wifi out of the critical path, which is worth more than
   a real tap was. `getepic.com/book/{id}/{slug}` is still a real, stable public
   URL shape and the ids stay in `lib/primer/book.dart` as documentation. Only
   `62843717` is confirmed to open; the rest carry `linkConfirmed: false` until
   somebody looks. **If you have five spare minutes, re-check the other Hilda
   ids** — not because the demo needs them, but because the walk through the series is a
   better story when every door is real.
2. **Book metadata.** Title, cover image and reading level are hand-entered
   already. If there's a feed, good; if not, we're fine — do not build a
   scraper today.
3. **Anything official** — a partner page, a developer contact, an Ambassador
   route. If you find one, that's a slide, not a build.

**Your deliverable is not an integration. It's a filled-in class.** I'm writing
`BookSource` with a seeded implementation first thing, so the demo works whether
or not you find anything. You either fill in a real one or we ship the stub and
say so on stage. **Time-box the search to 90 minutes**, then tell me what you
found and switch to helping with content.

### Aditya — the base UI/UX

**Owns:** `lib/primer/theme.dart` and `lib/primer/widgets/`. Not the screens.

**Start immediately, you block Track C.** Ship the theme file before anyone
builds a screen against it.

1. **The theme** — palette, type scale, paper texture, spacing. The published
   journey is the visual reference; steal directly from it. Parchment ground,
   ink-brown text, one warm accent for the lamp/celebration and one berry accent
   for the quest. Not Material, no cards, no elevation, no blue.
2. **The shared widgets** — the paper `Page` card, the `MarginNote` (grey pencil,
   rotated, finger-wipeable), the `Door` row, the `HoldToTalk` control, and the
   full-bleed dark and green panels. These are what I compose the screens from,
   so the API matters more than the pixels: keep them dumb, take content as
   parameters, own no state.
3. **Read-aloud** wired as a theme-level concern from the start, not bolted on
   at hour seven.

Constraints that aren't negotiable: one thing per screen, tap targets ≥56dp,
20pt+ story text, no loss-framed copy, no counters or progress bars anywhere.

### Mark — the journey, the content, the engine

**Owns:** `lib/primer/quest.dart`, `lib/primer/content/`, `lib/primer/screens/`,
and the wiring.

1. **First 30 minutes, before anything else:** write the `BookSource` interface
   and `Book` model, with a seeded implementation. Push it. That unblocks Amlan
   (he has a shape to fill) and me (I can build the whole journey against fake
   data).
2. **Content** — the three doors, and for each: Lantern's eighty words, the
   quest cut from that chapter, the line she reads back, the artifact. Plus
   Grumble's marginalia, the two intercept options, the celebration lines. This
   is the demo's soul and it is writing, not coding.
3. **Screens**, composed from Aditya's widgets as they land.
4. **Integration and the demo script.**

### The seam that matters

```
Book        — id, title, coverUrl, deepLink, level      (Mark writes, Amlan fills)
BookSource  — Future<List<Book>> doorsFor(interest, reach)
              SeededBookSource  ← ships today, always works
              EpicBookSource    ← Amlan, only if there's something to build
```

**The demo never depends on Amlan finding an API.** If he does, we swap the
implementation and it's a better slide. If he doesn't, `SeededBookSource` ships
and we say plainly on stage that the book data is hand-entered and the handoff
is a deep link.

### Last 90 minutes, all three

Seed a believable state. Rehearse the three-minute run **twice**, on the actual
demo device, on venue wifi. Decide who presents and who drives. Rehearsal is not
optional and it is the first thing every team cuts.

### If a track falls behind

Cut in this order: Field Guide polish → the finger-wipe gesture (ship static
marginalia) → the Cover naming beat (pre-name Grumble in the seed data).

Never cut: **The Dark**, the **intercept**, the **read-aloud**, and the two
rehearsals.

## 9. Risks

- **Anti-sponsor read.** "Put down the screen" can land as "stop using Epic."
  Frame it as Epic-complementary throughout: we are the layer that turns Epic
  reading minutes into off-screen action and sends the child *back* for the next
  chapter. We increase the value of a reading minute; we do not compete for it.
- **Read-aloud is the demo's single point of failure.** A hackathon room is
  loud, mic permission on the web build is a prompt nobody rehearsed, and a shy
  child freezing is the realistic failure in the field. Mitigations: build it
  early in Track C, test on the actual demo device, and ship a visible
  "I'd rather not talk tonight" fallback that awards the artifact anyway. That
  fallback is not a compromise — a book that punishes a child for not
  performing is the wrong book.
- **We are recording children's voices.** Even scored-and-discarded, this is the
  line a judge should hear us draw before they ask: on-device only, nothing
  stored, nothing transmitted, no transcript, no parent playback, and skippable
  every single night.
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

## 10. Decisions — settled

1. **Name: Lantern.** A thing you carry away from the screen into the dark. The
   Judge's default name is **Grumble**; the child renames it on the Cover, and
   the app uses her name for it everywhere after.
2. **Proof of work: ten seconds of the child reading aloud.** One mechanic doing
   three jobs — completion signal, genuine reading-fluency measure Epic cannot
   get from page-turn telemetry, and the warm voice at the other end that is the
   Miranda thread. Parent co-sign was rejected: it hands the book to the adults.
3. **Time: a full day, three or more people.** Nothing gets cut, read-aloud
   included. Run the three tracks in §8 rather than a single queue.
4. **The Judge: marginalia plus the intercept.** The intervention ships, not
   just the atmosphere.
5. **The book is *Hilda and the Troll*.** Reasoning in §7. The one authored
   door, the whole series on Epic behind it, and the quest is Hilda's own
   practice, which is also our Field Guide screen.

### Still open, none of them blocking

- Whether the deep link survives a phone with no Epic app and a signed-out
  account. Track A, first thing.
- Whether the artifacts are hand-drawn assets or generated ink shapes. Track B's
  call; hand-drawn wins on charm if anyone on the team draws.
- Who presents, and which of the three of us is on the demo device. Decide
  before the last 90 minutes, not during them.

---

## 11. Bonus — the small social element

**Only if the demo is rehearsed twice and the solo journey is done.** This is the
last thing on the list, and it is allowed to be cut without discussion.

The smallest version that is still worth showing: **another kid's artifact turns
up in your story.** Around week three, a map Maya didn't draw appears on her
page, described as something an earlier explorer left behind. It is real — some
other child hid something in a closet and drew it badly.

What makes this cheap: it is a **content swap, not a system**. No accounts, no
matching service, no realtime, no moderation queue. A pool of artifacts, one
pulled in at a scripted story beat. For the showcase it can be seeded — two or
three hand-made artifacts in the pool — and we say so.

The rule that keeps it small and keeps it safe in one move: **the stories touch,
the children don't.** No chat, no names, no profiles, no free text, nothing a
child wrote reaching another child. If anyone proposes a feature that needs a
moderation answer, it is out of scope for today by definition.

Why it is worth the half hour if we get there: it is the one beat that tells a
kid who thinks she is the slow one that other people are out there doing this
too — without ever showing her someone to measure herself against.

---

## Seeded content, as of the latest journey

The journey now runs on a real series, not placeholders:

- **Maya's interest is creatures** — she draws monsters in the back of her maths
  book.
- **The books are the Hilda series by Luke Pearson**, which are on Epic.
  Tonight's door is [Hilda and the
  Troll](https://www.getepic.com/book/62843717/hilda-and-the-troll) —
  **that id is confirmed live.** The other three doors currently fall back to an
  Epic search URL and are flagged `needsId` in
  [lib/primer/book.dart](lib/primer/book.dart). Amlan's first job is turning
  those into real ids; until he does, **do not claim on stage that every door
  opens a book.** One does.
- **The quest is drawn from what Hilda actually does**: she goes out with a
  sketchbook and draws the creatures nobody else will admit are there. So Maya
  finds one thing in the house nobody ever looks at, draws it, names it like a
  creature, and writes one true thing underneath. Paper and a pencil, indoors,
  alone.
- **The artifact is a page in her own field guide** — which is why it can't be a
  grid of badges. It's a real object that keeps getting thicker.
