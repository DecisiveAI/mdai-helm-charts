#!/bin/bash
# Usage: ./scripts/generate_chart_table.sh path/to/index.yaml

INDEX_YAML=${1:-index.yaml}
HELM_REPO_URL="https://decisiveai.github.io/mdai-helm-charts"
REPO_BASE_URL="https://github.com/DecisiveAI"
HELM_NAMESPACE=mdai

RETIRED_CHARTS=("datalyzer" "event-handler-webservice" "event-hub-poc" "mdai-cluster" "mdai-api" "mdai-console" "mydecisive-api" "mydecisive-engine-operator" "mydecisive-engine-ui" "opentelemetry-demo" "otelcol-sample")

is_retired() {
  local chart="$1"
  for retired in "${RETIRED_CHARTS[@]}"; do
    if [[ "$retired" == "$chart" ]]; then
      return 0
    fi
  done
  return 1
}

ACTIVE_TABLE="| Chart Name | Description | Version | Values |"
ACTIVE_TABLE+="\n|------------|-------------|---------|--------|"
RETIRED_TABLE="| Chart Name | Description | Version | Values |"
RETIRED_TABLE+="\n|------------|-------------|---------|--------|"

while IFS= read -r line; do
  name=$(echo "$line" | awk -F'|' '{print $1}')
  desc=$(echo "$line" | awk -F'|' '{print $2}')
  version=$(echo "$line" | awk -F'|' '{print $3}')

  if [ "$name" == "mdai-hub" ]; then
    chart_link="[$name]($REPO_BASE_URL/mdai-helm-chart/blob/main/Chart.yaml)"
    values_link="[values.yaml]($REPO_BASE_URL/mdai-helm-chart/blob/main/values.yaml)"
  else
    chart_link="[$name]($REPO_BASE_URL/$name/blob/main/deployment/Chart.yaml)"
    values_link="[values.yaml]($REPO_BASE_URL/$name/blob/main/deployment/values.yaml)"
  fi

  row="| $chart_link | $desc | [$version]($HELM_REPO_URL/$name-$version.tgz) | $values_link |"

  if is_retired "$name"; then
    RETIRED_TABLE="$RETIRED_TABLE\n$row"
  else
    ACTIVE_TABLE="$ACTIVE_TABLE\n$row"
  fi
done < <(
  yq eval -o t '
    .entries | to_entries[] |
    .key as $name |
    .value[0] |
    "\($name)|\(.description)|\(.version)"
  ' "$INDEX_YAML"
)

echo -e "## 📦 Available Charts\n\n$ACTIVE_TABLE\n"
echo -e "## 📦 Retired/Archived Charts\n\n$RETIRED_TABLE"