"""Lantern design-partner search via Nimble (docs/outreach/README.md explains the method).
pip install nimble_python ; set NIMBLE_API_KEY. Run from the repo root.
python tool/find_partners.py          -> .cache/partners/candidates_raw.csv (pages cached alongside)
python tool/find_partners.py --test   -> self-check, no API calls
python tool/find_partners.py --only E2 -> run one experiment's queries
Raw output holds scraped emails, so it stays in .cache/ (git-ignored). Curated rows go in
docs/outreach/candidates.csv with no personal contact details.
"""
import csv, json, os, re, sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from urllib.parse import urlparse

# Stream -> queries. Streams map to the outreach experiments (E1-E4).
QUERIES = {
    "E1 nonprofit": [
        'nonprofit one-on-one reading tutoring kindergarten "second grade" struggling readers volunteer',
        'early literacy nonprofit "grades K-3" tutoring program "partner with us"',
        'nonprofit "reading anxiety" children program',
        'therapy dog reading program children nonprofit "reluctant readers"',
        'literacy nonprofit Bay Area "struggling readers" elementary tutoring',
        'literacy nonprofit San Jose OR Oakland OR Fremont children reading program volunteer',
        'nonprofit dyslexia children free tutoring "Orton-Gillingham" scholarship',
        'community literacy nonprofit "science of reading" tutoring "first grade" "second grade"',
        'nonprofit summer reading program "rising second graders" OR "rising first graders"',
        'dyslexia nonprofit family support "parent" "early identification" chapter',
        'nonprofit "reading buddies" program elementary volunteers literacy',
        'literacy nonprofit "pilot" "edtech" partner early reading',
    ],
    "E2 kit": [
        'book and activity subscription box ages 5-8 early reader',
        'phonics activity kit subscription kids "decodable" hands-on',
        'screen-free literacy activity kit kids small business',
        'story-based activity kit children "book club box" crafts ages 6',
        'literacy activity box kindergarten first grade "reading" subscription "shop"',
        '"early reader" activity kit "ages 5-7" OR "ages 6-8" small business',
        'Etsy-style handmade reading activity kit kids phonics games printable shop',
        'homeschool reading activity kit "first grade" hands-on games company',
        'screen-free kids activity subscription "ages 6" "made in USA" small company',
        'craft kit for kids "story" "ages 5" monthly box founder',
    ],
    "E3 practitioner": [
        'Orton-Gillingham tutoring practice Bay Area dyslexia children',
        'educational therapist dyslexia "first grade" "second grade" reading clinic',
        'structured literacy tutoring center small group early readers "reading anxiety"',
    ],
    "E4 parent community": [
        'Decoding Dyslexia state chapter parent group',
        'parent support group struggling readers dyslexia California',
    ],
}
# Already on the outreach sheet, plus giants a 3-person team won't land.
KNOWN = ("highlights", "lovevery", "kiwico", "ivy-kids", "baketivity", "openroadslearning", "rootedinwriting",
         "lastinger", "newworldsreading", "joyfulreading", "beanstack", "withodyssey", "yoto", "wgbh", "gbh.org",
         "scholastic", "hmh", "overdrive", "classwallet", "ala.org", "sesame", "cpb.org", "imaginationlibrary",
         "rif.org", "commonsensemedia", "dgliteracy", "loislenski", "clifonline", "roomtoread", "jumpstartkids",
         "seuss", "getepic", "readingpartners", "amazon.", "facebook.", "instagram.", "linkedin.", "youtube.",
         "reddit.", "wikipedia.", "pinterest.", "yelp.", "indeed.", "glassdoor.", "guidestar", "charitynavigator",
         "propublica", "tiktok.", "x.com", "twitter.", "edweek", "understood.org", "readingrockets", "nytimes",
         "medium.com", "eventbrite", "idealist", "volunteermatch", "gov/", ".gov", "cratejoy", "parents.com")
CACHE = Path(".cache/partners/pages")
OUT = ".cache/partners/candidates_raw.csv"

EMAIL = re.compile(r"[\w.+-]+@[\w-]+\.[a-z]{2,}(?:\.[a-z]{2})?", re.I)
JUNK_EMAIL = ("sentry", "wixpress", "example.", "godaddy", "domain.com", "email.com", ".png", ".jpg")
SIGNALS = {
    "k2": r"\b(kindergarten|first grade|second grade|grades? k-?[23]|k-3|1st grade|2nd grade|ages? [4-8]\b)",
    "struggling": r"\b(struggling readers?|reluctant readers?|below grade level|reading difficult|dyslexi)",
    "anxiety": r"\b(reading anxiety|confidence|self-esteem|low-pressure|non-judgmental|judgment-free)",
    "nonprofit": r"\b(501\(c\)\(3\)|nonprofit|non-profit|donate)\b",
    "partner": r"\b(partner with us|partnerships?|collaborat|pilot|research partner)\b",
    "one_on_one": r"\b(one-on-one|1:1|one to one|individuali[sz]ed)\b",
    "science_of_reading": r"\b(science of reading|structured literacy|orton|phonics|decodable)\b",
    "bay_area": r"\b(bay area|san jose|oakland|fremont|san francisco|santa clara|alameda|berkeley|hayward|milpitas)\b",
}
SIG = {k: re.compile(v, re.I) for k, v in SIGNALS.items()}


