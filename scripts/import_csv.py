"""Create/refresh courses/<code>.md stubs from the ESI catalogue CSV.

Usage: python scripts/import_csv.py catalogue.csv

Existing files keep their body text; only the front matter is refreshed.
"""
import csv
import re
import sys
from pathlib import Path

COURSES = Path(__file__).resolve().parent.parent / "courses"


def q(value):
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def course_path(code):
    if not re.fullmatch(r"[A-Za-z0-9]+(?:[.-][A-Za-z0-9]+)*", code):
        raise ValueError("Course code must contain only letters, numbers, dots, and hyphens")
    slug = re.sub(r"[^a-z0-9]+", "-", code.lower()).strip("-")
    courses_dir = COURSES.resolve()
    path = (courses_dir / f"{slug}.md").resolve()
    try:
        path.relative_to(courses_dir)
    except ValueError:
        raise ValueError("Course code resolves outside the courses directory") from None
    return path


def main(csv_path):
    COURSES.mkdir(exist_ok=True)
    with open(csv_path, newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            code = row["Course code"].strip()  # NOSONAR: course_path validates and confines generated paths
            path = course_path(code)
            body = "Add course description, audience, and schedule notes here.\n"
            if path.exists():
                parts = path.read_text(encoding="utf-8").split("---", 2)
                if len(parts) == 3:
                    body = parts[2].lstrip("\n")
            front = [
                f"code: {q(code)}",
                f"title: {q(row['Course title'].strip())}",
                f"area: {q(row['Area'].strip())}",
                f"learn_url: {q(row['MS Learn course URL'].strip())}",
                f"labs_url: {q(row['GitHub labs URL'].strip())}",
            ]
            path.write_text("---\n" + "\n".join(front) + "\n---\n\n" + body, encoding="utf-8")
            print("wrote", path.name)


if __name__ == "__main__":
    main(sys.argv[1])
