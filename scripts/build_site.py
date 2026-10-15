"""Build the static course site from courses/*.md into _site/.

Each courses/<slug>.md has simple `key: "value"` front matter (code, title,
area, learn_url, labs_url, and optionally level, duration, audience) followed
by a plain-text description. The site is a single master/detail page: areas
on the left, an accordion of that area's courses on the right.
"""
import html
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
COURSES = ROOT / "courses"
OUT = ROOT / "_site"
ASSETS = ROOT / "site_assets"

LEVEL_BADGES = {
    "beginner": "text-bg-success",
    "intermediate": "text-bg-primary",
    "advanced": "text-bg-danger",
}

PAGE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title}</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="style.css">
</head>
<body class="d-flex min-vh-100 flex-column">
<nav class="navbar navbar-expand-md navbar-dark bg-primary shadow-sm" aria-label="Main navigation">
<div class="container-xl">
<a class="navbar-brand fw-semibold" href="./">Course Catalogue</a>
<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavigation" aria-controls="mainNavigation" aria-expanded="false" aria-label="Toggle navigation">
<span class="navbar-toggler-icon"></span>
</button>
<div class="collapse navbar-collapse" id="mainNavigation">
<ul class="navbar-nav ms-auto">
<li class="nav-item"><a class="nav-link" href="./">Courses</a></li>
<li class="nav-item"><a class="nav-link" href="https://learn.microsoft.com/training/" target="_blank" rel="noopener">Microsoft Learn</a></li>
</ul>
</div>
</div>
</nav>
<main class="container-xl flex-grow-1 py-4 py-lg-5">{body}</main>
<footer class="border-top py-3">
<div class="container-xl text-body-secondary small">Some Courses...</div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="catalogue.js"></script>
</body>
</html>
"""


def parse(path):
    _, fm, body = path.read_text(encoding="utf-8").split("---", 2)
    meta = {}
    for line in fm.strip().splitlines():
        key, _, val = line.partition(":")
        val = val.strip()
        if val.startswith('"') and val.endswith('"'):
            val = val[1:-1].replace('\\"', '"').replace("\\\\", "\\")
        meta[key.strip()] = val
    meta["slug"] = path.stem
    meta["body"] = body.strip()
    return meta


def link(url, label, classes=""):
    if not url:
        return ""
    class_attr = f' class="{classes}"' if classes else ""
    return f'<a href="{html.escape(url)}"{class_attr} target="_blank" rel="noopener">{label}</a>'


def render_body(body):
    paras = [p.strip() for p in re.split(r"\n\s*\n", body) if p.strip()]
    return "".join(f"<p>{html.escape(p)}</p>" for p in paras)


def render_course(c, parent_id):
    e = html.escape
    item_id = f"course-{c['slug']}"
    level = c.get("level", "")
    level_badge = (
        f"<span class='badge {LEVEL_BADGES.get(level.lower(), 'text-bg-secondary')} ms-auto me-2'>{e(level)}</span>"
        if level else ""
    )
    labs_icon = (
        "<svg class='ms-1' width='1em' height='1em' viewBox='0 0 24 24' "
        "fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' "
        "stroke-linejoin='round' role='img' aria-label='Hands-on labs available'>"
        "<title>Hands-on labs available</title>"
        "<path d='M9 3h6m-5 0v7l-5 9a1 1 0 0 0 .9 1.5h12.2a1 1 0 0 0 .9-1.5l-5-9V3M8 14h8'/>"
        "</svg>"
        if c.get("labs_url") else ""
    )
    details = "".join(
        f"<dt class='col-sm-3'>{label}</dt><dd class='col-sm-9'>{e(c[key])}</dd>"
        for key, label in (("level", "Level"), ("duration", "Duration"), ("audience", "Audience"))
        if c.get(key)
    )
    details = f"<dl class='row small mb-3'>{details}</dl>" if details else ""
    actions = (
        link(c.get("learn_url"), "Course on Microsoft Learn", "btn btn-primary btn-sm")
        + link(c.get("labs_url"), "Hands-on labs (GitHub)", "btn btn-outline-primary btn-sm")
        + f"<a href='#{e(c['slug'])}' class='btn btn-outline-secondary btn-sm' data-share-course "
        f"aria-label='Share {e(c['code'])}'>Share</a>"
    )
    return (
        "<div class='accordion-item'>"
        f"<h3 class='accordion-header'><button class='accordion-button collapsed gap-2' type='button' "
        f"data-bs-toggle='collapse' data-bs-target='#{item_id}' aria-expanded='false' aria-controls='{item_id}'>"
        f"<span class='d-flex flex-column'><span class='course-code'>{e(c['code'])}</span>"
        f"<span class='fw-semibold'>{e(c['title'])}{labs_icon}</span></span>{level_badge}</button></h3>"
        f"<div id='{item_id}' class='accordion-collapse collapse' data-bs-parent='#{parent_id}'>"
        f"<div class='accordion-body'>{render_body(c['body'])}{details}"
        f"<div class='d-flex flex-column flex-sm-row flex-wrap gap-2'>{actions}</div>"
        "<p class='small text-body-secondary mt-2 mb-0' data-share-status role='status'></p>"
        "<input class='form-control form-control-sm mt-2' data-share-url "
        "type='text' readonly hidden aria-label='Course link to copy'>"
        "</div></div></div>"
    )


def main():
    courses = sorted((parse(p) for p in COURSES.glob("*.md")), key=lambda c: c["code"].lower())
    if OUT.exists():
        shutil.rmtree(OUT)
    OUT.mkdir()
    if ASSETS.exists():
        for f in ASSETS.iterdir():
            shutil.copy(f, OUT / f.name)

    areas = {}
    for c in courses:
        areas.setdefault(c["area"], []).append(c)

    tabs, panes = "", ""
    for index, area in enumerate(sorted(areas)):
        pane_id, list_id = f"area-{index}", f"courses-{index}"
        active = index == 0
        tabs += (
            f"<button class='nav-link d-flex justify-content-between align-items-center gap-3{' active' if active else ''}' "
            f"id='{pane_id}-tab' type='button' role='tab' data-bs-toggle='pill' data-bs-target='#{pane_id}' "
            f"aria-controls='{pane_id}' aria-selected='{'true' if active else 'false'}'>"
            f"<span>{html.escape(area)}</span>"
            f"<span class='badge rounded-pill text-bg-light'>{len(areas[area])}</span></button>"
        )
        items = "".join(render_course(c, list_id) for c in areas[area])
        panes += (
            f"<div class='tab-pane fade{' show active' if active else ''}' id='{pane_id}' role='tabpanel' "
            f"aria-labelledby='{pane_id}-tab' tabindex='0'>"
            f"<h2 class='h4 mb-3'>{html.escape(area)}</h2>"
            f"<div class='accordion course-list' id='{list_id}'>{items}</div></div>"
        )

    body = (
        "<header class='catalogue-hero rounded-4 p-4 p-md-5 mb-4'>"
        "<h1 class='display-6 fw-bold'>Course catalogue</h1>"
        f"<p class='lead mb-0'>{len(courses)} courses across {len(areas)} areas. Pick an area, then expand a course for details and links.</p>"
        "</header>"
        "<div class='row g-4'>"
        "<div class='col-lg-4 col-xl-3'>"
        "<div class='nav nav-pills area-nav flex-row flex-lg-column flex-nowrap gap-2' id='area-tabs' "
        f"role='tablist' aria-label='Course areas'>{tabs}</div></div>"
        f"<div class='col-lg-8 col-xl-9'><div class='tab-content'>{panes}</div></div>"
        "</div>"
    )
    (OUT / "index.html").write_text(PAGE.format(title="Course Links", body=body), encoding="utf-8")
    (OUT / ".nojekyll").write_text("")
    print(f"Built catalogue of {len(courses)} courses in {len(areas)} areas into {OUT}")


if __name__ == "__main__":
    main()
