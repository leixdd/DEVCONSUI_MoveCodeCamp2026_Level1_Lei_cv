# Install Sui on Windows (Chocolatey)

This guide covers installing the Sui CLI on Windows using Chocolatey. The Sui CLI is used to interact with the Sui network, deploy packages, and manage assets.

**Source:** [Install Sui | Sui Documentation](https://docs.sui.io/guides/developer/getting-started/sui-install)

---

## Prerequisites

- **Operating system:** Windows 10 or 11
- **Chocolatey** must be installed. If you don’t have it, install from [chocolatey.org](https://chocolatey.org/install)

---

## Quick install with Chocolatey

1. Open **PowerShell** (or Command Prompt) **as Administrator** if required by your Chocolatey setup.

2. Install Sui:

   ```powershell
   choco install sui
   ```

   **Note:** The first install can take several minutes if Sui prerequisites are not yet installed. Using [suiup](https://github.com/MystenLabs/suiup) is often faster and also recommended by the docs.

3. Confirm the installation:

   - Open a terminal (PowerShell or Command Prompt).
   - Run:

   ```powershell
   sui --version
   ```

   - If you see a **"command not found"** (or similar) error, ensure the directory where Chocolatey installed the Sui binaries is in your **PATH** environment variable.

---

## More Sui versions on Windows

Additional Sui package versions for Windows are listed on the Chocolatey community site:  
[Chocolatey – Sui packages](https://community.chocolatey.org/packages?q=sui)

---

## After installing

- Sui stores its main config in:  
  **`~/.sui/sui_config/client.yaml`**  
  This file holds network settings (Mainnet, Testnet, Devnet, Localnet), active environment, active address, and keystore location.

- **You still need to configure the Sui client** after installation (e.g. create/select address and connect to a network). See the official docs for:
  - [Configure a Sui Client](https://docs.sui.io/guides/developer/getting-started/configure-a-sui-client)
  - [Get SUI from Faucet](https://docs.sui.io/guides/developer/getting-started/get-sui-from-faucet) (for Testnet)

---

## Reference

- [Install Sui – Sui Documentation](https://docs.sui.io/guides/developer/getting-started/sui-install)
