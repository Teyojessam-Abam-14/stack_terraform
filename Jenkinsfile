pipeline {
    agent any
    environment {
        // Calls for the access token
        PATH = "${PATH}:${getTerraformPath()}"
        GITHUB_TOKEN = credentials('github-personal-access-token')
    }
        //Sets environment to have programmatic access using AWS CloudBees credentials
    parameters {
        credentials credentialType: 'com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl', 
        defaultValue: 'stack-prog-creds', name: 'AWS', required: false
    }

    stages {
        stage('Initial Deployment Approval') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: 'Start Pipeline?', 
                        parameters: [[$class: 'BooleanParameterDefinition', defaultValue: false, 
                        description: 'Start Pipeline', name: 'confirm']])
                }
            }
        }

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                script {
                    // Fetches the latest code from GitHub
                    checkout scm: [
                        $class: 'GitSCM', 
                        branches: [[name: '*/stack_clixx_jenkins_whole']], 
                        userRemoteConfigs: [[
                            url: "https://${GITHUB_TOKEN}@github.com/Teyojessam-Abam-14/stack_terraform.git",
                            credentialsId: 'github-personal-access-token'
                        ]],
                        extensions: [[$class: 'CleanBeforeCheckout']]
                    ]

                     // Ensure the local repository is up-to-date with the remote branch
                    sh """
                    git fetch --all
                    git reset --hard origin/stack_clixx_jenkins_whole
                    """
                }
            }
        }

        stage('terraform init') {
            steps {
                script {
                    sh 'rm -rf .terraform'
                    sh 'terraform init -reconfigure'
                }
            }
        }

        stage('terraform plan') {
            steps {
                sh 'terraform plan -out=tfplan -input=false'
            }
        }

        stage('Final Deployment Approval') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: 'Apply Terraform?', 
                        parameters: [[$class: 'BooleanParameterDefinition', defaultValue: false, 
                        description: 'Apply terraform', name: 'confirm']])
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }

        stage('Destroy Approval') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: 'Destroy Terraform?', 
                        parameters: [[$class: 'BooleanParameterDefinition', defaultValue: false, 
                        description: 'Destroy terraform', name: 'confirm']])
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}

def getTerraformPath() {
    def tfHome = tool name: 'terraform-40', type: 'terraform'
    return tfHome
}
