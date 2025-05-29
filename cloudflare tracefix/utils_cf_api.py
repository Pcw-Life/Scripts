"""
utils_cf_api.py
Helper functions for Cloudflare API Shield integration.
"""

import requests
import logging
import json
from typing import Dict, List, Any


def upload_schema(api_url: str, headers: Dict[str, str], schema: dict) -> bool:
    """
    Uploads an OpenAPI schema to Cloudflare API Shield.
    Args:
        api_url (str): The Cloudflare API endpoint for schema upload.
        headers (Dict[str, str]): Auth headers.
        schema (dict): The OpenAPI schema.
    Returns:
        bool: True if upload succeeded, False otherwise.
    """
    try:
        resp = requests.post(api_url, headers=headers, data=json.dumps(schema))
        if resp.status_code in (200, 201):
            logging.info(f"Schema uploaded successfully: {api_url}")
            return True
        logging.error(f"Schema upload failed: {resp.status_code} {resp.text}")
        return False
    except Exception as e:
        logging.error(f"Exception during schema upload: {e}")
        return False


def apply_labels(
    api_url: str, headers: Dict[str, str], labels: List[Dict[str, Any]]
) -> bool:
    """
    Applies labels to endpoints via Cloudflare API.
    Args:
        api_url (str): The Cloudflare API endpoint for labeling.
        headers (Dict[str, str]): Auth headers.
        labels (List[Dict[str, Any]]): List of label dicts.
    Returns:
        bool: True if labeling succeeded, False otherwise.
    """
    try:
        resp = requests.post(
            api_url, headers=headers, data=json.dumps({"labels": labels})
        )
        if resp.status_code in (200, 201):
            logging.info(f"Labels applied successfully: {api_url}")
            return True
        logging.error(f"Label application failed: {resp.status_code} {resp.text}")
        return False
    except Exception as e:
        logging.error(f"Exception during label application: {e}")
        return False


def merge_schemas(schema_paths: List[str]) -> dict:
    """
    Merges multiple OpenAPI schemas into one.
    Args:
        schema_paths (List[str]): List of schema file paths.
    Returns:
        dict: Merged OpenAPI schema.
    """
    merged = {
        "openapi": "3.1.0",
        "info": {"title": "Merged API Schema", "version": "1.0.0"},
        "paths": {},
        "components": {"schemas": {}},
    }
    for path in schema_paths:
        with open(path, "r") as f:
            schema = json.load(f)
            merged["paths"].update(schema.get("paths", {}))
            merged["components"]["schemas"].update(
                schema.get("components", {}).get("schemas", {})
            )
    return merged
