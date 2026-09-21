# UHEF_LOG_TM.sh

UHEF log TM (Stirling / Riemann / Schwarzschild; `Log(R)=0` at boundary).

| Artifact | Role |
|----------|------|
| `UHEF_LOG_TM.sh` | One-liner (~856B) |
| `UHEF_LOG_TM_DAEMON.sh` | Resident loop (default 1s) |
| `.github/workflows/uhef-log-tm.yml` | Actions `*/5` |

```sh
curl -fsSL https://raw.githubusercontent.com/letsgo0226/UHEF_LOG_TM.sh/main/UHEF_LOG_TM.sh | bash
nohup bash UHEF_LOG_TM_DAEMON.sh 1 >> uhef_log_tm_daemon.log 2>&1 &
```

Bound: `FORMAL_MODEL_NOT_PHYSICAL_TOE_PROOF` — not a physical TOE proof.
