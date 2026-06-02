#!/usr/bin/env python3
"""Mirror APSCVIR 2026 mobile site content into Flutter assets.

The script intentionally uses only the Python standard library so it can run in
the project environment without installing crawler dependencies.
"""

from __future__ import annotations

import base64
import hashlib
import html
import json
import mimetypes
import os
import re
import ssl
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path


BASE_URL = "https://www.apscvir2026.com"
INDEX_URL = f"{BASE_URL}/en/minisite/index/29839"
OUT_ROOT = Path(os.environ.get("APSCVIR_OUT_ROOT", "conference_app/assets/apscvir2026"))
SITE_DIR = OUT_ROOT / "site"
PAGE_DIR = SITE_DIR / "pages"
IMAGE_DIR = OUT_ROOT / "images"
FILE_DIR = OUT_ROOT / "files"
DATA_DIR = OUT_ROOT / "data"

PRIMARY_COLOR = "#0A92A2"
PRIMARY_DARK = "#0D6F7D"
BACKGROUND_COLOR = "#EAF7FF"

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) "
        "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.9",
}

TEXT_BLOCK_TAGS = {
    "p",
    "li",
    "td",
    "th",
    "blockquote",
}
HAN_RE = re.compile(r"[\u4e00-\u9fff]")
HEADING_TAGS = {"h1", "h2", "h3", "h4", "h5", "h6"}
DOWNLOAD_EXTENSIONS = {
    ".pdf",
    ".doc",
    ".docx",
    ".xls",
    ".xlsx",
    ".ppt",
    ".pptx",
    ".zip",
}


def reset_proxy_env() -> None:
    for key in list(os.environ):
        if key.lower() in {"http_proxy", "https_proxy", "all_proxy", "no_proxy"}:
            os.environ.pop(key, None)


def ensure_dirs() -> None:
    for path in (PAGE_DIR, IMAGE_DIR, FILE_DIR, DATA_DIR):
        path.mkdir(parents=True, exist_ok=True)


def slugify(value: str, fallback: str) -> str:
    cleaned = re.sub(r"[^a-zA-Z0-9]+", "-", value.strip().lower()).strip("-")
    return cleaned or fallback


def fetch_bytes(url: str, retries: int = 2) -> tuple[bytes, str]:
    request = urllib.request.Request(url, headers=HEADERS)
    context = ssl.create_default_context()
    last_error: Exception | None = None
    for attempt in range(retries):
        try:
            with urllib.request.urlopen(request, timeout=25, context=context) as response:
                return response.read(), response.geturl()
        except (urllib.error.URLError, TimeoutError, ssl.SSLError) as exc:
            last_error = exc
            time.sleep(1 + attempt)
    raise RuntimeError(f"Failed to fetch {url}: {last_error}")


def fetch_text(url: str) -> tuple[str, str]:
    data, final_url = fetch_bytes(url)
    # The site declares UTF-8 and the downloaded pages follow it.
    return data.decode("utf-8", errors="replace"), final_url


def absolute_url(url: str, base_url: str = BASE_URL) -> str:
    return urllib.parse.urljoin(base_url, html.unescape(url.strip()))


def strip_tags(fragment: str) -> str:
    fragment = re.sub(r"(?is)<script.*?</script>", " ", fragment)
    fragment = re.sub(r"(?is)<style.*?</style>", " ", fragment)
    fragment = re.sub(r"(?s)<!--.*?-->", " ", fragment)
    fragment = re.sub(r"(?i)<br\s*/?>", "\n", fragment)
    fragment = re.sub(r"(?i)</(p|div|li|tr|h[1-6])>", "\n", fragment)
    fragment = re.sub(r"(?s)<[^>]+>", " ", fragment)
    fragment = html.unescape(fragment)
    fragment = re.sub(r"[ \t\r\f\v]+", " ", fragment)
    fragment = re.sub(r"\n\s+", "\n", fragment)
    fragment = re.sub(r"\n{3,}", "\n\n", fragment)
    return fragment.strip()


def clean_text(value: str) -> str:
    value = html.unescape(value)
    value = re.sub(r"\s+", " ", value)
    return value.strip()


