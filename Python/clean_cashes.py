# ~/clean_caches.py

# VARIABLES
TARGET_PATHS = {
    "User Cache": "~/Library/Caches",
    "System Cache": "/Library/Caches",
    "App Support Caches": "~/Library/Application Support",
    "User Config Files": "~/.config",
    "Containers": "~/Library/Containers",
    "VS Code Extensions": "~/.vscode",
    "Docker Data": "~/Library/Containers/com.docker.docker",
}

# SCRIPT START
import os
import shutil
from pathlib import Path

def confirm(prompt):
    return input(f"\n⚠️ {prompt} (y/n): ").strip().lower() == 'y'

def expand(path):
    return str(Path(path).expanduser())

def clean_folder(path, label):
    full_path = expand(path)
    if not os.path.exists(full_path):
        print(f"🚫 Skipped {label}: Path does not exist.")
        return

    print(f"\n🧹 Preparing to clean: {label}\nPath: {full_path}")
    if confirm(f"Proceed to delete contents of {label}?"):
        for item in os.listdir(full_path):
            item_path = os.path.join(full_path, item)
            try:
                if os.path.isdir(item_path):
                    shutil.rmtree(item_path)
                else:
                    os.remove(item_path)
                print(f"✅ Removed: {item_path}")
            except Exception as e:
                print(f"❌ Failed to remove {item_path}: {e}")
    else:
        print(f"⏭️ Skipped {label}")

def main():
    print("\n🚀 macOS App Cache Cleaner")
    print("---------------------------")
    for label, path in TARGET_PATHS.items():
        clean_folder(path, label)
    print("\n✅ Cleanup complete.")

if __name__ == "__main__":
    main()
