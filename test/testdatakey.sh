# Generate key
RESPONSE=$(curl -sk --cert client.crt --key client.key --cacert ca.crt \
            -X POST https://localhost:4433/generateDataKey \
            -H "Content-Type: application/json" \
            -d '{}')
echo $RESPONSE
ENCRYPTED=$(echo $RESPONSE | jq -r '.encryptedKey')

# Decrypt key
curl -sk --cert client.crt --key client.key --cacert ca.crt \
     -X POST https://localhost:4433/decryptDataKey \
     -H "Content-Type: application/json" \
     -d "{\"encryptedKey\":\"$ENCRYPTED\"}"

