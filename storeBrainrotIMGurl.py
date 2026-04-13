import requests
import time
import re

SUPABASE_URL = "https://ofclhcihedjtltiyjkvn.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9mY2xoY2loZWRqdGx0aXlqa3ZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU3OTQ2ODMsImV4cCI6MjA5MTM3MDY4M30.Sn4iT6lZghZnMGp4cBxDRfWs-ARoClk437qeEpqPAN0"

HEADERS = {
    "apikey": SUPABASE_KEY,
    "Authorization": f"Bearer {SUPABASE_KEY}",
    "Content-Type": "application/json"
}

def get_all_wiki_brainrots():
    names = []
    cmcontinue = None

    while True:
        url = "https://stealabrainrot.fandom.com/api.php?action=query&list=categorymembers&cmtitle=Category:Brainrots&cmlimit=500&format=json"
        if cmcontinue:
            url += f"&cmcontinue={cmcontinue}"

        res = requests.get(url, timeout=10)
        data = res.json()

        members = data.get("query", {}).get("categorymembers", [])
        for m in members:
            title = m["title"]
            # skip non-brainrot pages like categories, templates etc
            if ":" not in title:
                names.append(title)

        # check if there are more pages
        if "continue" in data:
            cmcontinue = data["continue"]["cmcontinue"]
        else:
            break

    print(f"Found {len(names)} brainrots on wiki")
    return names

def get_already_stored():
    res = requests.get(
        f"{SUPABASE_URL}/rest/v1/brainrot-image-links?select=brainrot_name",
        headers=HEADERS
    )
    data = res.json()
    return set([d["brainrot_name"] for d in data if d.get("brainrot_name")])

def fetch_image_url(name):
    wiki_name = name.replace(" ", "_")
    url = f"https://stealabrainrot.fandom.com/api.php?action=query&titles={wiki_name}&prop=pageimages&format=json&pithumbsize=200"
    try:
        res = requests.get(url, timeout=10)
        data = res.json()
        pages = data.get("query", {}).get("pages", {})
        for page in pages.values():
            thumb = page.get("thumbnail")
            if thumb:
                return thumb["source"]
    except Exception as e:
        print(f"  Error fetching image for {name}: {e}")
    return None

def store_image(name, image_url):
    res = requests.post(
        f"{SUPABASE_URL}/rest/v1/brainrot-image-links",
        headers={**HEADERS, "Prefer": "resolution=merge-duplicates"},
        json={
            "brainrot_name": name,
            "brainrot_imglink": image_url
        }
    )
    return res.status_code in [200, 201]

def main():
    print("=" * 50)
    print("Brainrot Image Fetcher")
    print("=" * 50)

    print("\nFetching all brainrot names from wiki...")
    names = get_all_wiki_brainrots()

    print("\nChecking already stored images...")
    already_stored = get_already_stored()
    print(f"Already stored: {len(already_stored)}")

    to_process = [n for n in names if n not in already_stored]
    print(f"To process: {len(to_process)}")

    if len(to_process) == 0:
        print("\nAll images already stored!")
        return

    print("\nStarting...\n")

    success   = 0
    failed    = 0
    not_found = 0

    for i, name in enumerate(to_process):
        print(f"[{i+1}/{len(to_process)}] {name}")

        image_url = fetch_image_url(name)

        if image_url:
            stored = store_image(name, image_url)
            if stored:
                print(f"  ✓ Stored!")
                success += 1
            else:
                print(f"  ✗ Failed to store in DB")
                failed += 1
        else:
            print(f"  ? No image found on wiki")
            not_found += 1

        time.sleep(0.5)

    print("\n" + "=" * 50)
    print(f"Done!")
    print(f"  Success:   {success}")
    print(f"  Failed:    {failed}")
    print(f"  Not found: {not_found}")
    print("=" * 50)

if __name__ == "__main__":
    main()