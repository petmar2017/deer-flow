#!/bin/bash

# Start both of DeerFlow's backend and web UI server.
# If the user presses Ctrl+C, kill them both.

# Add Homebrew Node.js to PATH
export PATH="/opt/homebrew/bin:$PATH"
NODE_VERSION=$(node -v)
echo "Using Node.js $NODE_VERSION"

if [ "$1" = "--dev" -o "$1" = "-d" -o "$1" = "dev" -o "$1" = "development" ]; then
  echo -e "Starting DeerFlow in [DEVELOPMENT] mode...\n"
  uv run server.py --reload & SERVER_PID=$!
  cd web && pnpm dev & WEB_PID=$!
  trap "kill $SERVER_PID $WEB_PID" SIGINT SIGTERM
  wait
else
  echo -e "Starting DeerFlow in [PRODUCTION] mode...\n"
  uv run server.py
  cd web && pnpm start
fi
