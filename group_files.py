from pathlib import Path

folder_to_sort = Path("/Users/bradleyyeo/Downloads")
file_folder_mapping = {
    ".png": "images",
    ".jpg": "images",
    ".jpeg": "images",
    ".JPG": "images",
    ".pdf": "pdfs",
    ".mp4": "videos",
    ".mp3": "audio",
    ".zip": "bundles",
}
for file in folder_to_sort.glob("*"):
    ext = file.suffix
    if ext in file_folder_mapping:
        dest = folder_to_sort / file_folder_mapping[ext]
        if not dest.exists():
            dest.mkdir()
        file.rename(dest / file.name)
