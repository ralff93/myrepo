# Copy static site
CWD=`pwd`

# Clone Pages repository
cd /tmp
git clone YOUR_PAGES_REPO build
# cd build && git checkout -b YOUR_BRANCH origin/YOUR_BRANCH # If not using master

# Trigger Jekyll rebuild
cd $CWD
bundle exec jekyll contentful
bundle exec jekyll build

# Push newly built repository
cp -r $CWD/_build/* /tmp/build # or $CWD/_site

cd /tmp/build

git config --global user.email "YOUR_EMAIL@example.com"
git config --global user.name "YOUR NAME"

git add .
git commit -m "Automated Rebuild"
git push -f origin master
