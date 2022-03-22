from pathlib import Path

folder_to_sort = Path("/Users/bradleyyeo/Downloads")
file_folder_mapping = {
    ".png": "pictures",
    ".jpg": "pictures",
    ".jpeg": "pictures",
    ".JPG": "pictures",
    ".pdf": "PDFs",
    ".mp4": "videos",
    ".mp3": "music",
    ".zip": "Bundles",
    ".epub": "books",
    ".csv": "excel",
    ".xlsx": "excel",
    ".pptx": "slides",
    ".ppt": "slides",
    ".docx": "word"
}
for file in folder_to_sort.glob("*"):
    ext = file.suffix
    if ext in file_folder_mapping:
        dest = folder_to_sort / file_folder_mapping[ext]
        if not dest.exists():
            dest.mkdir()
        file.rename(dest / file.name)
