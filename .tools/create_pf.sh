#!/bin/bash

# Create a new portfolio contract
SUI_CONTRACT_PATH="$PWD/portfolio_contract"

#obtain the wallet address from the using sui client active-address command
WALLET_ADDRESS=$(sui client active-address)

#args
NAME=$1
COURSE=$2
SCHOOL=$3
ABOUT=$4
LINKEDIN_URL=$5
GITHUB_URL=$6
SKILLS=$7

# validate per args if has value
if [ -z "$NAME" ]; then
echo "Name is required"
exit 1
fi
if [ -z "$COURSE" ]; then
echo "Course is required"
exit 1
fi
if [ -z "$SCHOOL" ]; then
echo "School is required"
exit 1
fi
if [ -z "$ABOUT" ]; then
echo "About is required"
exit 1
fi
if [ -z "$LINKEDIN_URL" ]; then
echo "Linkedin URL is required"
exit 1
fi
if [ -z "$GITHUB_URL" ]; then
echo "Github URL is required"
exit 1
fi
if [ -z "$SKILLS" ]; then
echo "Skills are required"
exit 1
fi

#Check if Published.toml exists
if [ ! -f "$SUI_CONTRACT_PATH/Published.toml" ]; then
echo "Published.toml does not exist"
exit 1
fi

#obtain the "published-at" value from the Published.toml file
SUI_CONTRACT_PACKAGE_ID=$(grep "published-at" "$SUI_CONTRACT_PATH/Published.toml" | awk -F'=' '{gsub(/"/,""); print $2}' | tr -d ' ')

DATE_TODAY_W_TIMESTAMP=$(date +%Y%m%d%H%M%S)

SUI_CONTRACT_TX_PORTFOLIOS_PATH="$SUI_CONTRACT_PATH/tx_portfolios/$DATE_TODAY_W_TIMESTAMP.json"

# call the create_portfolio functon using sui client call command
sui client call \
--package $SUI_CONTRACT_PACKAGE_ID \
--module portfolio \
--function create_portfolio \
--args $WALLET_ADDRESS $NAME $COURSE $SCHOOL $ABOUT $LINKEDIN_URL $GITHUB_URL $SKILLS \
--gas-budget 10000000 \
> "$SUI_CONTRACT_TX_PORTFOLIOS_PATH"

# check if file has "ProgrammableTransaction"
if [ ! -f "$SUI_CONTRACT_TX_PORTFOLIOS_PATH" ]; then
echo "Transaction data not found"
exit 1
fi

IS_SUCCESS=$(grep "ProgrammableTransaction" "$SUI_CONTRACT_TX_PORTFOLIOS_PATH")
if [ -z "$IS_SUCCESS" ]; then
echo "Transaction failed"
exit 1
fi

echo "Portfolio created successfully"
echo "Transaction data saved to: $SUI_CONTRACT_TX_PORTFOLIOS_PATH"

SUI_PACKAGE_MOD_FN="$SUI_CONTRACT_PACKAGE_ID::portfolio::Portfolio"
PORTFOLIO_FRONTEND_PATH="$PWD/portfolio_frontend"

PORTFOLIO_OBJECT_ID=$(grep -B 10 "$SUI_PACKAGE_MOD_FN" "$SUI_CONTRACT_TX_PORTFOLIOS_PATH" | grep "objectId" | awk -F'"' '{print $4}')

echo "Portfolio object ID: $PORTFOLIO_OBJECT_ID"
echo "VITE_PORTFOLIO_OBJECT_ID=$PORTFOLIO_OBJECT_ID" > "$PORTFOLIO_FRONTEND_PATH/.env"