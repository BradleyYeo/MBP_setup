from pathlib import Path

folder_to_sort = Path("/Users/bradleyyeo/Downloads")
file_folder_mapping = {
    ".png": "Photos",
    ".jpg": "Photos",
    ".jpeg": "Photos",
    ".JPG": "Photos",
    ".pdf": "PDFs",
    ".mp4": "Videos",
    ".mp3": "Music",
    ".zip": "Bundles",
    ".epub": "Books",
    ".csv": "Excel",
    ".xlsx": "Excel",
    ".pptx": "Slides",
    ".ppt": "Slides",
    ".docx": "Word",
    ".pem": "Credentials"
}
for file in folder_to_sort.glob("*"):
    ext = file.suffix
    if ext in file_folder_mapping:
        dest = folder_to_sort / file_folder_mapping[ext]
        if not dest.exists():
            dest.mkdir()
        file.rename(dest / file.name)
