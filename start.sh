#!/bin/bash
envsubst < Caddyfile.template > Caddyfile
cd /srv && ./caddy run