def known(url):
    return any(k in url.lower() for k in KNOWN)


def urls_in(obj):
    # Search response shape isn't pinned down; collect every "url" field (same approach as coach_leads.py).
    if isinstance(obj, dict):
        for k, v in obj.items():
            if k == "url" and isinstance(v, str):
                yield v
            else:
                yield from urls_in(v)
    elif isinstance(obj, list):
        for v in obj:
            yield from urls_in(v)


def root(url):
    p = urlparse(url)
    return f"{p.scheme}://{p.netloc}/"


def score(md):
    s = {k: len(r.findall(md)) for k, r in SIG.items()}
    s["emails"] = ";".join(sorted({e.rstrip(".").lower() for e in EMAIL.findall(md)
                                   if not any(j in e.lower() for j in JUNK_EMAIL)}))[:250]
    # Weighted fit for a grade-2, anxious, unidentified reader: K-2 + struggling matter most.
    s["fit"] = 3 * min(s["k2"], 3) + 3 * min(s["struggling"], 3) + 2 * min(s["anxiety"], 2) \
        + 2 * min(s["one_on_one"], 2) + min(s["science_of_reading"], 2) + min(s["partner"], 2) \
        + 2 * bool(s["bay_area"])
    return s


def title_of(md):
    m = re.search(r"^#\s+(.+)$", md, re.M)
    return (m.group(1) if m else md.strip().split("\n", 1)[0])[:90]


def main():
    from nimble_python import Nimble
    c = Nimble(api_key=os.environ["NIMBLE_API_KEY"])
    CACHE.mkdir(parents=True, exist_ok=True)

    def search(sq):
        stream, q = sq
        try:
            r = c.search(query=q, country="US", search_depth="standard").to_dict()
            return [(stream, q, u) for u in urls_in(r)]
        except Exception as e:
            print("ERR search", q, e)
            return []

    only = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else ""
    jobs = [(s, q) for s, qs in QUERIES.items() if s.startswith(only) for q in qs]
    # ponytail: 4 threads so the concurrent HabitCrafts run keeps most of the rate limit
    with ThreadPoolExecutor(4) as ex:
        hits = [h for hs in ex.map(search, jobs) for h in hs]
    seen = {}
    for stream, q, u in hits:
        if u.startswith("http") and not known(u):
            seen.setdefault(urlparse(u).netloc.removeprefix("www."), (stream, q, u))
    print(len(hits), "hits ->", len(seen), "new domains")

    def page(item):
        dom, (stream, q, u) = item
        f = CACHE / (re.sub(r"\W", "_", dom) + ".md")
        if not f.exists():
            md = ""
            for target in (u, root(u)):
                try:
                    md += "\n\n" + (c.extract.run(url=target, render=True, formats=["markdown"]).data.markdown or "")
                except Exception as e:
                    md += f"\n\nERR {e}"
                if target == root(u):
                    break
            f.write_text(u + "\n" + md, encoding="utf-8")
        md = f.read_text(encoding="utf-8")
        return {"domain": dom, "stream": stream, "url": u, "title": title_of(md.split("\n", 1)[1]),
                "query": q, **score(md)}

    with ThreadPoolExecutor(4) as ex:
        rows = list(ex.map(page, seen.items()))
    rows.sort(key=lambda r: (r["stream"], -r["fit"]))
    with open(OUT, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    print("wrote", OUT, len(rows))


def test():
    assert known("https://www.kiwico.com/x") and not known("https://smallkit.co/")
    assert list(urls_in({"a": [{"url": "u1"}, {"b": {"url": "u2"}}]})) == ["u1", "u2"]
    s = score("We are a 501(c)(3) nonprofit offering one-on-one tutoring for struggling readers in "
              "first grade and second grade in Oakland. Email hi@lit.org or x@sentry.io")
    assert s["k2"] == 2 and s["struggling"] == 1 and s["nonprofit"] == 1 and s["bay_area"] == 1
    assert s["emails"] == "hi@lit.org" and s["fit"] == 3 * 2 + 3 + 2 + 2
    assert root("https://a.org/b/c?d") == "https://a.org/"
    print("ok")


if __name__ == "__main__":
    test() if "--test" in sys.argv else main()
