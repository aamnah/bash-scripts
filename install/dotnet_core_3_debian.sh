# Register Microsoft key and feed
wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# Install the .NET SDK
sudo apt update
sudo apt install apt-transport-https
sudo apt update
sudo apt install -y dotnet-sdk-3.0

# disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Verify install
dotnet --info