pipeline {
    agent any
    environment {
        PATH = "${PATH}:${getTerraformPath()}"
    }
    parameters {
        credentials credentialType: 'com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl', 
        defaultValue: 'stack-prog-creds', name: 'AWS', required: false
     }

    stages{
        stage('Initial Deployment Approval') {
              steps {
                script {
                def userInput = input(id: 'confirm', message: 'Start Pipeline?', 
                    parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, 
                    description: 'Start Pipeline', name: 'confirm'] ])
             }
           }
        }

        stage('terraform init'){
            steps {
                 sh "terraform init -reconfigure"
            }
        }

        stage('terraform plan'){
            steps {
                 sh "terraform plan -out=tfplan -input=false"
            }
        }

        stage('Final Deployment Approval') {
            steps {
                script {
                def userInput = input(id: 'confirm', message: 'Apply Terraform?', 
                    parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, 
                    description: 'Apply terraform', name: 'confirm'] ])
                }
            }
        }

        stage('Terraform Apply'){
            steps {
                 sh "terraform apply  -input=false tfplan"
            }
        }

         stage('Destroy Approval') {
            steps {
                script {
                def userInput = input(id: 'confirm', message: 'Destroy Terraform?', 
                    parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, 
                    description: 'Destroy terraform', name: 'confirm'] ])
                }
            }
        }

        stage('Terraform Destroy'){
            steps {
                 sh "terraform destroy -auto-approve"
            }
        }


    }
}

def getTerraformPath(){
        def tfHome= tool name: 'terraform-40', type: 'terraform'
        return tfHome
    }

