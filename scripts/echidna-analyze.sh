#!/bin/bash

source /opt/venv/slither/bin/activate
scripts/solc-select-install.sh

ANALYSIS_ARTIFACTS_FOLDER="./artifacts/echidna"
FUZZ_CONTRACT_SUFFIX="fuzz.test.sol"
ANALYSIS_LOG_SUFFIX="analysis.log"

tests_path=$(yarn -s hardhat config-value tests-path)
sources_path=$(yarn -s hardhat config-value sources-path)
current_date=$(date +%y%m%d-%H%M%S)
contract_names=$(find $tests_path \
  -name '*.fuzz.test.sol' \
  -type f \
  -exec sh -c "\
    prefix_removed=\${0#\"$tests_path/\"}; \
    suffix_removed=\${prefix_removed%\".$FUZZ_CONTRACT_SUFFIX\"}; \
    echo \$suffix_removed; \
  " {} \;)

echo "Creating analysis artifacts folder: '$ANALYSIS_ARTIFACTS_FOLDER'…"
mkdir -p "$ANALYSIS_ARTIFACTS_FOLDER"

for contract_name in $contract_names
do
  source_contract_path="$sources_path/$contract_name.sol"
  fuzz_contract_name="${contract_name}Fuzz"
  fuzz_contract_file="$contract_name.$FUZZ_CONTRACT_SUFFIX"
  fuzz_contract_path="$tests_path/$fuzz_contract_file"
  analysis_log_filename="$contract_name-$current_date.$ANALYSIS_LOG_SUFFIX"
  analysis_log_path="$ANALYSIS_ARTIFACTS_FOLDER/$analysis_log_filename"

  if [ ! -f "$fuzz_contract_path" ];
  then
    echo "$fuzz_contract_path is not available, skipping"
    continue 
  fi

  if [ ! -f "$source_contract_path" ];
  then
    echo "$source_contract_path is not available, skipping"
    continue 
  fi

  echo "Testing: '$fuzz_contract_file'…"
  echidna-test \
    "$fuzz_contract_path" \
    --contract "$fuzz_contract_name" \
    --config echidna.config.yml \
    --test-mode property \
    | tee "$analysis_log_path"

  echo "Log saved to '$analysis_log_path'"
  echo "Complete: $fuzz_contract_file."
done
