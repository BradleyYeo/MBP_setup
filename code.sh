git config --global credential.helper osxkeychain

touch .gitignore

echo ".obsidian/cache
.trash/
.DS_Store" > .gitignore

git remote add origin https://github.com/BradleyYeo/Obsidian.git
git push -u origin master

touch zk_sync
chmod +x zk_sync

crontab -e
