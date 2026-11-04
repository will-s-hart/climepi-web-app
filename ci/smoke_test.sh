#!/usr/bin/env bash
# Build the app image, start it, and check that an app session builds without errors.
#
# Usage: bash ci/smoke_test.sh  (or: pixi run smoke-test)
# Env vars: SMOKE_TIMEOUT (seconds to wait for the server, default 300),
#           SMOKE_PORT (host port, default 7860).
set -euo pipefail
cd "$(dirname "$0")/.."

image="climepi-web-app-smoke"
container="climepi-web-app-smoke"
timeout="${SMOKE_TIMEOUT:-300}"
port="${SMOKE_PORT:-7860}"
url="http://localhost:${port}/"

cleanup() {
  docker rm -f "$container" >/dev/null 2>&1 || true
}

fail() {
  echo "::error::Smoke test failed: $1"
  echo "----- container logs -----"
  docker logs "$container" 2>&1 || true
  exit 1
}

trap cleanup EXIT
cleanup

docker build -t "$image" .
# Hugging Face runs Space containers as UID 1000, so do the same here to catch
# permission problems.
docker run -d --name "$container" --user 1000:1000 -p "${port}:7860" "$image" >/dev/null

echo "Waiting up to ${timeout}s for ${url}"
deadline=$((SECONDS + timeout))
until curl -sf --max-time 10 -o /dev/null "$url"; do
  if [ "$(docker inspect -f '{{.State.Running}}' "$container")" != "true" ]; then
    fail "container exited before the server started"
  fi
  if [ "$SECONDS" -ge "$deadline" ]; then
    fail "server not up within ${timeout}s"
  fi
  sleep 5
done

# / redirects to the app (/climepi_app). If building the app session fails, Panel serves
# an error page with HTTP 200 and logs nothing, so check the page title rather than the
# status code.
page=$(curl -sfL --max-time 120 "$url") || fail "request to ${url} failed"
[[ $page == *"<title>climepi app</title>"* ]] \
  || fail "app session did not build (Panel served its error page)"

# Give any errors a moment to reach the logs.
sleep 5
logs=$(docker logs "$container" 2>&1)
if grep -q "Traceback" <<<"$logs"; then
  fail "Traceback found in container logs"
fi

echo "Smoke test passed: app session built at ${url}"
