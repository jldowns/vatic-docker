echo "Running pre-commit testing scripts"

protected_branch='master'
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

if [ $current_branch != $protected_branch ]; then
    echo "Not on master branch, skipping tests."
    exit 0
fi

./testing/test_build.sh
