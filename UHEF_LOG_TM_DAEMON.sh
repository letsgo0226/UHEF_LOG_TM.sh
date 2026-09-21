#!/usr/bin/env bash
# UHEF_LOG_TM resident loop — default 1s
set -u
INTERVAL="${1:-${UHEF_INTERVAL:-1}}"
LOG="${UHEF_LOG:-uhef_log_tm_daemon.log}"
DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || pwd)"
SCRIPT="${UHEF_SCRIPT:-$DIR/UHEF_LOG_TM.sh}"
RAW_URL="https://raw.githubusercontent.com/letsgo0226/UHEF_LOG_TM.sh/main/UHEF_LOG_TM.sh"
if [[ ! -f "$SCRIPT" ]]; then
  command -v curl >/dev/null || exit 127
  SCRIPT="${TMPDIR:-/tmp}/UHEF_LOG_TM.sh"
  curl -fsSL "$RAW_URL" -o "$SCRIPT" || exit 1
fi
command -v python3 >/dev/null || exit 127
echo "{\"daemon\":\"UHEF_LOG_TM\",\"interval\":$INTERVAL,\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"}" | tee -a "$LOG"
while true; do
  TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  OUT=$(mktemp)
  if bash "$SCRIPT" >"$OUT" 2>"${OUT}.err"; then
    if python3 - "$OUT" <<'PY'
import json,sys
o=json.load(open(sys.argv[1]))
ok=(o.get("model")=="UHEF_LOG_TM"
    and o.get("seed")==[0,0,0,0,0,0]
    and o.get("G0")==30030 and o.get("G")==30030
    and o.get("R")==[1,1] and o.get("boundary")==[1,1]
    and str(o.get("log_residual"))=="0"
    and o.get("status")=="FORMAL_MODEL_NOT_PHYSICAL_TOE_PROOF")
sys.exit(0 if ok else 2)
PY
    then echo "{\"ts\":\"$TS\",\"status\":\"pass\"} $(python3 -c 'import json,sys;o=json.load(open(sys.argv[1]));print(json.dumps({k:o[k] for k in ["model","seed","G0","G","R","log_residual","status"]},separators=(",",":")))' "$OUT")" >>"$LOG"
    else echo "{\"ts\":\"$TS\",\"status\":\"assert_fail\"}" >>"$LOG"
    fi
  else echo "{\"ts\":\"$TS\",\"status\":\"run_fail\"}" >>"$LOG"
  fi
  rm -f "$OUT" "${OUT}.err"
  sleep "$INTERVAL"
done
