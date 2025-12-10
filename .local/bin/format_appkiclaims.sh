#!/usr/bin/env bash

# Set the parent directory (you can also pass this as an argument)
PARENT_DIR="${1:-.}"  # Defaults to current directory if no argument is given
VE_FOR_APPKICLAIMS="${2:-./VirtualEnvironmentForApPkiClaims.ini}"  # Defaults to current directory if no argument is given

MF="PKIRControlPlaneDataPlane"
RENEWAL_DATE="2025091020250912"

# Check if the directory exists
if [ ! -d "$PARENT_DIR" ]; then
  echo "Directory '$PARENT_DIR' does not exist."
  exit 1
fi

appki_claims=()
cert_renewals=()
for dir in "$PARENT_DIR"/*; do
    if [ -d "$dir" ]; then
        cluster=$(basename "$dir")
        if [ "$cluster" == "Global" ]; then
            continue;
        fi
        for subdir in "${dir}"/*; do
            if [ -d "$subdir" ]; then
                pe=$(basename "$subdir")
                if [ ! -f "$subdir"/VirtualEnvironmentForApPkiClaims.ini ]; then
                    cp "${VE_FOR_APPKICLAIMS}" "$subdir/VirtualEnvironmentForApPkiClaims.ini"
                    appki_claims+=("Cluster:$cluster,Environment:$pe,MF:$MF\$PkirMhsm=true")
                    cert_renewals+=("Cluster:$cluster,Environment:$pe,MF:$MF\$ForceApPkiCertificateRenewal=$RENEWAL_DATE")
                fi
            fi
        done
    fi
done

echo "APPKI Claims"
printf '%s\n' "${appki_claims[@]}"
echo "Cert Renewals"
printf '%s\n' "${cert_renewals[@]}"
