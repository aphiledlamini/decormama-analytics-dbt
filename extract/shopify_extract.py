"""Extract orders from the Shopify Admin REST API into seed-format CSVs.

Requires env vars SHOPIFY_STORE (e.g. my-shop.myshopify.com) and SHOPIFY_TOKEN (Admin API access token).
Without a token it makes NO network calls and exits. Output goes to data/raw/ (git-ignored)
so real store data never lands in the repo's EXAMPLE seeds.
"""
import csv, os, re, sys
from pathlib import Path

API_VERSION = os.getenv("SHOPIFY_API_VERSION", "2024-10")
OUT = Path(__file__).resolve().parent.parent / "data" / "raw"


def fetch_orders(store, token):
    import requests
    url = f"https://{store}/admin/api/{API_VERSION}/orders.json"
    params = {"status": "any", "limit": 250}
    headers = {"X-Shopify-Access-Token": token}
    while url:
        r = requests.get(url, headers=headers, params=params, timeout=30)
        r.raise_for_status()
        yield from r.json().get("orders", [])
        m = re.search(r'<([^>]+)>;\s*rel="next"', r.headers.get("Link", ""))
        url, params = (m.group(1), None) if m else (None, None)


def main():
    store, token = os.getenv("SHOPIFY_STORE"), os.getenv("SHOPIFY_TOKEN")
    if not store or not token:
        print("SHOPIFY_STORE / SHOPIFY_TOKEN not set: skipping API call. dbt will use the EXAMPLE seeds.")
        return 0
    OUT.mkdir(parents=True, exist_ok=True)
    with open(OUT / "orders.csv", "w", newline="") as fo, open(OUT / "order_lines.csv", "w", newline="") as fl:
        wo, wl = csv.writer(fo), csv.writer(fl)
        wo.writerow(["order_id", "order_name", "created_at", "channel_id", "financial_status", "customer_email"])
        wl.writerow(["line_id", "order_id", "product_id", "quantity", "price_zar"])
        n = 0
        for o in fetch_orders(store, token):
            wo.writerow([o["id"], o.get("name"), o["created_at"], 1, o.get("financial_status"), o.get("email") or ""])
            for li in o.get("line_items", []):
                wl.writerow([li["id"], o["id"], li.get("product_id"), li["quantity"], li["price"]])
            n += 1
    print(f"Wrote {n} orders to {OUT}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
