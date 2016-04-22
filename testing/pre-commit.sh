# To ensure that you don't accidentally commit a bad build to the master branch,
# add this to your hooks by running
#
# cp ./testing/pre-commit.sh ./.git/hooks/pre-commit
# chmod +x ./.git/hooks/pre-commit
#
# Since building an image without caching takes between 8 and 9 minutes, this
# script will only run when commiting on the master branch. For quick prototyping,
# create a feature branch and only merge it with master after you're done.


echo "Running pre-commit testing scripts"

protected_branch='master'
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

if [ $current_branch != $protected_branch ]; then
    echo "Not on master branch, skipping tests."
    exit 0
fi

./testing/test_build.sh
