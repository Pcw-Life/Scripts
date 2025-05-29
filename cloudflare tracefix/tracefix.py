# ---------------------------------------------
# PCW|Integrates - Cloudflare TraceFix Script
# PURPOSE: Automate zone-level API rules to correct trace mismatch issues.
# ---------------------------------------------

# R@R CHECKLIST - Variables to Fill In Before Use
# ---------------------------------------------
# OP_SECRET_CLOUDFLARE_API_TOKEN   = "op://PCWICV/PCWI_CF_API/credential"
# OP_SECRET_CLOUDFLARE_ZONE_ID     = "op://PCWICV/PCWI_CF_API/ZONE_ID"
# CLOUDFLARE_BASE_URL              = Leave as default unless self-hosted
# ---------------------------------------------

import subprocess
import requests
import json

# VARIABLES
OP_SECRET_CLOUDFLARE_API_TOKEN = "op://PCWICV/PCWI_CF_API/credential"
OP_SECRET_CLOUDFLARE_ZONE_ID = "op://PCWICV/PCWI_CF_API/ZONE_ID"
CLOUDFLARE_BASE_URL = "https://api.cloudflare.com/client/v4"


# Inject secrets securely using op
def op_read(secret):
    result = subprocess.run(["op", "read", secret], capture_output=True, text=True)
    return result.stdout.strip()


# Retrieve auth token and zone
api_token = op_read(OP_SECRET_CLOUDFLARE_API_TOKEN)
zone_id = op_read(OP_SECRET_CLOUDFLARE_ZONE_ID)
headers = {"Authorization": f"Bearer {api_token}", "Content-Type": "application/json"}


# TASKS TO EXECUTE IN ORDER
def execute_tracefix_tasks():
    # --- Redirect Rule ---
    redirect_payload = {
        "action": "redirect",
        "expression": 'http.host eq "www.pcwprops.com"',
        "description": "Redirect www to apex",
        "enabled": True,
        "action_parameters": {
            "status_code": 301,
            "to": "https://pcwprops.com",
            "preserve_query_string": True,
        },
    }
    print("[+] Applying: Single Redirect Rule")
    requests.post(
        f"{CLOUDFLARE_BASE_URL}/zones/{zone_id}/rulesets/phases/http_request_redirect/entrypoint/rules",
        headers=headers,
        data=json.dumps(redirect_payload),
    )

    # --- Configuration Rule (Always Use HTTPS) ---
    print("[+] Enabling: Always Use HTTPS")
    requests.patch(
        f"{CLOUDFLARE_BASE_URL}/zones/{zone_id}/settings/always_use_https",
        headers=headers,
        data=json.dumps({"value": "on"}),
    )

    # --- File Upload Scan (enable if available) ---
    print("[+] (Optional) Skipped File Upload Scan — not supported on Pro plan")

    # --- API Shield Integration ---
    import logging
    from utils_cf_api import upload_schema, apply_labels, merge_schemas
    import glob
    import os

    logging.basicConfig(level=logging.INFO)
    log_summary = []
    schemas_dir = os.path.join(os.path.dirname(__file__), "schemas")
    schema_files = glob.glob(os.path.join(schemas_dir, "*.schema.json"))
    merged_schema_path = os.path.join(schemas_dir, "merged.schema.json")
    labels_path = os.path.join(schemas_dir, "labels.json")

    # Merge schemas
    try:
        merged_schema = merge_schemas(schema_files)
        with open(merged_schema_path, "w") as f:
            import json

            json.dump(merged_schema, f, indent=2)
        logging.info("Merged schemas written to merged.schema.json")
    except Exception as e:
        msg = f"[API Shield] Failed to merge schemas: {e}"
        logging.error(msg)
        log_summary.append(msg)

    # Upload merged schema to Cloudflare API Shield
    schema_api_url = f"{CLOUDFLARE_BASE_URL}/zones/{zone_id}/api_gateway/schema"
    try:
        with open(merged_schema_path, "r") as f:
            schema_data = json.load(f)
        if not upload_schema(schema_api_url, headers, schema_data):
            msg = "[API Shield] Schema upload failed."
            log_summary.append(msg)
    except Exception as e:
        msg = f"[API Shield] Exception during schema upload: {e}"
        logging.error(msg)
        log_summary.append(msg)

    # Apply endpoint labels
    labels_api_url = f"{CLOUDFLARE_BASE_URL}/zones/{zone_id}/api_gateway/labels"
    try:
        with open(labels_path, "r") as f:
            labels_data = json.load(f)
        if not apply_labels(labels_api_url, headers, labels_data):
            msg = "[API Shield] Label application failed."
            log_summary.append(msg)
    except Exception as e:
        msg = f"[API Shield] Exception during label application: {e}"
        logging.error(msg)
        log_summary.append(msg)

    # Write log summary
    log_file = os.path.join(os.path.dirname(__file__), "log_summary.txt")
    with open(log_file, "w") as f:
        if log_summary:
            f.write("\n".join(log_summary) + "\n")
            print("[!] Some API Shield steps failed. See log_summary.txt for details.")
        else:
            f.write("No errors or skipped services in this run.\n")
            print("[✔] API Shield integration complete.")

    # --- Response Header Injection ---
    header_rule = {
        "action": "set_headers",
        "expression": "true",
        "description": "Inject secure response headers",
        "enabled": True,
        "action_parameters": {
            "headers": [
                {
                    "name": "Strict-Transport-Security",
                    "operation": "set",
                    "value": "max-age=63072000; includeSubDomains; preload",
                },
                {
                    "name": "X-Content-Type-Options",
                    "operation": "set",
                    "value": "nosniff",
                },
                {"name": "X-Frame-Options", "operation": "set", "value": "SAMEORIGIN"},
            ]
        },
    }
    print("[+] Applying: Response Header Rule")
    requests.post(
        f"{CLOUDFLARE_BASE_URL}/zones/{zone_id}/rulesets/phases/http_response_headers_transform/entrypoint/rules",
        headers=headers,
        data=json.dumps(header_rule),
    )

    print("[✔] Cloudflare tracefix tasks complete.")


# MAIN
if __name__ == "__main__":
    execute_tracefix_tasks()
