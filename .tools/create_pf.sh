#!/bin/bash

# Create a new portfolio contract
SUI_CONTRACT_PATH="$PWD/portfolio_contract"

#obtain the wallet address from the using sui client active-address command
WALLET_ADDRESS=$(sui client active-address)

#args
NETWORK=$1
NAME=$2
COURSE=$3
SCHOOL=$4
ABOUT=$5
LINKEDIN_URL=$6
GITHUB_URL=$7
SKILLS=$8

#number of args should be 8
if [ $# -ne 8 ]; then
echo "Number of arguments should be 8"
exit 1
fi

# validate per args if has value
if [ -z "$NETWORK" ]; then
echo "Network is required (testnet or mainnet)"
exit 1
fi
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

if [ "$NETWORK" == "mainnet" ]; then
SUI_CONTRACT_PACKAGE_ID=$(awk -F' = ' '/\[published.mainnet\]/{f=1} f==1 && /published-at/{print $2; exit} f==1 && /^\[/{if(!/published.mainnet/)f=0}' "$SUI_CONTRACT_PATH/Published.toml" | tr -d '"')
else
SUI_CONTRACT_PACKAGE_ID=$(awk -F' = ' '/\[published.testnet\]/{f=1} f==1 && /published-at/{print $2; exit} f==1 && /^\[/{if(!/published.testnet/)f=0}' "$SUI_CONTRACT_PATH/Published.toml" | tr -d '"')
fi

echo "SUI_CONTRACT_PACKAGE_ID: $SUI_CONTRACT_PACKAGE_ID"

DATE_TODAY_W_TIMESTAMP=$(date +%Y%m%d%H%M%S)

SUI_CONTRACT_TX_PORTFOLIOS_PATH="$SUI_CONTRACT_PATH/tx_portfolios/$NETWORK-$DATE_TODAY_W_TIMESTAMP.json"

# call the create_portfolio functon using sui client call command
sui client call \
--package $SUI_CONTRACT_PACKAGE_ID \
--module portfolio \
--function create_portfolio \
--args "$WALLET_ADDRESS" "$NAME" "$COURSE" "$SCHOOL" "$ABOUT" "$LINKEDIN_URL" "$GITHUB_URL" "$SKILLS" \
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
echo "Transaction data: $SUI_CONTRACT_TX_PORTFOLIOS_PATH"
exit 1
fi

echo "Portfolio created successfully"
echo "Transaction data saved to: $SUI_CONTRACT_TX_PORTFOLIOS_PATH"

SUI_PACKAGE_MOD_FN="$SUI_CONTRACT_PACKAGE_ID::portfolio::Portfolio"
PORTFOLIO_FRONTEND_PATH="$PWD/portfolio_frontend"

PORTFOLIO_OBJECT_ID=$(grep -B 10 "$SUI_PACKAGE_MOD_FN" "$SUI_CONTRACT_TX_PORTFOLIOS_PATH" | grep "objectId" | awk -F'"' '{print $4}')

echo "Portfolio object ID: $PORTFOLIO_OBJECT_ID"
echo "VITE_PORTFOLIO_OBJECT_ID=$PORTFOLIO_OBJECT_ID" > "$PORTFOLIO_FRONTEND_PATH/.env"