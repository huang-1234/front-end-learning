
set -e


git add .
git commit -m 'update cso'

git remote -v

git push -f git@github.com:huang-1234/front-end-learning.git master