def extract_attr(tag: str, attr: str) -> str:
    pattern = rf"""{attr}\s*=\s*(['"])(.*?)\1"""
    match = re.search(pattern, tag, flags=re.I | re.S)
    if match:
        return html.unescape(match.group(2)).strip()
    return ""


def extract_inner(html_text: str, start_pattern: str, end_pattern: str) -> str:
    start = re.search(start_pattern, html_text, flags=re.I | re.S)
    if not start:
        return ""
    rest = html_text[start.end() :]
    end = re.search(end_pattern, rest, flags=re.I | re.S)
    return rest[: end.start()] if end else rest


def save_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def save_json(path: Path, data: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def save_data_uri(data_uri: str, page_slug: str, index: int) -> dict[str, str]:
    match = re.match(r"data:([^;,]+)?(?:;[^,]+)?,(.*)", data_uri, flags=re.S)
    if not match:
        return {}
    mime_type = match.group(1) or "image/png"
    raw = match.group(2)
    try:
        if ";base64" in data_uri[: data_uri.find(",")]:
            payload = base64.b64decode(raw)
        else:
            payload = urllib.parse.unquote_to_bytes(raw)
    except Exception:
        return {}
    ext = mimetypes.guess_extension(mime_type) or ".bin"
    filename = f"{page_slug}-{index:02d}{ext}"
    path = IMAGE_DIR / filename
    path.write_bytes(payload)
    return {
        "asset": f"assets/apscvir2026/images/{filename}",
        "source": "embedded",
        "mimeType": mime_type,
    }


def asset_extension(url_path: str) -> str:
    name = Path(url_path).name
    match = re.search(
        r"(\.css|\.ico|\.png|\.jpe?g|\.gif|\.webp|\.pdf|\.docx?|\.xlsx?|\.pptx?|\.zip|\.rar)",
        name,
        flags=re.I,
    )
    return match.group(1).lower() if match else ".bin"


def asset_stem(url_path: str, fallback: str) -> str:
    name = Path(url_path).name
    name = re.split(r"!", name, maxsplit=1)[0]
    stem = Path(name).stem
    return slugify(stem, fallback)


def save_remote_asset(url: str, target_dir: Path, prefix: str) -> dict[str, str]:
    parsed = urllib.parse.urlparse(url)
    ext = asset_extension(parsed.path)
    digest = hashlib.sha1(url.encode("utf-8")).hexdigest()[:10]
    stem = asset_stem(parsed.path, prefix)
    filename = f"{prefix}-{stem}-{digest}{ext}"
    path = target_dir / filename
    if not path.exists():
        try:
            payload, final_url = fetch_bytes(url)
            path.write_bytes(payload)
            url = final_url
        except Exception as exc:
            return {"source": url, "error": str(exc)}
    root_name = "images" if target_dir == IMAGE_DIR else "files"
    return {
        "asset": f"assets/apscvir2026/{root_name}/{filename}",
        "source": url,
    }


def extract_index_images(index_html: str) -> list[dict[str, str]]:
    images: list[dict[str, str]] = []
    for idx, match in enumerate(re.finditer(r"<img\b[^>]*\bsrc\s*=\s*(['\"])(.*?)\1", index_html, flags=re.I | re.S)):
        src = html.unescape(match.group(2)).strip()
        if not src or src.startswith("data:"):
            continue
        asset = save_remote_asset(absolute_url(src), IMAGE_DIR, f"home-{idx + 1:02d}")
        asset["alt"] = ""
        images.append(asset)
    return images


def extract_stylesheet_links(index_html: str) -> list[dict[str, str]]:
    styles: list[dict[str, str]] = []
    for idx, match in enumerate(re.finditer(r"<link\b[^>]*\bhref\s*=\s*(['\"])(.*?)\1", index_html, flags=re.I | re.S)):
        href = html.unescape(match.group(2)).strip()
        if not href or not href.startswith("http"):
            continue
        parsed = urllib.parse.urlparse(href)
        ext = Path(parsed.path).suffix.lower()
        if ext not in {".css", ".ico"}:
            continue
        target = FILE_DIR if ext == ".css" else IMAGE_DIR
        asset = save_remote_asset(href, target, f"site-style-{idx + 1:02d}")
        styles.append(asset)
    return styles


def extract_menu(index_html: str) -> list[dict[str, object]]:
    menu_html = extract_inner(
        index_html,
        r"<ul[^>]*\bid\s*=\s*(['\"])huiyi-ul\1[^>]*>",
        r"</ul>\s*</div>",
    )
    entries: list[dict[str, object]] = []
    li_pattern = re.compile(r"<li\b(?P<li_attrs>[^>]*)>(?P<body>.*?)</li>", re.I | re.S)
    for li_match in li_pattern.finditer(menu_html):
        li_attrs = li_match.group("li_attrs")
        body = li_match.group("body")
        tid = extract_attr(f"<li {li_attrs}>", "tid")
        color_match = re.search(r"background\s*:\s*(#[0-9a-fA-F]{6})", li_attrs)
        color = color_match.group(1) if color_match else PRIMARY_COLOR
        title_match = re.search(r'<p[^>]*class\s*=\s*["\'][^"\']*menu-title[^"\']*["\'][^>]*>(.*?)</p>', body, re.I | re.S)
        title = clean_text(strip_tags(title_match.group(1))) if title_match else ""
        href_match = re.search(r"<a\b[^>]*\bhref\s*=\s*(['\"])(.*?)\1", body, re.I | re.S)
        href = html.unescape(href_match.group(2)).strip() if href_match else ""
        icon_match = re.search(r"<i\b[^>]*\bclass\s*=\s*(['\"])(.*?)\1", body, re.I | re.S)
        icon_class = clean_text(icon_match.group(2)) if icon_match else ""
        children: list[dict[str, str]] = []
        for child_match in re.finditer(
            r'<a\b[^>]*class\s*=\s*["\'][^"\']*sub-nav-item[^"\']*["\'][^>]*href\s*=\s*([\'"])(.*?)\1[^>]*>(.*?)</a>',
            body,
            flags=re.I | re.S,
        ):
            child_href = html.unescape(child_match.group(2)).strip()
            child_body = child_match.group(3)
            child_title_match = re.search(r'<p[^>]*class\s*=\s*["\'][^"\']*menu-title[^"\']*["\'][^>]*>(.*?)</p>', child_body, re.I | re.S)
            child_title = clean_text(strip_tags(child_title_match.group(1))) if child_title_match else clean_text(strip_tags(child_body))
            child_icon_match = re.search(r"<i\b[^>]*\bclass\s*=\s*(['\"])(.*?)\1", child_body, re.I | re.S)
            children.append(
                {
                    "id": extract_nid(child_href) or slugify(child_title, "child"),
                    "title": child_title,
                    "url": absolute_url(child_href),
                    "iconClass": clean_text(child_icon_match.group(2)) if child_icon_match else icon_class,
                    "color": color,
                }
            )
        entries.append(
            {
                "id": extract_nid(href) or tid or slugify(title, "item"),
                "title": title,
                "url": absolute_url(href) if href and href != "javascript:;" else "",
                "iconClass": icon_class,
                "color": color,
                "children": children,
            }
        )
    return entries


def extract_nid(url: str) -> str:
    if not url:
        return ""
    parsed = urllib.parse.urlparse(html.unescape(url))
    query = urllib.parse.parse_qs(parsed.query)
    return query.get("nid", [""])[0]


def flatten_menu(entries: list[dict[str, object]]) -> list[dict[str, object]]:
    flattened: list[dict[str, object]] = []
    for entry in entries:
        children = entry.get("children") or []
        url = str(entry.get("url") or "")
        if extract_nid(url):
            flattened.append({k: v for k, v in entry.items() if k != "children"})
        for child in children:
            flattened.append(child)
    seen: set[str] = set()
    result: list[dict[str, object]] = []
    for item in flattened:
        item_id = str(item.get("id") or extract_nid(str(item.get("url") or "")))
        if not item_id or item_id in seen:
            continue
        seen.add(item_id)
        result.append(item)
    return result


def extract_content_html(page_html: str) -> str:
    content = extract_inner(
        page_html,
        r"<div\b[^>]*class\s*=\s*(['\"])[^'\"]*sub-content[^'\"]*\1[^>]*>",
        r"<!--\s*footer模块\s*-->|<div\s+class\s*=\s*['\"]footer-box",
    )
    if content.strip():
        return content
    content = extract_inner(
        page_html,
        r"<div\b[^>]*class\s*=\s*(['\"])[^'\"]*program-container[^'\"]*\1[^>]*>",
        r"<!--\s*footer模块\s*-->|<div\s+class\s*=\s*['\"]footer-box",
    )
    if content.strip():
        return content
    content = extract_inner(
        page_html,
        r"<div\b[^>]*class\s*=\s*(['\"])[^'\"]*program-wrapper[^'\"]*\1[^>]*>",
        r"<!--\s*footer模块\s*-->|<div\s+class\s*=\s*['\"]footer-box",
    )
    if content.strip():
        return content
    return extract_inner(page_html, r"<body[^>]*>", r"</body>")


def preferred_image_src(tag: str) -> str:
    data_original = extract_attr(tag, "data-original")
    src = extract_attr(tag, "src")
    if data_original:
        return data_original
    return src


def extract_assets_from_content(content_html: str, page_slug: str, base_url: str) -> tuple[list[dict[str, str]], list[dict[str, str]]]:
    images: list[dict[str, str]] = []
    downloads: list[dict[str, str]] = []
    for idx, match in enumerate(re.finditer(r"<img\b[^>]*>", content_html, flags=re.I | re.S)):
        tag = match.group(0)
        src = preferred_image_src(tag)
        alt = extract_attr(tag, "alt")
        if not src:
            continue
        if src.startswith("data:"):
            asset = save_data_uri(src, page_slug, idx + 1)
        else:
            asset = save_remote_asset(absolute_url(src, base_url), IMAGE_DIR, f"{page_slug}-{idx + 1:02d}")
        if asset:
            asset["alt"] = alt
            images.append(asset)

    for idx, match in enumerate(re.finditer(r"<a\b[^>]*\bhref\s*=\s*(['\"])(.*?)\1[^>]*>(.*?)</a>", content_html, flags=re.I | re.S)):
        href = html.unescape(match.group(2)).strip()
        label = clean_text(strip_tags(match.group(3)))
        if not href or href.startswith("javascript:"):
            continue
        abs_href = absolute_url(href, base_url)
        parsed = urllib.parse.urlparse(abs_href)
        ext = Path(parsed.path).suffix.lower()
        if ext in DOWNLOAD_EXTENSIONS:
            asset = save_remote_asset(abs_href, FILE_DIR, f"{page_slug}-file-{idx + 1:02d}")
            asset["label"] = label or Path(parsed.path).name
            downloads.append(asset)
    return images, downloads


def extract_program_overview_blocks(content_html: str) -> list[dict[str, object]]:
    blocks: list[dict[str, object]] = []
    for room_match in re.finditer(r"(?is)<li\b[^>]*>\s*<h2[^>]*class\s*=\s*['\"][^'\"]*program-item-title[^'\"]*['\"][^>]*>(.*?)</h2>(.*?)</li>", content_html):
        room = clean_text(strip_tags(room_match.group(1)))
        body = room_match.group(2)
        if room:
            blocks.append({"type": "heading", "text": room})
        for item_match in re.finditer(r"(?is)<div\b[^>]*class\s*=\s*['\"][^'\"]*program-item[^'\"]*['\"][^>]*>(.*?)</div>\s*</div>", body):
            item = item_match.group(1)
            time_text = ""
            time_match = re.search(r"(?is)<p\b[^>]*class\s*=\s*['\"][^'\"]*pro-time[^'\"]*['\"][^>]*>(.*?)</p>", item)
            if time_match:
                time_text = clean_text(strip_tags(time_match.group(1)))
            title = ""
            title_match = re.search(r"(?is)<div\b[^>]*class\s*=\s*['\"][^'\"]*pro-title[^'\"]*['\"][^>]*>(.*?)</div>", item)
            if title_match:
                title = clean_text(strip_tags(title_match.group(1)))
            line = " · ".join(part for part in (time_text, title) if part)
            if line:
                blocks.append({"type": "paragraph", "text": line})
    return blocks


def extract_detailed_program_blocks(content_html: str) -> list[dict[str, object]]:
    blocks: list[dict[str, object]] = []
    for style_match in re.finditer(r"(?is)<div\b[^>]*class\s*=\s*['\"][^'\"]*program-style[^'\"]*['\"][^>]*>(.*?)(?=<div\b[^>]*class\s*=\s*['\"][^'\"]*program-style[^'\"]*['\"]|</body>|$)", content_html):
        section = style_match.group(1)
        time_match = re.search(r"(?is)<div\b[^>]*class\s*=\s*['\"][^'\"]*program-style-time[^'\"]*['\"][^>]*>(.*?)</div>", section)
        time_text = clean_text(strip_tags(time_match.group(1))) if time_match else ""
        if time_text and not any(block.get("text") == time_text for block in blocks):
            blocks.append({"type": "heading", "text": time_text})
        title_matches = re.finditer(r"(?is)<div\b[^>]*class\s*=\s*['\"][^'\"]*program-style-title[^'\"]*['\"][^>]*>(.*?)</div>", section)
        for title_match in title_matches:
            title = clean_text(strip_tags(title_match.group(1)))
            if title:
                blocks.append({"type": "heading", "text": title})
        for wrapper_match in re.finditer(r"(?is)<div\b[^>]*class\s*=\s*['\"][^'\"]*program-style-content-wrapper[^'\"]*['\"][^>]*>(.*?)</div>\s*</div>", section):
            text = clean_text(strip_tags(wrapper_match.group(1)))
            if text:
                blocks.append({"type": "paragraph", "text": text})
    return blocks


def extract_blocks(content_html: str, images: list[dict[str, str]]) -> list[dict[str, object]]:
    special_blocks = []
    if "program-list" in content_html:
        special_blocks.extend(extract_program_overview_blocks(content_html))
    if "program-style" in content_html:
        special_blocks.extend(extract_detailed_program_blocks(content_html))

    blocks: list[dict[str, object]] = []
    image_iter = iter(images)
    token_pattern = re.compile(
        r"(?is)<(?P<tag>h[1-6]|p|li|table|img)\b(?P<attrs>[^>]*)>(?P<body>.*?)</(?P=tag)>|<img\b(?P<img_attrs>[^>]*)/?>"
    )

    for match in token_pattern.finditer(content_html):
        tag = (match.group("tag") or "img").lower()
        if tag in HEADING_TAGS:
            text = clean_text(strip_tags(match.group("body") or ""))
            if text:
                blocks.append({"type": "heading", "text": text})
        elif tag in TEXT_BLOCK_TAGS:
            text = clean_text(strip_tags(match.group("body") or ""))
            if text:
                blocks.append({"type": "paragraph", "text": text})
        elif tag == "table":
            rows: list[list[str]] = []
            for row_match in re.finditer(r"(?is)<tr\b[^>]*>(.*?)</tr>", match.group("body") or ""):
                row_cells = [
                    clean_text(strip_tags(cell_match.group(1)))
                    for cell_match in re.finditer(r"(?is)<t[dh]\b[^>]*>(.*?)</t[dh]>", row_match.group(1))
                ]
                row_cells = [cell for cell in row_cells if cell]
                if row_cells:
                    rows.append(row_cells)
            if rows:
                blocks.append({"type": "table", "rows": rows})
        elif tag == "img":
            try:
                image = next(image_iter)
            except StopIteration:
                continue
            blocks.append({"type": "image", **image})

    if special_blocks:
        blocks = special_blocks + blocks

    if not blocks:
        text = strip_tags(content_html)
        for part in [clean_text(line) for line in text.splitlines() if clean_text(line)]:
            blocks.append({"type": "paragraph", "text": part})
    return coalesce_blocks(blocks)


def coalesce_blocks(blocks: list[dict[str, object]]) -> list[dict[str, object]]:
    result: list[dict[str, object]] = []
    seen_text: set[str] = set()
    for block in blocks:
        if block.get("type") in {"heading", "paragraph"}:
            text = clean_text(str(block.get("text") or ""))
            if not text or text in seen_text or HAN_RE.search(text):
                continue
            seen_text.add(text)
            block["text"] = text
        if block.get("type") == "table":
            clean_rows = []
            for row in block.get("rows", []):
                clean_row = [str(cell) for cell in row if not HAN_RE.search(str(cell))]
                if clean_row:
                    clean_rows.append(clean_row)
            block["rows"] = clean_rows
        result.append(block)
    return result


def crawl_page(entry: dict[str, object]) -> dict[str, object]:
    title = str(entry.get("title") or "Untitled")
    page_id = str(entry.get("id") or extract_nid(str(entry.get("url") or "")) or slugify(title, "page"))
    page_slug = slugify(title, page_id)
    url = str(entry.get("url") or "")
    page_html, final_url = fetch_text(url)
    html_path = PAGE_DIR / f"{page_id}-{page_slug}.html"
    save_text(html_path, page_html)
    content_html = extract_content_html(page_html)
    images, downloads = extract_assets_from_content(content_html, page_slug, final_url)
    blocks = extract_blocks(content_html, images)
    text = "\n".join(
        str(block.get("text", ""))
        for block in blocks
        if block.get("type") in {"heading", "paragraph"} and not HAN_RE.search(str(block.get("text", "")))
    )
    return {
        "id": page_id,
        "title": title,
        "url": final_url,
        "sourceUrl": url,
        "htmlAsset": f"assets/apscvir2026/site/pages/{html_path.name}",
        "iconClass": entry.get("iconClass", ""),
        "color": entry.get("color", PRIMARY_COLOR),
        "images": images,
        "downloads": downloads,
        "blocks": blocks,
        "plainText": text,
    }


def main() -> int:
    reset_proxy_env()
    ensure_dirs()
    print(f"Fetching {INDEX_URL}")
    index_html, final_index_url = fetch_text(INDEX_URL)
    save_text(SITE_DIR / "index.html", index_html)

    menu = extract_menu(index_html)
    pages_to_crawl = flatten_menu(menu)
    home_images = extract_index_images(index_html)
    stylesheets = extract_stylesheet_links(index_html)

    pages: list[dict[str, object]] = []
    failures: list[dict[str, str]] = []
    for idx, entry in enumerate(pages_to_crawl, start=1):
        title = str(entry.get("title") or "Untitled")
        print(f"[{idx}/{len(pages_to_crawl)}] {title}")
        try:
            pages.append(crawl_page(entry))
        except Exception as exc:
            failures.append({"title": title, "url": str(entry.get("url") or ""), "error": str(exc)})

    manifest = {
        "conference": {
            "title": "20th Annual Scientific Meeting of Asia Pacific Society of Cardiovascular and Interventional Radiology",
            "shortTitle": "APSCVIR 2026",
            "date": "June 11 - 14, 2026",
            "venue": "Suzhou International Expo Centre",
            "location": "Suzhou, China",
            "sourceUrl": final_index_url,
            "theme": {
                "primary": PRIMARY_COLOR,
                "primaryDark": PRIMARY_DARK,
                "background": BACKGROUND_COLOR,
            },
        },
        "homeImages": home_images,
        "stylesheets": stylesheets,
        "menu": menu,
        "pages": pages,
        "failures": failures,
        "crawledAt": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    }
    save_json(DATA_DIR / "site_manifest.json", manifest)
    save_json(DATA_DIR / "site_pages.json", pages)
    save_json(DATA_DIR / "site_menu.json", menu)
    print(f"Saved {len(pages)} pages, {len(home_images)} home images, {len(failures)} failures.")
    if failures:
        print(json.dumps(failures, ensure_ascii=False, indent=2), file=sys.stderr)
    return 0 if not failures else 2


if __name__ == "__main__":
    raise SystemExit(main())
