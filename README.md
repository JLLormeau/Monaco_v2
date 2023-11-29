# Deployment Scripts Repository

This repository contains deployment scripts for AWS, Kubernetes, and Classic environments using Dynatrace Monaco.

## Prerequisites

Before you can use these scripts, you need to have the Dynatrace Monaco client installed on your system. Follow the steps below to set up the Monaco client.

### Installing Monaco Client

1. **Download the Monaco Client:**
   - You can download the latest version of the Monaco client from the [Dynatrace Monaco Releases](https://github.com/dynatrace-oss/dynatrace-monitoring-as-code/releases) page on GitHub.
   - Choose the appropriate version for your operating system.

2. **Extract and Install:**
   - After downloading, extract the contents of the package.
   - Place the `monaco` binary in a directory that is on your system's PATH. This makes the `monaco` command globally accessible from the command line.

3. **Verify Installation:**
   - To verify that Monaco is installed correctly, open a terminal and type `monaco --version`. You should see the version number of the Monaco client.

## Using the Deployment Scripts

After installing the Monaco client, you can use the deployment scripts in this repository.

### Available Scripts

- `deploy.sh`: Main script for deploying configurations to different environments.

### How to Run

Clone this repository to your local machine  

    cd
    git clone https://github.com/JLLormeau/Monaco_v2
    echo "the lab is copy here "`pwd`"/dynatrace-lab"
    
Install monaco (linux-amd64) and get ready to start  

    cd;cd Monaco_v2/
    curl -L https://github.com/Dynatrace/dynatrace-configuration-as-code/releases/latest/download/monaco-linux-amd64 -o monaco
    chmod +x monaco deploy.sh
    echo "monaco v2 is installed on your host"

Run the script with the desired options. For example:
   - For AWS:  
     
    ./deploy.sh --aws --set-account-name=<name> --set-account-id=<id>
   
   - For Kubernetes:  

    ./deploy.sh --kubernetes --set-cluster-name=<name>
     
   - For Classic Deployment:   

    ./deploy.sh --classic --set-application-name=<name> --set-application-environment=<env>

