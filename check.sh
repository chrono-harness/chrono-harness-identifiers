#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [[ ${1:-} != --managed-scratch && ${GITHUB_ACTIONS:-} != true ]] && [[ -d .git && ! -L .git && ! -L target && ! -L target/native-checks ]]; then
  exec chrono-host-bootstrap native-scratch run bash ./check.sh --managed-scratch
fi
if [[ ${1:-} == --managed-scratch ]]; then
  scratch=${CHRONO_NATIVE_SCRATCH:?missing managed scratch directory}
elif [[ -f .git && ! -L target ]] && git_dir=$(git rev-parse --git-dir 2>/dev/null) && [[ -f "$git_dir/commondir" ]]; then
  mkdir -p target
  scratch=$(mktemp -d "$(pwd -P)/target/check.XXXXXXXX")
  trap 'rm -rf -- "$scratch"' EXIT
else
  scratch=$(mktemp -d "${TMPDIR:-/tmp}/identifiers-check.XXXXXXXX")
  trap 'rm -rf -- "$scratch"' EXIT
fi
export CARGO_TARGET_DIR="$scratch/cargo"
cargo fmt --check --manifest-path crates/identifiers/Cargo.toml
cargo fmt --check --manifest-path crates/identifiers-tests/Cargo.toml
cargo build --locked --manifest-path crates/identifiers/Cargo.toml
cargo test --locked --manifest-path crates/identifiers-tests/Cargo.toml

prove() {
  local label=$1 root=$2
  local output="$scratch/$label.rlib"
  "${VERUS:-verus}" --crate-type=lib --no-cheating --no-external-by-default --num-threads 2 \
    --output-json --compile "--emit=link=$output,dep-info=$output.d" "$root" -o "$output" \
    -Zchecksum-hash-algorithm=sha256 > "$scratch/proof.json" || { cat "$scratch/proof.json" >&2; return 1; }
  cat "$scratch/proof.json"
  jq -e '.verus.version == "0.2026.04.24.f8e1704" and
    .verus.commit == "f8e17045c4ac17a02e566b8997070f2eecc255be" and
    (."verification-results" | .success == true and ."is-verifying-entire-crate" == true and
    ."encountered-error" == false and ."encountered-vir-error" == false and
    .errors == 0 and .verified > 0)' "$scratch/proof.json" >/dev/null
  test -s "$output" && test -s "$output.d"
}

prove verify.identifiers crates/identifiers/src/lib.rs
prove verify.identifiers-tests crates/identifiers-tests/tests/verified_identifiers.rs
