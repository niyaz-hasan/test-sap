#!/usr/bin/env bash
# glue-job-capacity.sh
# Usage:
#   ./glue-job-capacity.sh jobs.txt            # read job names (one per line)
#   ./glue-job-capacity.sh job1 job2 job3      # pass job names on command line
# Outputs:
#   - prints a table to stdout
#   - writes CSV to glue-job-capacity.csv

set -u
# Tools required: aws CLI (v2 recommended), jq, bc (for decimal math)
# If jq is not available, consider installing it or let me provide a jq-less variant.

OUT_CSV="glue-job-capacity.csv"
TMP_JSON="/tmp/glue_job_json.$$"

# mapping function: worker type -> DPU per worker
worker_dpu_per_type() {
  case "$1" in
    "G.1X" | "G.1x" | "g.1x" ) echo "1" ;;
    "G.2X" | "G.2x" | "g.2x" ) echo "2" ;;
    "Standard" ) echo "1" ;;    # fallback - treat Standard as 1 DPU (adjust if you use other mapping)
    "" ) echo "" ;;
    *) 
      # unknown type - return empty to signal unknown
      echo ""
      ;;
  esac
}

# read job list: either from file or args
jobs=()
if [[ $# -eq 0 ]]; then
  echo "Usage: $0 jobs.txt    OR    $0 job1 job2 ..."
  exit 1
fi

if [[ $# -eq 1 && -f "$1" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    name="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    [[ -z "$name" || "$name" =~ ^# ]] && continue
    jobs+=("$name")
  done < "$1"
else
  # treat args as job names
  for arg in "$@"; do
    jobs+=("$arg")
  done
fi

# header
printf "%-40s %-10s %-10s %-12s %-12s %-8s\n" "JobName" "WorkerType" "Workers" "MaxCapacity" "AllocatedCap" "DPUs"
printf "%-40s %-10s %-10s %-12s %-12s %-8s\n" "--------" "----------" "-------" "-----------" "------------" "----"

# CSV header
echo "JobName,WorkerType,NumberOfWorkers,MaxCapacity,AllocatedCapacity,ComputedDPUs" > "$OUT_CSV"

for job in "${jobs[@]}"; do
  # call aws
  if ! aws glue get-job --job-name "$job" --output json > "$TMP_JSON" 2>/dev/null; then
    printf "%-40s %-10s %-10s %-12s %-12s %-8s\n" "$job" "ERROR" "-" "-" "-" "-"
    echo "$job,ERROR,ERROR,ERROR,ERROR,ERROR" >> "$OUT_CSV"
    continue
  fi

  # extract fields using jq
  worker_type=$(jq -r '.Job.WorkerType // empty' "$TMP_JSON")
  number_of_workers=$(jq -r '.Job.NumberOfWorkers // empty' "$TMP_JSON")
  max_capacity=$(jq -r '.Job.MaxCapacity // empty' "$TMP_JSON")
  allocated_capacity=$(jq -r '.Job.AllocatedCapacity // empty' "$TMP_JSON")

  # Normalize empty fields to blank
  [[ "$worker_type" == "null" ]] && worker_type=""
  [[ "$number_of_workers" == "null" ]] && number_of_workers=""
  [[ "$max_capacity" == "null" ]] && max_capacity=""
  [[ "$allocated_capacity" == "null" ]] && allocated_capacity=""

  computed_dpus=""

  # Priority:
  # 1) If WorkerType + NumberOfWorkers present -> compute using mapping
  # 2) Else if MaxCapacity present -> use that
  # 3) Else if AllocatedCapacity present -> use that
  if [[ -n "$worker_type" && -n "$number_of_workers" ]]; then
    per_worker=$(worker_dpu_per_type "$worker_type")
    if [[ -n "$per_worker" ]]; then
      # Use bc for multiplication (in case of decimals)
      computed_dpus=$(echo "$number_of_workers * $per_worker" | bc)
    else
      computed_dpus="UNKNOWN_WORKER_TYPE"
    fi
  elif [[ -n "$max_capacity" ]]; then
    computed_dpus="$max_capacity"
  elif [[ -n "$allocated_capacity" ]]; then
    computed_dpus="$allocated_capacity"
  else
    computed_dpus="N/A"
  fi

  # print row
  printf "%-40s %-10s %-10s %-12s %-12s %-8s\n" \
    "$job" "${worker_type:--}" "${number_of_workers:--}" "${max_capacity:--}" "${allocated_capacity:--}" "$computed_dpus"

  # write CSV row (escape commas in job name)
  safe_job=$(echo "$job" | sed 's/,/\\,/g')
  echo "$safe_job,${worker_type},${number_of_workers},${max_capacity},${allocated_capacity},${computed_dpus}" >> "$OUT_CSV"
done

rm -f "$TMP_JSON"
echo
echo "CSV written to: $OUT_CSV"
