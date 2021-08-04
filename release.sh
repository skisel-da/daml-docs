#!/usr/bin/env bash

set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd "$DIR/../daml"
eval "$(dev-env/bin/dade-assist)"
bazel build //docs:docs-no-pdf
COMMIT="$(git show -s --format=%cd-%h --date=short)"
TARGET="$DIR/docs/$COMMIT"
mkdir "$TARGET"
tar xzf bazel-bin/docs/html-only.tar.gz -C "$TARGET" --strip-components=1
cd "$DIR"
git add docs
git commit -m "release $COMMIT" >/dev/null
git push
echo "https://garyverhaegen-da.github.io/daml-docs/$COMMIT"
