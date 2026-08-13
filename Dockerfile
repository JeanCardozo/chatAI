# Used by Railway/Render image deploys; local dev uses docker-compose.yml
FROM n8nio/n8n:latest
USER node
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD wget -qO- http://127.0.0.1:5678/healthz >/dev/null 2>&1 || exit 1
