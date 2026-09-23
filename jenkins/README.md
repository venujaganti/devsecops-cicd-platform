# Jenkins Configuration

This directory contains the Jenkins installation and configuration files
for the DevSecOps CI/CD Platform.

## Project Structure

```text
jenkins/
├── README.md
├── install-jenkins.sh
├── install-plugins.sh
├── plugins.txt
└── jenkins.yaml
```

Run `install-jenkins.sh` as root or with `sudo`. After Jenkins is installed and running, use `install-plugins.sh` to install the plugins listed in `plugins.txt`.
