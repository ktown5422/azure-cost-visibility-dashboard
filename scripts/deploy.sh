#!/usr/bin/env bash
# Deploys the cost-visibility infrastructure (budget, action group, storage account,
# Cost Management export) into the target resource group via Bicep.
#
# Usage:
#   ./scripts/deploy.sh <resource-group-name> <notification-email> [budget-amount]
#
# Prerequisites:
#   az login
#   az account set --subscription <subscription-id>
#   Resource group already exists (see docs/setup-steps.md)

set -euo pipefail

RESOURCE_GROUP="${1:?Usage: deploy.sh <resource-group-name> <notification-email> [budget-amount]}"
NOTIFICATION_EMAIL="${2:?Usage: deploy.sh <resource-group-name> <notification-email> [budget-amount]}"
BUDGET_AMOUNT="${3:-50}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_FILE="${SCRIPT_DIR}/../infra/main.bicep"

echo "Deploying cost-visibility stack to resource group: ${RESOURCE_GROUP}"

az deployment group create \
  --resource-group "${RESOURCE_GROUP}" \
  --template-file "${TEMPLATE_FILE}" \
  --parameters notificationEmail="${NOTIFICATION_EMAIL}" budgetAmount="${BUDGET_AMOUNT}" \
  --query "properties.outputs"

echo "Deployment complete. Review outputs above for the storage account name and budget end date."
