ZK_PATH="/Users/bradleyyeo/Documents/Obsidian"

cd "$ZK_PATH"

git pull

CHANGES_EXIST="$(git status --porcelain | wc -l)"

if [ "$CHANGES_EXIST" -eq 0 ]; then
	exit 0
fi

git pull

git add .

git push -q
