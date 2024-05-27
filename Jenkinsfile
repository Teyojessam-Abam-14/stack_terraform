pipeline {
    agent any
    environment {
        PATH = "${PATH}:${getTerraformPath()}"
        AMI_ID = "stack-ami-${BUILD_NUMBER}"
        VERSION = "1.0.${BUILD_NUMBER}"
    }

    stages {
        stage('Initial Stage') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: 'Start Pipeline?', 
                    parameters: [[$class: 'BooleanParameterDefinition', defaultValue: false, 
                    description: 'Start Pipeline', name: 'confirm']])
                }
            }
        }
        stage('Packer AMI Build') {
            steps {
                sh '''
                cd images
                sed -i "s/ami-stack-[0-9]*/${AMI_ID}/" ./image.pkr.hcl
                export PACKER_LOG=1
                export PACKER_LOG_PATH=$WORKSPACE/packer.log
                /usr/bin/packer plugins install github.com/hashicorp/amazon
                /usr/bin/packer init .
                /usr/bin/packer build -force image.pkr.hcl
                '''
            }
        }
        stage('Terraform Init') {
            steps {
                sh '''
                cd instances
                rm -rf .terraform
                terraform init -upgrade
                '''
            }
        }
        stage('Terraform Plan') {
            steps {
                sh '''
                cd instances
                terraform plan -out=tfplan -input=false
                '''
            }
        }
        stage('Build Instance and Vulnerability Scan') {
            steps {
                sh '''
                cd instances
                terraform apply -auto-approve tfplan
                '''
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
                sh '''
                cd instances
                terraform destroy -auto-approve 
                '''
            }
        }
    }
}

def getTerraformPath() {
    def tfHome = tool name: 'terraform-40', type: 'terraform'
    return tfHome
}

// def getAnsiblePath() {
//     def AnsibleHome = tool name: 'Ansible', type: 'org.jenkinsci.plugins.ansible.AnsibleInstallation'
//     return AnsibleHome
// }

// def getPackerPath() {
//     def PackerHome = tool name: 'Packer', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
//     return PackerHome
// }
